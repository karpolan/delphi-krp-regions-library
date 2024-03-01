{*******************************************************************************

  krpRegions library. Procedures and functions unit.

  Author: KARPOLAN

  Copyright (c) 1996-2005 by KARPOLAN.
  Copyright (c) 2000-2005 ABF software, Inc.
  All Rights Reserved.

  e-mail: info@abf-dev.com
  web:    http://www.abf-dev.com

  The entire contents of this file is protected by International Copyright
Laws. Unauthorized reproduction, reverse engineering, and distribution of all
or any portion of the code contained in this file is strictly prohibited and
may result in severe civil and criminal penalties and will be prosecuted to
the maximum extent possible under the law.

  RESTRICTIONS

  THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED FILES OR ANY
PORTION OF ITS CONTENTS SHALL AT NO TIME BE COPIED, TRANSFERRED, SOLD,
DISTRIBUTED, OR OTHERWISE MADE AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS
WRITTEN CONSENT AND PERMISSION FROM THE ABF SOFTWARE, INC.

  CONSULT THE END USER LICENSE AGREEMENT (EULA) FOR INFORMATION ON ADDITIONAL
RESTRICTIONS.

*******************************************************************************}
unit krpRegionsProcs;

{$I krpRegions.inc}

interface

uses
  Windows, Controls, Graphics, Forms;

//------------------------------------------------------------------------------
// Delay for some mSeconds
procedure krpDelay(MSec: Cardinal);

//------------------------------------------------------------------------------
// Returns a number of color for current video mode
function krpGetSysColorsNumber: LongInt;

//------------------------------------------------------------------------------
// Returns a region created from the AGraphic graphic. AColor is a key value.
// Region contains all pixels of key color if AInverted is False, and all pixels
// of other colors if AInverted is True.
function krpGraphicToRegion(const Graphic: TGraphic; Color: TColor;
  Inverted: Boolean): HRgn;

//------------------------------------------------------------------------------
// Function is a like as krpGraphicToRegion but use default transparent color
// of the graphic as a color-key value.
function krpGraphicToRegionColorDefault(const Graphic: TGraphic;
  Inverted: Boolean): HRgn;

//------------------------------------------------------------------------------
// Draws any picture on the specified bitmap.
function krpPictureToBitmap(const Picture: TPicture;
  const Bitmap: TBitmap): Boolean;

//------------------------------------------------------------------------------
// Returns a rect of the form's caption depending on the BorderStyle property.
function krpGetCaptionRect(const Form: TForm): TRect;

//------------------------------------------------------------------------------
// Returns a region of the form's caption.
function krpGetCaptionRegion(const Form: TForm): HRgn;

//------------------------------------------------------------------------------
// Sets control bounds same to the region bounds
function krpBoundsToRegion(const Control: TControl; Rgn: HRgn): Boolean;

//------------------------------------------------------------------------------
// Applies a region to the WinControl and sets control bounds same to the
// region's bounds.
function krpApplyRgnToControl(const Control: TWinControl; Rgn: HRgn): Boolean;

//------------------------------------------------------------------------------
// Copies desktop area to the given context by StretchBlt, so image will be
// stretched to the specified client rect.
function krpCopyDesktop(DC: HDC; const ClientRect: TRect): Boolean;

//------------------------------------------------------------------------------
// Copies rectangular area of the desktop to the given context by StretchBlt,
// so image will be stretched the specified client rect.
function krpCopyRectFromDesktop(const DC: HDC; const ClientRect,
  DesktopRect: TRect): Boolean;

//------------------------------------------------------------------------------
// Draws a border arround the region by given colors with possibility of
// filling the region area with some color.
procedure krpDrawRegionBorder(DC: HDC; Rgn: HRgn; ColorTopLeft,
  ColorBottomRight, ColorFill: TColor; FillRegion: Boolean);

//------------------------------------------------------------------------------
// Draws a standard 1 point edge arround specified region with possibility of
// filling the region arrea with some color.
procedure krpDrawRegionEdge(DC: HDC; Rgn: HRgn; ColorFill: TColor;
  FillRegion, Down: Boolean);

//------------------------------------------------------------------------------
// Draws a standard full edge arround specified region with possibility of
// filling the region arrea with some color.
procedure krpDrawRegionEdgeStd(DC: HDC; Rgn: HRgn; ColorFill: TColor;
  FillRegion, Down: Boolean);

//------------------------------------------------------------------------------
// Creates a graphic by file extention and load this graphic from file.
// Note: has some memory leak!
function krpCreateGraphicFromFile(const FileName: string): TGraphic;

//------------------------------------------------------------------------------
// Loads a graphic from file
procedure krpLoadGraphicFromFile(const Graphic: TGraphic;
  const FileName: string);

//------------------------------------------------------------------------------
// Loads a picture from file
procedure krpLoadPictureFromFile(const Picture: TPicture;
  const FileName: string);

//------------------------------------------------------------------------------
// Add slash to path string if needed
function krpAddSlash(const Path: string): string;

//------------------------------------------------------------------------------
// Checks directory existing
function krpDirectoryExists(const Path: string): Boolean;

//------------------------------------------------------------------------------
// Expands relative path from BasePath
function krpExpandRelativePathEx(const BasePath, RelativePath: string): string;

//------------------------------------------------------------------------------
// Expands relative path from starting folder of the application }
function krpExpandRelativePath(const RelativePath: string): string;

//------------------------------------------------------------------------------
// Expands relative path from the curent directory, if path doesn't exists,
// expands it from starting folder of the application
function krpSmartExpandRelativePath(const RelativePath: string): string;

//------------------------------------------------------------------------------
// Expands relative file name from BasePath
function krpExpandRelativeFileNameEx(const BasePath, RelativeFileName: string): string;

//------------------------------------------------------------------------------
// Expands relative file name from starting folder of the application
function krpExpandRelativeFileName(const RelativeFileName: string): string;

//------------------------------------------------------------------------------
// Expands relative file name from the curent directory, if path doesn't exists,
// expands file name from starting folder of the application
function krpSmartExpandRelativeFileName(const RelativeFileName: string): string;

//------------------------------------------------------------------------------
// Determines is Delphi/C++Builder IDE running or not
function krpIsDelphiRunning: Boolean;

//------------------------------------------------------------------------------
// Checks trial parameters
procedure krpCheckTrialVersion;

{******************************************************************************}
implementation
{******************************************************************************}

uses
{$IfDef DEBUG}
  Dialogs,
{$EndIf DEBUG}
  krpRegionsConsts, krpRegionsTypes,
  Messages, Classes, SysUtils, MMSystem, ShellApi;

//------------------------------------------------------------------------------
// Delay for some mSeconds

procedure krpDelay(MSec: Cardinal);
var
  BeginTime: Cardinal;
begin
  BeginTime := GetTickCount;
  repeat
    Application.ProcessMessages;
  until Cardinal(Abs(GetTickCount - BeginTime)) >= MSec;
end;

//------------------------------------------------------------------------------
// Returns a number of color for current video mode

function krpGetSysColorsNumber: LongInt;
var
  DesktopWND: HWND;
  DesktopDC: HDC;
begin
  DesktopWND := GetDesktopWindow;
  DesktopDC := GetDC(DesktopWND);
  try
    Result := (LongInt(1) shl GetDeviceCaps(DesktopDC, BITSPIXEL)) *
      LongInt(GetDeviceCaps(DesktopDC, PLANES));
  finally
    ReleaseDC(DesktopWND, DesktopDC);
  end;
end;

//------------------------------------------------------------------------------
// Return a region created from the AGraphic graphic. AColor is a key value.
// Region contains all pixels of key color if AInverted is False, and all pixels
// of other colors if AInverted is True.

const
  cGrowDelta = 1000;
  cMemType   = GMEM_MOVEABLE{GMEM_FIXED};

var
  _GraphicToRegionBMP: TBitmap;
  _GraphicToRegionGlobal: HGlobal;
  _GraphicToRegionNumberOfRects: Cardinal;

function krpGraphicToRegion(const Graphic: TGraphic; Color: TColor;
  Inverted: Boolean): HRgn;
var
  ARgnData: PRgnData;
  ColorKey: TBGRColor;

  //-------------------------------------

  procedure _RectsToRegion;
  var
    ARgn: HRgn;
  begin
    ARgn := ExtCreateRegion(nil, SizeOf(TRgnDataHeader) +
      (SizeOf(TRect) * ARgnData^.rdh.nCount), ARgnData^);
    if Result <> 0 then
    begin
    // Region contains more then 2000 rects, so add new part
{$IfDef DEBUG}
      ShowMessage('DEBUG at krpGraphicToRegion: Region contains more then 2000 rects. It can be a problem under Windows95');
{$EndIf DEBUG}
      CombineRgn(Result, Result, ARgn, rgn_OR);
      DeleteObject(ARgn);
    end else
      Result := ARgn;
  end;{Internal procedure _RectsToRegion}

  //-------------------------------------

  procedure _ResetRgnData;
  begin
    with ARgnData^.rdh do
    begin
      dwSize   := SizeOf(TRgnDataHeader);
      iType    := RDH_Rectangles;
      nCount   := 0;
      nRgnSize := 0;
      rcBound  := Rect(MaxInt, MaxInt, 0, 0);
    end;
  end;{Internal procedure _ResetRgnData}

  //-------------------------------------

  procedure _AddRectToRegion(const ARect: TRect);
  begin
  // Check for big number of Rects
    if ARgnData^.rdh.nCount >= 2000 then
    begin
      _RectsToRegion;
      _ResetRgnData;
    end;

  // Check for memory realocation
    if ARgnData^.rdh.nCount >= _GraphicToRegionNumberOfRects then
    begin
      GlobalUnlock(_GraphicToRegionGlobal);
      Inc(_GraphicToRegionNumberOfRects, cGrowDelta);
      _GraphicToRegionGlobal := GlobalReAlloc(_GraphicToRegionGlobal,
        SizeOf(TRgnDataHeader) + SizeOf(TRect) * _GraphicToRegionNumberOfRects,
        cMemType);
      ARgnData := GlobalLock(_GraphicToRegionGlobal);
    end;

  // Fill RgnData data and fix rcBound
    with ARgnData^.rdh, ARgnData^.rdh.rcBound do
    begin
      PRect(@ARgnData^.Buffer[nCount * SizeOf(TRect)])^ := ARect;
      if ARect.Left   < Left   then Left   := ARect.Left;
      if ARect.Top    < Top    then Top    := ARect.Top;
      if ARect.Right  > Right  then Right  := ARect.Right;
      if ARect.Bottom > Bottom then Bottom := ARect.Bottom;
      Inc(nCount);
    end;
  end;{Internal procedure _AddRectToRegion}

  //-------------------------------------

  procedure _BitmapToRects;
  var
    X, Y: Integer;
    Pixel: PBGRColor;
    ARect: TRect;
    PixelInRegion: Boolean;
    ColorNumber, DeltaColor, Diff: Integer;
  begin
  // Work arround 15/16 bit (32768/65536 colors) video mode bug under NT
    DeltaColor := 1;
    ColorNumber := krpGetSysColorsNumber;
    if (ColorNumber = $8000) or (ColorNumber = $10000) then DeltaColor := 8;

  // Translate pixels to rects
    with _GraphicToRegionBMP, ARect do
      for Y := 0 to Height - 1 do
      begin
        Pixel  := ScanLine[Y];
        Left   := -1;
        Top    := Y;
        Bottom := Y + 1;

      // Run thru line and make rects
        for X := 0 to Width - 1 do
        begin
        // Variant 1
        { PixelInRegion := (Abs(Pixel^.B - ColorKey.B) < DeltaColor) and
           (Abs(Pixel^.G - ColorKey.G) < DeltaColor) and
           (Abs(Pixel^.R - ColorKey.R) < DeltaColor);{}

        // Variant 2
          PixelInRegion := False;
          Diff := (Pixel^.B - ColorKey.B);
          if (Diff < DeltaColor) and (Diff > -DeltaColor) then
          begin
            Diff := (Pixel^.G - ColorKey.G);
            if (Diff < DeltaColor) and (Diff > -DeltaColor) then
            begin
              Diff := (Pixel^.R - ColorKey.R);
              if (Diff < DeltaColor) and (Diff > -DeltaColor) then
                PixelInRegion := True;
            end;
          end;

          if Inverted then PixelInRegion := not PixelInRegion;

        // Separate pixels
          if PixelInRegion then
          begin
          // Pixel in the region
            if Left < 0 then
            begin
            // New rect
              Left  := X;
              Right := X + 1;
            end else
            // Continue previous rect
              Right := X + 1;
          end else
          begin
          // Pixel outside the region
            if Left >= 0 then
            begin
            // End of rect, add it to the region
              _AddRectToRegion(ARect);
              Left := -1;
            end;
          end;{if PixelInRegion else}

        // Prepare next pixel
          Inc(Integer(Pixel), SizeOf(TBGRColor));
        end;{for X := 0 to Width - 1 do}

      // Check for the end of rect
        if Left >= 0 then _AddRectToRegion(ARect);
      end;{for Y := 0 to Height - 1 do}
  end;{Internal procedure _BitmapToRects}

  //-------------------------------------

var
  RegByte: Byte;
  DW: DWord;
begin
  Result := 0;
  if not Assigned(Graphic) then Exit;

  with _GraphicToRegionBMP do
  begin
  // Create a copy of AGraphic
    Width  := Graphic.Width;
    Height := Graphic.Height;
    Canvas.Draw(0, 0, Graphic);

  // Set ColorKey as 00RRGGBB converted from 00GGBBRR
    DW := DWORD(ColorToRGB(Color));
    Move(DW, ColorKey, SizeOf(DW));
    RegByte    := ColorKey.B;
    ColorKey.B := ColorKey.R;
    ColorKey.R := RegByte;

  // Create a Region
    ARgnData := GlobalLock(_GraphicToRegionGlobal);
    _ResetRgnData;
    _BitmapToRects; // Longest routine
    _RectsToRegion;

{$IfDef DEBUG}
    if Result = 0 then ShowMessage('DEBUG at krpGraphicToRegion: Result = 0, Creating of region failed');
{$EndIf DEBUG}
  end;
end;{function krpGraphicToRegion}

//------------------------------------------------------------------------------
// Function is a like as krpGraphicToRegion but use default transparent color
// of the graphic as a color-key value.

function krpGraphicToRegionColorDefault(const Graphic: TGraphic;
  Inverted: Boolean): HRgn;
var
  ABMP: TBitmap;
Begin
  Result := 0;
  if not Assigned(Graphic) then Exit;
  if Graphic is TBitmap then
  begin
    Result := krpGraphicToRegion(Graphic, TBitmap(Graphic).TransparentColor,
      Inverted);
    Exit;
  end;

// Draw 1 pixel of graphics to determine a transparent color
  ABMP := Graphics.TBitmap.Create;
  with ABMP do
  try
    HandleType  := bmDIB;
    PixelFormat := pf32bit;
    Width  := 1;
    Height := 1;
  // Draw 1 pixel which will by a transparent key
    Canvas.Draw(0, 0, Graphic);                      // Variant 1 (TopLeft)
//    Canvas.Draw(0, -(AGraphic.Height - 1), AGraphic); // Variant 2 (BottomLeft)
    TransparentMode := tmAuto;
  // Create region with ABMP.TransparentColor key
    Result := krpGraphicToRegion(Graphic, TransparentColor, Inverted);
  finally
    Free;
  end;
end;{function krpGraphicToRegionColorDefault}

//------------------------------------------------------------------------------
// Draws any picture on the specified bitmap

function krpPictureToBitmap(const Picture: TPicture;
  const Bitmap: TBitmap): Boolean;
begin
  Result := False;
  if not Assigned(Bitmap) then Exit;
  if not Assigned(Picture) or not Assigned(Picture.Graphic) then
  begin
    Bitmap.Assign(nil);
    Exit;
  end;

// Draw picture on the bitmap content
  with Bitmap do
  begin
    Width  := Picture.Width;
    Height := Picture.Height;
    HandleType := bmDIB;
//    PixelFormat := pf32bit;
    Canvas.Draw(0, 0, Picture.Graphic);
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
// Returns a rect of the form's caption depending on the BorderStyle property

function krpGetCaptionRect(const Form: TForm): TRect;
var
  DeltaX, DeltaY, CaptionHeight : Integer;
begin
  if not Assigned(Form) then Exit;

  FillChar(Result, SizeOf(Result), 0);
  DeltaX        := 0;
  DeltaY        := 0;
  CaptionHeight := 0;

  with Form do
  begin
    if (csDesigning in ComponentState) then
    begin
    // At design time caption is not depended on BorderStyle
//       DeltaX        := GetSystemMetrics(SM_CXSizeFrame);
//       DeltaY        := GetSystemMetrics(SM_CYSizeFrame);
//       CaptionHeight := GetSystemMetrics(SM_CYCaption);
    end else
    begin
    // Calculate coordinates depend of BorderStyle
      case BorderStyle of
        Forms.bsSingle: begin
          DeltaX        := GetSystemMetrics(SM_CXFixedFrame);
          DeltaY        := GetSystemMetrics(SM_CYFixedFrame);
          CaptionHeight := GetSystemMetrics(SM_CYCaption);
        end;

        bsSizeable: begin
          DeltaX        := GetSystemMetrics(SM_CXSizeFrame);
          DeltaY        := GetSystemMetrics(SM_CYSizeFrame);
          CaptionHeight := GetSystemMetrics(SM_CYCaption);
        end;

        bsDialog: begin
          DeltaX        := GetSystemMetrics(SM_CXDlgFrame);
          DeltaY        := GetSystemMetrics(SM_CYDlgFrame);
          CaptionHeight := GetSystemMetrics(SM_CYCaption);
        end;

        bsToolWindow: begin
          DeltaX        := GetSystemMetrics(SM_CXFixedFrame);
          DeltaY        := GetSystemMetrics(SM_CYFixedFrame);
          CaptionHeight := GetSystemMetrics(SM_CYSmCaption);
        end;

        bsSizeToolWin: begin
          DeltaX        := GetSystemMetrics(SM_CXSizeFrame);
          DeltaY        := GetSystemMetrics(SM_CYSizeFrame);
          CaptionHeight := GetSystemMetrics(SM_CYSmCaption);
        end;
      end;{case BorderStyle of}
    end;{if (csDesigning in ComponentState) else}

    Result := Rect(0, 0, Width, Height);
    InflateRect(Result, -DeltaX, -DeltaY);
    Result.Bottom := Result.Top + CaptionHeight - 1;
  end;{with AForm do}
end;{function krpGetCaptionRect}

//------------------------------------------------------------------------------
// Returns a region of the form's caption

function krpGetCaptionRegion(const Form: TForm): HRgn;
begin
  Result := CreateRectRgnIndirect(krpGetCaptionRect(Form));
end;

//------------------------------------------------------------------------------
// Sets control bounds same to the region bounds

function krpBoundsToRegion(const Control: TControl; Rgn: HRgn): Boolean;
var
  ARect : TRect;
begin
  Result := False;
  if (not Assigned(Control)) or (Rgn = 0) then Exit;

// Get BoundsRect of region, if region is Empty - Exit
  if GetRgnBox(Rgn, ARect) = NULLREGION then Exit;

// Apply BoundsRect of region to ñontrol's èounds
  with ARect do
    Control.SetBounds(Left, Top, Right - Left, Bottom - Top);
  Result := True;
end;

//------------------------------------------------------------------------------
// Applies a region to the WinControl and sets control bounds same to the
// region's bounds.

function krpApplyRgnToControl(const Control: TWinControl; Rgn: HRgn): Boolean;
var
  ARect: TRect;
  ARegion: HRgn;
begin
  Result := False;
  if (not Assigned(Control)) or (Rgn = 0) then Exit;

// Create an empty Region
  ARegion := CreateRectRgn(0, 0, 0, 0);
  try
  // Copy incoming region to ARegion
    CombineRgn(ARegion, Rgn, ARegion, rgn_Copy);
    if GetRgnBox(ARegion, ARect) <> NULLREGION then
    begin
    // Set control's bounds and move region to client area
      with ARect do
      begin
        Control.SetBounds(Left, Top, Right - Left, Bottom - Top);
        OffsetRgn(ARegion, -Left, -Top);
      end;{with ARect do}

    // Set region to control
      SetWindowRgn(Control.Handle, ARegion, True);
      Result := True;
    end;
  finally
//   DeleteObject(ARegion); // Don't free under win 95...
  end;
end;{function krpApplyRgnToControl}

//------------------------------------------------------------------------------
// Copies desktop area to the given context by StretchBlt, so image will be
// stretched to the specified client rect.

function krpCopyDesktop(DC: HDC; const ClientRect: TRect): Boolean;
var
  DesktopWND: HWND;
  DesktopDC: HDC;
begin
  DesktopWND := GetDesktopWindow;
  DesktopDC := GetDC(DesktopWND);
  with Screen, ClientRect do
  try
//    SendMessage(DesktopWND, WM_PAINT, DesktopDC, 0);
    Result := StretchBlt(DC, Left , Top, Right - Left, Bottom - Top,
      DesktopDC, 0 , 0, Width, Height, SRCCOPY);
  finally
    ReleaseDC(DesktopWND, DesktopDC);
  end;
end;

//------------------------------------------------------------------------------
// Copies rectangular area of the desktop to the given context by StretchBlt,
// so image will be stretched the specified client rect.

function krpCopyRectFromDesktop(const DC: HDC; const ClientRect,
  DesktopRect: TRect): Boolean;
var
  DesktopWND: HWND;
  DesktopDC: HDC;
begin
  DesktopWND := GetDesktopWindow;
  DesktopDC := GetDC(DesktopWND);
  with ClientRect do
  try
//    SendMessage(DesktopWND, WM_PAINT, DesktopDC, 0);
    Result := StretchBlt(DC, Left, Top, Right - Left, Bottom - Top,
      DesktopDC, DesktopRect.Left, DesktopRect.Top,
      (DesktopRect.Right  - DesktopRect.Left),
      (DesktopRect.Bottom - DesktopRect.Top ),
      SRCCOPY);
  finally
    ReleaseDC(DesktopWND, DesktopDC);
  end;
end;

//------------------------------------------------------------------------------
// Draws a border arround the region by given colors with possibility of
// filling the region area with some color.

procedure krpDrawRegionBorder(DC: HDC; Rgn: HRgn; ColorTopLeft,
  ColorBottomRight, ColorFill: TColor; FillRegion: Boolean);
var
  Brush: TBrush;
begin
  if Rgn = 0 then Exit;

  Brush := TBrush.Create;
  try
    Brush.Style := bsSolid;

  // Draw TopLeft part
    OffSetRgn(Rgn, 1, 1);
    Brush.Color := ColorTopLeft;
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);

  // Draw BottomRight part
    Brush.Color := ColorBottomRight;
    OffSetRgn(Rgn, -2, -2);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 1, 1);

  // Fill Region if needed
    if FillRegion then
    begin
      Brush.Color := ColorFill;
      FillRgn(DC, Rgn, Brush.Handle);
    end;
  finally
    Brush.Free;
  end;
end;{procedure krpDrawRegionBorder}

//------------------------------------------------------------------------------
// Draws a standard 1 point edge arround specified region with possibility of
// filling the region arrea with some color.

procedure krpDrawRegionEdge(DC: HDC; Rgn: HRgn; ColorFill: TColor;
  FillRegion, Down: Boolean);
begin
  if Rgn = 0 then Exit;

  if Down then
    krpDrawRegionBorder(DC, Rgn, clBtnShadow, clBtnHighLight, ColorFill,
      FillRegion)
  else
    krpDrawRegionBorder(DC, Rgn, clBtnHighLight, clBtnShadow, ColorFill,
      FillRegion);
end;

//------------------------------------------------------------------------------
// Draws a standard full edge arround specified region with possibility of
// filling the region arrea with some color.

procedure krpDrawRegionEdgeStd(DC: HDC; Rgn: HRgn; ColorFill: TColor;
  FillRegion, Down: Boolean);
var
  Brush: TBrush;
begin
  if Rgn = 0 then Exit;

  Brush := TBrush.Create;
  try
    Brush.Style := bsSolid;

  // Draw Outer Part
    if Down then Brush.Color := clBtnHighLight else Brush.Color := cl3DDkShadow;
    OffSetRgn(Rgn, 2, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, 2);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, -2, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, -2);

    if Down then Brush.Color := cl3DLight else Brush.Color := clBtnShadow;
    OffSetRgn(Rgn, 1, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, 1);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, -1, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, -1);

  // Draw Inner Part
    if Down then Brush.Color := cl3DDkShadow else Brush.Color := clBtnHighLight;
    OffSetRgn(Rgn, -2, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, -2);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 2, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, 2);

    if Down then Brush.Color := clBtnShadow else Brush.Color := cl3DLight;
    OffSetRgn(Rgn, -1, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, -1);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 1, 0);
    FrameRgn(DC, Rgn, Brush.Handle, 1, 1);
    OffSetRgn(Rgn, 0, 1);

  // Fill Region if needed
    if FillRegion then
    begin
      Brush.Color := ColorFill;
      FillRgn(DC, Rgn, Brush.Handle);
    end;

  finally
    Brush.Free;
  end;
end;{procedure krpDrawRegionEdgeStd}

//------------------------------------------------------------------------------
// Creates a graphic by file extention and load this graphic from file.
// Note: has some memory leak!

function krpCreateGraphicFromFile(const FileName: string): TGraphic;
var
  APicture : TPicture;
begin
  APicture := TPicture.Create;
  try
    APicture.LoadFromFile(FileName);
    Result := APicture.Graphic;
  except
    APicture.Free;
    Result := nil;
  end;
end;

//------------------------------------------------------------------------------
// Loads a graphic from file
procedure krpLoadGraphicFromFile(const Graphic: TGraphic;
  const FileName: string);
begin
  if not Assigned(Graphic) then Exit;
  try
    Graphic.LoadFromFile(FileName);
  except
    Graphic.Assign(nil);
  end;
end;

//------------------------------------------------------------------------------
// Loads a picture from file

procedure krpLoadPictureFromFile(const Picture: TPicture;
  const FileName: string);
begin
  if not Assigned(Picture) then Exit;
  try
    Picture.LoadFromFile(FileName);
  except
    Picture.Assign(nil);
  end;
end;

//------------------------------------------------------------------------------
// Add slash to path string if needed

function krpAddSlash(const Path: string): string;
begin
{$IfDef D5}
  Result := IncludeTrailingBackslash(Path);
{$Else D5}
  Result := Path;
  if (Length(Result) > 0) and (Result[Length(Result)] <> '\') then
    Result := Result + '\';
{$EndIf D5}
end;

//------------------------------------------------------------------------------
// Checks directory existing

function krpDirectoryExists(const Path: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Path));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

//------------------------------------------------------------------------------
// Expands relative path from BasePath

function krpExpandRelativePathEx(const BasePath, RelativePath: string): string;
var
  SaveDir: string;
begin
  if RelativePath = '' then
  begin
    Result := krpAddSlash(BasePath);
    Exit;
  end;
  Result := '';
  SaveDir := GetCurrentDir;
  try
    SetCurrentDir(BasePath);
    Result := ExpandFileName(RelativePath);
//    Result := ExpandUNCFileName(RelativePath);
  finally
    SetCurrentDir(SaveDir);
  end;
end;

//------------------------------------------------------------------------------

function krpExpandRelativePath(const RelativePath: string): string;
begin
  Result := krpExpandRelativePathEx(SkrpAppPath, RelativePath);
end;

//------------------------------------------------------------------------------

function krpSmartExpandRelativePath(const RelativePath: string): string;
begin
  Result := krpExpandRelativePathEx(GetCurrentDir, RelativePath);
  if krpDirectoryExists(Result) then Exit;
  Result := krpExpandRelativePath(RelativePath);
end;

//------------------------------------------------------------------------------

function krpExpandRelativeFileNameEx(const BasePath, RelativeFileName: string): string;
var
  FileName: string;
begin
  FileName := ExtractFileName(RelativeFileName);
  Result := krpExpandRelativePathEx(BasePath,
    ExtractFilePath(RelativeFileName)) + FileName;
end;

//------------------------------------------------------------------------------

function krpExpandRelativeFileName(const RelativeFileName: string): string;
begin
  Result := krpExpandRelativeFileNameEx(SkrpAppPath, RelativeFileName);
end;

//------------------------------------------------------------------------------

function krpSmartExpandRelativeFileName(const RelativeFileName: string): string;
begin
  Result := krpExpandRelativeFileNameEx(GetCurrentDir, RelativeFileName);
  if FileExists(Result) then Exit;
  Result := krpExpandRelativeFileName(RelativeFileName);
end;

//------------------------------------------------------------------------------
// Determines is Delphi/C++Builder IDE running or not

function krpIsDelphiRunning: Boolean;
const
  CN3  = 'Builder';
  CN1x = 'Palette';
  CN2x = 'Inspector';
  CN1  = 'Align';
  CN2  = 'Property';
{$IfDef D2_ONLY}WN0 = 'Delphi 2.0';         {$EndIf}
{$IfDef D3_ONLY}WN0 = 'Delphi 3';           {$EndIf}
{$IfDef D4_ONLY}WN0 = 'Delphi 4';           {$EndIf}
{$IfDef D5_ONLY}WN0 = 'Delphi 5';           {$EndIf}
{$IfDef D6_ONLY}WN0 = 'Delphi 6';           {$EndIf}
{$IfDef D7_ONLY}WN0 = 'Delphi 7';           {$EndIf}
{$IfDef D8_ONLY}WNO = 'Borland Delphi 8';   {$EndIf}
{$IfDef D9_ONLY}WN0 = 'Borland Delphi 2005';{$EndIf}

{$IfDef C1_ONLY}WN0 = 'C++Builder';         {$EndIf}
{$IfDef C3_ONLY}WN0 = 'C++Builder';         {$EndIf}
{$IfDef C4_ONLY}WN0 = 'C++Builder 4';       {$EndIf}
{$IfDef C5_ONLY}WN0 = 'C++Builder 5';       {$EndIf}
{$IfDef C6_ONLY}WN0 = 'C++Builder 6';       {$EndIf}
var
  CN0: string;
  H0, H1, H2, H3: HWnd;
begin
  Result := True;

  CN0 := TApplication.ClassName; // 'TApplication'
  H0 := FindWindow(PChar(CN0), PChar(WN0));

// Check only TApplication for Delphi 8 and higher.
// Don't check for TPropertyInspector in Delphi 4 and higher, it can be docked.
  {$IfDef D8}
  Result := (H0 <> 0);
  {$Else D8}
  H1 := FindWindow(PChar(CN0[1] + CN1 + CN1x), nil);
  H2 := FindWindow(PChar(CN0[1] + CN2 + CN2x), nil);
  H3 := FindWindow(PChar(Copy(CN0, 1, 4) + CN3), nil);
  Result := (H0 <> 0) and (H1 <> 0) {$IfNDef D4}and (H2 <> 0){$EndIf D4}
    and (H3 <> 0);
  {$EndIf D8}
end;

//------------------------------------------------------------------------------
// Checks is the version trial. Shows trial message if it is.

var
  _CheckTrialCalled: Boolean = False;

procedure krpCheckTrialVersion;
begin
//  if _CheckTrialCalled then Exit;
  _CheckTrialCalled := True;
  if krpIsDelphiRunning then Exit;
{$IfDef krpRegions_Trial}
  if MessageBoxEx(0, PChar(SkrpMsgTrial), 'Warning',
    MB_YESNO or MB_ICONWARNING, 0) = IDYES then
    ShellExecute(0, 'open', PChar('http://' + SkrpWeb_Register), nil, nil,
      SW_SHOW);
  Halt;
{$EndIf krpRegions_Trial}
end;


{******************************************************************************}
initialization
{******************************************************************************}

//------------------------------------------------------------------------------
// Init krpGraphicToRegion global data
  _GraphicToRegionBMP := TBitmap.Create;
  _GraphicToRegionBMP.HandleType  := bmDIB;
  _GraphicToRegionBMP.PixelFormat := pf32bit;

  _GraphicToRegionNumberOfRects := cGrowDelta;
  _GraphicToRegionGlobal := GlobalAlloc(cMemType, SizeOf(TRgnDataHeader) +
     SizeOf(TRect) * _GraphicToRegionNumberOfRects);

{******************************************************************************}
finalization
{******************************************************************************}

//------------------------------------------------------------------------------
// Free krpGraphicToRegion global data
  GlobalFree(_GraphicToRegionGlobal);
  _GraphicToRegionBMP.Free;

end{unit krpRegionsProcs}.
