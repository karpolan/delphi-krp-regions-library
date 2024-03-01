{*******************************************************************************

  Lens - magnifying glass, Main form unit.

  Author:    KARPOLAN
  E-Mail:    karpolan@ABFsoftware.com, karpolan@i.am
  WEB:       http://www.ABFsoftware.com, http://karpolan.i.am
  Copyright © 1996-2000 by KARPOLAN.
  Copyright © 1999 UtilMind Solutions.
  Copyright © 2000 ABF software, Inc.
  All rights reserved.

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

  DISCLAIMER

  THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS WITHOUT WARRANTY OF ANY KIND,
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE PERSON USING THE
SOFTWARE BEARS ALL RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE.
THE AUTHOR WILL NOT BE LIABLE FOR ANY SPECIAL, INCIDENTAL, CONSEQUENTIAL,
INDIRECT OR SIMILAR DAMAGES DUE TO LOSS OF DATA OR ANY OTHER REASON, EVEN IF
THE AUTHOR OR AN AGENT OF THE AUTHOR HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES. IN NO EVENT SHALL THE AUTHOR'S LIABILITY FOR ANY DAMAGES EVER
EXCEED THE PRICE PAID FOR THE LICENSE TO USE THE SOFTWARE, REGARDLESS OF THE
FORM OF THE CLAIM.

** History: ********************************************************************

  29 oct 1999 - 1.0 first release.
  02 nov 1999 - 1.1 added keyboard support. Skin, position and zoom values
    are stored in the system registry now.
  05 nov 1999 - 1.11 fixed bug under Win95 (Square lens)....
  09 nov 1999 - 1.2 added Help.
  27 nov 1999 - 1.21 Added new features of the krpRegions library version 1.1,
    fixed help file.
  06 jun 2000 - 1.3 Added new features of the krpRegions library version 1.2,
    Now distributed by ABF software, Inc. <http://www.ABFsoftware.com>.
    Some minor changes.
  16 jun 2000 - 1.31 Fixed bug under Windows NT and Windows 2000 in 15/16 bit
    (32768/65536 colors) video modes. Added color value hint.
  25 nov 2000 - 1.4 Upgrade from the web feature. New skin for people with
    poor eyesight. More keyboard control combination: F9 - BIG skin;
    F5, F6, F7, F8, Shift + "+", Shift + "-" - zoom manipulation. Added more
    languages in the installation program.

*******************************************************************************}
unit LensMainForm;

{$I Lens.inc}

interface

uses
{$IfDef D4}
  ImgList,
{$EndIf D4}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, krpRegionsImages, krpRegionsSkingines, krpRegionsSkins,
  krpRegionsDialogs, krpRegionsComponents, krpRegionsGif;

const
  VersionMajor   = 1;
  VersionMinor   = 4;
  VersionRelease = 0;
  VersionBuild   = 116;
  Version = (VersionMajor shl 24) or (VersionMinor shl 16) or
    (VersionRelease shl 8) or VersionBuild;
  SVersion = '1.4.0.116';

  SApplicationTitle = 'Lens - magnifying glass'; // Title of the application

type

//==============================================================================
// TfrmMain
//==============================================================================
// Main form of the program

  TfrmMain = class(TForm)
    skngMain: TkrpColorSkingine;
    pnLinza: TkrpFastDrawingPanel;
      imLinza: TImage;
    imDesktopCopy: TImage;
    sknMain: TkrpSkin;
    sknLoaded: TkrpSkinFile;
    dlgLoadSkin: TkrpOpenSkinDialog;
    imlstMain: TImageList;
  { Popup Menu}
    pmBody: TPopupMenu;
      miRefresh: TMenuItem;
        mi0: TMenuItem;
      miZoomMin: TMenuItem;
      miZoomOut: TMenuItem;
      miZoomIn: TMenuItem;
      miZoomMax: TMenuItem;
        mi1: TMenuItem;
      miLoadSkin: TMenuItem;
      miBigSkin: TMenuItem;
      miDefaultSkin: TMenuItem;
        mi2: TMenuItem;
      miHelp: TMenuItem;
      miAbout: TMenuItem;
        mi3: TMenuItem;
      miClose: TMenuItem;
  { Form events }
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  { Appication events }
    procedure ApplicationRestore(Sender: TObject);
    procedure ApplicationMinimize(Sender: TObject);
  { Misc events }
    procedure Refresh(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure ZoomMinClick(Sender: TObject);
    procedure ZoomMaxClick(Sender: TObject);
    procedure MinimizeClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
  { "Body" region events }
    procedure Region0MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Region0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Region0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  { imLinza events }
    procedure imLinzaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  { Menu/Action events }
    procedure miAboutClick(Sender: TObject);
    procedure miBigSkinClick(Sender: TObject);
    procedure miDefaultSkinClick(Sender: TObject);
    procedure miLoadSkinClick(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure imLinzaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imLinzaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    fZoom: Integer;
  { Messages routines }
    procedure WMEEraseBkGnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
  protected
    fDragged    : Boolean;
    fLoaded     : Boolean;
    fSaveDesktop: Boolean;
    fNotModal   : Boolean;
    fMinimized  : Boolean;
    fSkinName   : string;
 { Misc }
    procedure SaveDesktop;
    procedure SaveDesktopHideAndShow;
    procedure DrawLinza;
    procedure RecreateLinza;
    procedure UpdateGlassState;
    function LoadSkinFromFile(ASkinName: string): Boolean;
    procedure LoadRegData;
    procedure SaveRegData;
 { Properties routines }
    procedure SetZoom(A: Integer); virtual;
 { Properties }
    property Zoom: Integer
      read   fZoom
      write  SetZoom;
  end;{TfrmMain = class(TForm)}

var
  frmMain: TfrmMain;

{******************************************************************************}
implementation
{******************************************************************************}
{$R *.DFM}
uses
  LensAboutForm, krpRegionsProcs, Registry;


//==============================================================================
// TfrmMain
//==============================================================================
// Main form of the program
{ TfrmMain }

const
  DeltaZoom: array[1..8] of Integer = (1, 2, 3, 4, 8, 16, 32, 64);
  cMinZoom = 1;
  cMaxZoom = 8;
  SLensRegKey    = '\Software\ABF software\Lens';
  SLensSkin      = 'Skin';
  SLensZoom      = 'Zoom';
  SLensLeft      = 'Left';
  SLensTop       = 'Top';

//==============================================================================
// Misc

//------------------------------------------------------------------------------

procedure TfrmMain.SaveDesktop;
begin
  if (not fLoaded) or fNotModal then Exit;
  with imDesktopCopy do
  begin
    Picture.Assign(nil); // Reset picture
    Width  := Screen.Width;
    Height := Screen.Height;
  end;
  krpCopyDesktop(imDesktopCopy.Canvas.Handle, imDesktopCopy.ClientRect);
  DrawLinza;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.SaveDesktopHideAndShow;
begin
  if fNotModal or fMinimized or (not fLoaded) or fSaveDesktop then Exit;
  fSaveDesktop := True;
//  try
    ShowWindow(Handle, SW_HIDE);
//    try
      Application.ProcessMessages;
      Sleep(150);
      SaveDesktop;
//    finally
      ShowWindow(Handle, SW_SHOW);
//    end;
//  finally
    fSaveDesktop := False;
//  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.DrawLinza;
var
  SrcRect: TRect;
  APoint: TPoint;
begin
{ Make global rect }
  SrcRect := imLinza.ClientRect;
  APoint  := imLinza.ClientToScreen(Point(0, 0));
  OffsetRect(SrcRect, APoint.X, APoint.Y);
{ Inflate by zoom  }
  InflateRect(SrcRect, -(imLinza.Width - Round(imLinza.Width/DeltaZoom[Zoom]))
    div 2, -(imLinza.Height - Round(imLinza.Height/DeltaZoom[Zoom])) div 2);
{ Copy part of saved Desktop from imSaved to imLinza }
  StretchBlt(imLinza.Canvas.Handle, 0, 0, imLinza.Width, imLinza.Height,
   imDesktopCopy.Canvas.Handle, SrcRect.Left , SrcRect.Top,
     SrcRect.Right  - SrcRect.Left, SrcRect.Bottom - SrcRect.Top, SRCCOPY);
{ Update Image }
  imLinza.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.RecreateLinza;
begin
  krpApplyRgnToControl(pnLinza, skngMain.Regions[1].Region);
  imLinza.Picture := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.UpdateGlassState;
begin
{ If zoom is 1x hide glass region, desktop will be shown thru the hole }
{  if Zoom = 1
   then skngMain.Regions[1].Visible := False
   else skngMain.Regions[1].Visible := True;{}
end;

//------------------------------------------------------------------------------

function TfrmMain.LoadSkinFromFile(ASkinName: string): Boolean;
var
  Save: Boolean;
begin
  Result := True;
  if fSkinName = ASkinName then Exit;

  Result := False;
{ Try to load specified file }
  if not sknLoaded.LoadSkinFromFile(ASkinName) then Exit;

{ Check file project, maybe laded skin is not for our project }
  if CompareText(sknLoaded.SkinFile.Project,
    ExtractFileName(Application.ExeName)) <> 0 then
  begin
    fNotModal := True;
    try
    { Show error }
      MessageBoxEx(Application.Handle,
        PChar(Format('The "%s" skin was designed for other "%s" project, so no skin will be loaded.',
        [ASkinName, sknLoaded.SkinFile.Project])),
        PChar(Application.Title), MB_ICONERROR or MB_OK, 0);
    finally
      fNotModal := False;
    end;
    Exit;
  end;{if..}

{ Apply new skin }
  fSkinName := ASkinName;
  Save := Visible;
  Visible := False;
  try
    skngMain.Skin := sknLoaded;
  { Free some resources }
    sknLoaded.Reset;
    RecreateLinza;
  finally
    Visible := Save;
  end;
{ Update saved desktop }
  Refresh(nil);
  Result := True;
end;{function TfrmMain.LoadSkinFromFile}

//------------------------------------------------------------------------------

procedure TfrmMain.LoadRegData;
var
  ALeft, ATop: Integer;

  //-------------------------------------

  procedure _SetPosition;
  var
    R: TRect;
    RLeft, RTop: Integer;
  begin
    R := skngMain.Regions[0].BoundsRect;
    RLeft := R.Left;
    RTop := R.Top;
    OffsetRect(R, ALeft, ATop);
  { Align the body region in the screen rect }
    if R.Left < 0 then OffsetRect(R, -R.Left, 0);
    if R.Top  < 0 then OffsetRect(R, 0, -R.Top);
    if R.Right  > Screen.Width  then OffsetRect(R, -(R.Right - Screen.Width), 0);
    if R.Bottom > Screen.Height then OffsetRect(R, 0, -(R.Bottom - Screen.Height));
  { Set new position }
    Left := R.Left - RLeft;
    Top  := R.Top - RTop;
  end;{Internal _SetPosition}

  //-------------------------------------

begin
{ Load stored in registry values and load skin if it is needed }
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if OpenKey(SLensRegKey, False) then
    try
      fSkinName := ReadString(SLensSkin);
      if FileExists(fSkinName) then
      begin
        sknLoaded.LoadSkinFromFile(fSkinName);
        skngMain.Skin := sknLoaded;
        sknLoaded.Reset;
      end;
      ALeft  := ReadInteger(SLensLeft);
      ATop   := ReadInteger(SLensTop );
      _SetPosition;
      Zoom := ReadInteger(SLensZoom);
    except
      miDefaultSkinClick(nil);
    end;
  finally
//    CloseKey;
    Free;
  end;{try..finally}
end;{procedure TfrmMain.LoadRegData}

//------------------------------------------------------------------------------

procedure TfrmMain.SaveRegData;
begin
{ Save current values to the system registry }
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if OpenKey(SLensRegKey, True) then
    begin
      WriteString (SLensSkin, fSkinName);
      WriteInteger(SLensZoom, Zoom);
      WriteInteger(SLensLeft, Left);
      WriteInteger(SLensTop , Top);
    end;
  finally
//    CloseKey;
    Free;
  end;
end;


//==============================================================================
// Properties routines

//------------------------------------------------------------------------------

procedure TfrmMain.SetZoom(A: Integer);
begin
  if A > cMaxZoom then A := cMaxZoom;
  if A < cMinZoom then A := cMinZoom;
  if fZoom = A then Exit;
  fZoom := A;
  UpdateGlassState;
  DrawLinza;
end;


//==============================================================================
// Messages routines

//------------------------------------------------------------------------------

procedure TfrmMain.WMEEraseBkGnd(var Message: TMessage);
begin
  Message.Result := 1; // Do nothing, it prevents flickering.
end;

//------------------------------------------------------------------------------

procedure TfrmMain.WMMove(var Message: TMessage);
begin
  inherited;
  if fLoaded and Visible and (not fNotModal) then DrawLinza;
end;


//==============================================================================
// Published by Delphi

//==============================================================================
// Form events

//------------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
{$IfDef D4}
var
  i: Integer;
{$EndIf D4}
begin
  Application.Title := SApplicationTitle;
  fSkinName := '';
  fZoom := cMinZoom;

{ Assign extended properties for Higher Delphi versions }
{$IfDef D4}
  pmBody.Images := imlstMain;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TMenuItem then
      with TMenuItem(Components[i]) do
        ImageIndex := Tag;
{$EndIf D4}

{ Initialize values }
  dlgLoadSkin.InitialDir := ExtractFilePath(Paramstr(0)) + 'skins';
//  dlgLoadSkin.FileName   := fSkinName;
  with Application do
  begin
    HelpFile := ChangeFileExt(ExeName, '.hlp');
    OnRestore  := ApplicationRestore;
    OnMinimize := ApplicationMinimize;
    OnActivate := Refresh;
  end;
  LoadRegData;
  RecreateLinza;
end;{procedure TfrmMain.FormCreate}

//------------------------------------------------------------------------------

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveRegData;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if fNotModal then Exit;
  fLoaded := True;
  UpdateGlassState;
  SaveDesktop;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Position: TPoint;
begin
  FillChar(Position, SizeOf(Position), 0);
{ Check the Key value }
  case Key of
    VK_ESCAPE: skngMain.Regions[5].AnimateClick;
    VK_SPACE: begin
      if ([ssCtrl, ssAlt, ssShift] * Shift = []) then Refresh(nil);
      Exit;
    end;
    VK_F1: begin
      if (ssAlt in Shift) then miAboutClick(nil) else miHelpClick(nil);
      Exit;
    end;
    VK_F3: miLoadSkinClick(nil);
    VK_F5: ZoomMinClick(nil);
    VK_F6: ZoomOutClick(nil);
    VK_F7: ZoomInClick(nil);
    VK_F8: ZoomMaxClick(nil);
    VK_F9: miBigSkinClick(nil);
    VK_F10: miDefaultSkinClick(nil);
    VK_UP: begin
      if (ssCtrl in Shift) then Dec(Position.Y, 20) else
      if (ssShift in Shift) then Dec(Position.Y) else Dec(Position.Y, 5);
    end;
    VK_DOWN: begin
      if (ssCtrl in Shift) then Inc(Position.Y, 20) else
      if (ssShift in Shift) then Inc(Position.Y) else
      if (ssAlt in Shift) then skngMain.Regions[4].AnimateClick
      else Inc(Position.Y, 5);
    end;
    VK_LEFT: begin
      if (ssCtrl in Shift) then Dec(Position.X, 20) else
      if (ssShift in Shift) then Dec(Position.X) else Dec(Position.X, 5);
    end;
    VK_RIGHT: begin
      if (ssCtrl in Shift) then Inc(Position.X, 20) else
      if (ssShift in Shift) then Inc(Position.X) else Inc(Position.X, 5);
    end;
  end;{case Key of}
{ Move form if it is needed }
  if (Position.X <> 0) or (Position.Y <> 0) then
  begin
    Position.X := Position.X + Left;
    if Position.X < -(Width - 25) then Position.X := -(Width - 25) else
    if Position.X > (Screen.Width - 25) then Position.X := (Screen.Width - 25);
    Position.Y := Position.Y + Top;
    if Position.Y < -(Height - 25) then Position.Y := -(Height - 25) else
    if Position.Y > (Screen.Height - 25) then Position.Y := (Screen.Height - 25);
    SetBounds(Position.X, Position.Y, Width, Height);
  end;
end;{procedure TfrmMain.FormKeyDown}

//------------------------------------------------------------------------------

function GetShiftState: TShiftState;
begin
  Result := [];
  if GetKeyState(VK_SHIFT  ) < 0 then Include(Result, ssShift);
  if GetKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
  if GetKeyState(VK_MENU   ) < 0 then Include(Result, ssAlt);
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (ssShift in GetShiftState) then
    case Key of
      '+': ZoomMaxClick(nil); // Max zoom
      '-': ZoomMinClick(nil); // Min zoom
    end
  else
    case Key of
      '+': skngMain.Regions[2].AnimateClick;
      '-': skngMain.Regions[3].AnimateClick;
    end;
end;


//==============================================================================
// Appication events

//------------------------------------------------------------------------------

procedure TfrmMain.ApplicationRestore(Sender: TObject);
begin
  fMinimized := False;
  SaveDesktopHideAndShow;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.ApplicationMinimize(Sender: TObject);
begin
  fMinimized := True;
end;


//==============================================================================
// Misc events

//------------------------------------------------------------------------------

procedure TfrmMain.Refresh(Sender: TObject);
begin
  if (not fLoaded) or fNotModal or fMinimized then Exit;
  SaveDesktopHideAndShow;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.ZoomInClick(Sender: TObject);
begin
  Zoom := Zoom + 1;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.ZoomOutClick(Sender: TObject);
begin
  Zoom := Zoom - 1;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.ZoomMinClick(Sender: TObject);
begin
  Zoom := cMinZoom;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.ZoomMaxClick(Sender: TObject);
begin
  Zoom := cMaxZoom;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.CloseClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.MinimizeClick(Sender: TObject);
begin
//  Application.Minimize; // Doesn't work under D5 or higher...
  ShowWindow(Application.Handle, SW_MINIMIZE);
  fMinimized := True;
end;


//==============================================================================
// "Body" region events

//------------------------------------------------------------------------------

procedure TfrmMain.Region0MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then fDragged := True;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.Region0MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then fDragged := False;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.Region0MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if not (ssLeft in Shift) then fDragged := False
end;


//==============================================================================
// imLinza events

//------------------------------------------------------------------------------
// On left mouse down - make pressed point a center point of the glass. The hint
// are changed to show a color value of a point under cursor.

type
  TRGBColor = packed record
    R, G, B, A: Byte;
  end;

procedure TfrmMain.imLinzaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  sColorMask = 'HEX = {%.2x; %.2x; %.2x}' +
         #13#10'RGB = {%0:d; %1:d; %2:d}';
var
  APoint : TPoint;
  HalfWidth, HalfHeight: Integer;
  ColorValue: TRGBColor;
  XSign, YSign: Integer;
begin
{ Responds only left click }
  if Button <> mbLeft then Exit;
  with TImage(Sender) do
  begin
    HalfWidth  := (Width  div 2);
    HalfHeight := (Height div 2);
  { Get a coord of (0;0) point at saved screen surface }
    APoint.X := HalfWidth  - Round(HalfWidth  / DeltaZoom[Zoom]);
    APoint.Y := HalfHeight - Round(HalfHeight / DeltaZoom[Zoom]);
    APoint := ClientToScreen(APoint);
  end;
{ Get a coord of (X;Y) point at saved screen surface }
  APoint.X := APoint.X + Round(X / (DeltaZoom[Zoom]));
  APoint.Y := APoint.Y + Round(Y / (DeltaZoom[Zoom]));
  if Round(X / (DeltaZoom[Zoom])) > Trunc(X / (DeltaZoom[Zoom])) then
    XSign := -1 * (Zoom div 2)
  else
    XSign := 1 * (Zoom div 2);
  if Round(Y / (DeltaZoom[Zoom])) > Trunc(Y / (DeltaZoom[Zoom])) then
    YSign := -1 * (Zoom div 2)
  else
    YSign := 1 * (Zoom div 2);
{ Offset point to be a coord of the form so (X;Y) became a center of the Linza }
  APoint.X := APoint.X - (pnLinza.Left + HalfWidth);
  APoint.Y := APoint.Y - (pnLinza.Top + HalfHeight);
{ Set new form position }
  SetBounds(APoint.X, APoint.Y, Width, Height);
{ Move Cursor to the center of Linza }
  APoint := imLinza.ClientToScreen(Point(HalfWidth + XSign, HalfHeight + YSign));
  SetCursorPos(APoint.X, APoint.Y);
{ Set hint value to the color value }
  with TImage(Sender) do
  begin
    APoint := ScreenToClient(APoint);
    ColorValue := TRGBColor(ColorToRGB(Canvas.Pixels[APoint.X, APoint.Y]));
    with ColorValue do
      Hint := Format(sColorMask, [R, G, B]);
    ShowHint := False;
    ShowHint := True;
  end
end;{procedure TfrmMain.imLinzaMouseDown}

//------------------------------------------------------------------------------

procedure TfrmMain.imLinzaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with TImage(Sender) do
    ShowHint := False;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.imLinzaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Do nothing.
end;


//==============================================================================
// Menu/Action events

//------------------------------------------------------------------------------

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
{ Show about without any desktop update }
  fNotModal := True;
  try
    LensAbout;
  finally
    fNotModal := False
  end;
{ Update saved desktop }
  Refresh(nil);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.miHelpClick(Sender: TObject);
begin
  Application.HelpJump(''); // default help topic
{ Update saved desktop }
  Refresh(nil);
end;

//------------------------------------------------------------------------------

procedure TfrmMain.miDefaultSkinClick(Sender: TObject);
begin
  if skngMain.Skin = sknMain then Exit;
  fSkinName := '';
{ Set a default skin to the skingine }
  skngMain.Skin := sknMain;
  RecreateLinza;
{ Update saved desktop }
  Refresh(nil);
{ Free some resources }
  sknLoaded.Reset;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.miBigSkinClick(Sender: TObject);
begin
  LoadSkinFromFile(ExtractFilePath(ParamStr(0)) + 'skins\BIG\skin.ini');
end;

//------------------------------------------------------------------------------

procedure TfrmMain.miLoadSkinClick(Sender: TObject);
var
  Save: Boolean;
begin
{ Set flag to prevent the form from "top most jumping" }
  fNotModal := True;
  try
    Save := dlgLoadSkin.Execute
  finally
    fNotModal := False;
  end;
{ Exit if dialog is canceled }
  if not Save then Exit;
{ Load skin from file }
  LoadSkinFromFile(dlgLoadSkin.FileName)
end;

//------------------------------------------------------------------------------


end{Unit LensMainForm}.
