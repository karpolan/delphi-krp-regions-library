{*******************************************************************************

  krpRegions library. Base components.

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
unit krpRegionsComponents;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, classes, Graphics, ExtCtrls, Controls, Forms,
  krpRegionsTypes;

type

//==============================================================================
// TkrpCustomControlRegion
//==============================================================================
// This component is a satellite for WinControl. Provide a region support for
// linked WinControl. Region creates from MaskImage or own MaskPicture by
// MaskColor. WinControl position and size can be controled by component using
// PosToRegion, SizeToRegion and RegionToClient properties. Component allows
// drag a WinControl's owner form by client area if FormDrag property is True.

  TkrpCustomControlRegion = class(TComponent)
  private
    FAbout: string;
    FOnChange: TNotifyEvent;
  protected
    FRegion, FTopLeftRegion, FBottomRightRegion: TkrpRegion;
    FWinControl: TWinControl;
    FMaskImage: TImage;
    FMaskPicture: TPicture;
    FMaskColor: TColor;
    FInverted: Boolean;
    FBorderStyle: TkrpBorderStyle;
    FBorderLowered: Boolean;
    FSizeToRegion: Boolean;
    FPosToRegion: Boolean;
    FRegionToClient: Boolean;
    FOffsetY: Integer;
    FOffsetX: Integer;
    FFormDrag: Boolean;
    FOldWndProc: TFarProc;
    FNewWndProc: Pointer;
    FOldWndHandle: THandle;
  // Override this
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  // Region routines
    procedure ApplyRegion; virtual;
    procedure FreeRegion; virtual;
  // Hook routines
    procedure HookControl; virtual;
    procedure UnHookControl; virtual;
    function HookControlVerify: Boolean; virtual;
    procedure CallDefault(var Message: TMessage); virtual;
    procedure HookWndProc(var Message: TMessage); virtual;
  // Properties Get/Set
    procedure SetWinControl(A: TWinControl); virtual;
    procedure SetBorderStyle(A: TkrpBorderStyle); virtual;
    procedure SetBorderLowered(A: Boolean); virtual;
    procedure SetSizeToRegion(A: Boolean); virtual;
    procedure SetPosToRegion(A: Boolean); virtual;
    procedure SetRegionToClient(A: Boolean); virtual;
    procedure SetOffsetX(A: Integer); virtual;
    procedure SetOffsetY(A: Integer); virtual;
    procedure SetMaskImage(const A: TImage); virtual;
    procedure SetMaskPicture(const A: TPicture); virtual;
    procedure SetMaskColor(A: TColor); virtual;
    procedure SetInverted(A: Boolean); virtual;
  // Event routines
    procedure DoChange; dynamic;
  // Properties
    property About: string read FAbout write FAbout stored False;
    property BorderStyle: TkrpBorderStyle read FBorderStyle
      write SetBorderStyle default bsNone;
    property BorderLowered: Boolean read FBorderLowered write SetBorderLowered
      default False;
    property SizeToRegion: Boolean read FSizeToRegion write SetSizeToRegion
      default True;
    property PosToRegion: Boolean read FPosToRegion write SetPosToRegion
      default False;
    property RegionToClient: Boolean read FRegionToClient
      write SetRegionToClient default True;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 0;
    property OffsetY: Integer read FOffsetY write SetOffsetY default 0;
  // Events
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
  // Init/Done
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  // Region Routines
    procedure ReCreateRegion; virtual;
  // Properties
    property Region: TkrpRegion read FRegion;
    property MaskImage: TImage read FMaskImage write SetMaskImage;
    property MaskPicture: TPicture read FMaskPicture write SetMaskPicture;
    property MaskColor: TColor read FMaskColor write SetMaskColor
      default $00000000;
    property Inverted: Boolean read FInverted write SetInverted default False;
    property FormDrag: Boolean read FFormDrag write FFormDrag default False;
    property WinControl: TWinControl read FWinControl write SetWinControl;
  end;{TkrpCustomControlRegion = class(TComponent)}


//==============================================================================
// TkrpControlRegion
//==============================================================================
// This component is a descendant TkrpCustomControlRegion with published
// properties, so it can be used at design-time.

  TkrpControlRegion = class(TkrpCustomControlRegion)
  published
  // Properties
    property About;
    property MaskImage;
    property MaskPicture;
    property MaskColor;
    property Inverted;
    property FormDrag;
    property WinControl;
    property BorderStyle;
    property BorderLowered;
    property SizeToRegion;
    property PosToRegion;
    property RegionToClient;
    property OffsetX;
    property OffsetY;
  // Events
    property OnChange;
  end;


//==============================================================================
// TkrpControlRegion
//==============================================================================
// Descendant of TPanel with disabled EraseBackGround, so this controls are
// drawn more faster and without blinking.

  TkrpFastDrawingPanel = class(TPanel)
  private
    FAbout: string;
    procedure WMEEraseBkGnd(var Message: TMessage); message WM_ERASEBKGND;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property About: string read FAbout write FAbout stored False;
  end;


{******************************************************************************}
implementation
{******************************************************************************}
uses
  krpRegionsProcs;

type
  THackWinControl = class(TWinControl);

//==============================================================================
// TkrpControlRegionTimer
//==============================================================================
// Timer for TkrpCustomControlRegion component

  TkrpControlRegionTimer = class(TTimer)
    constructor CreateRehook(AOwner: TComponent; AInterval: Cardinal);
    procedure OnTimerRehook(Sender: TObject);
  end;

{ TkrpControlRegionTimer }

constructor TkrpControlRegionTimer.CreateRehook(AOwner: TComponent; AInterval: Cardinal);
begin
  Create(AOwner);
  Interval := AInterval;
  OnTimer := OnTimerRehook;
  Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TkrpControlRegionTimer.OnTimerRehook(Sender: TObject);
begin
  if Owner is TkrpCustomControlRegion then
  begin
    Enabled := not TkrpCustomControlRegion(Owner).HookControlVerify;
    if Enabled then Exit;
  end;

// Free timer after work
  Free;
end;


//==============================================================================
// TkrpCustomControlRegion
//==============================================================================
// This component is a satellite for WinControl. Provide a region support for
// linked WinControl. Region creates from MaskImage or own MaskPicture by
// MaskColor. WinControl position and size can be controled by component using
// PosToRegion, SizeToRegion and RegionToClient properties. Component allows
// drag a WinControl's owner form by client area if FormDrag property is True.
{ TkrpCustomControlRegion }

constructor TkrpCustomControlRegion.Create(AOwner: TComponent);
begin
  fMaskPicture := TPicture.Create;
  inherited Create(AOwner);
  krpCheckTrialVersion;
  fBorderStyle    := bsNone;
  fBorderLowered  := False;
  fSizeToRegion   := True;
  fPosToRegion    := False;
  fRegionToClient := True;
  fOffsetX        := 0;
  fOffsetY        := 0;
  fMaskColor      := $00000000;
  fInverted       := False;
  fFormDrag       := False;
  fWinControl     := nil;
  fMaskImage      := nil;
  fRegion         := nil;
  FNewWndProc     := nil;
  FOldWndProc     := nil;
  FOldWndHandle   := 0;
end;

//------------------------------------------------------------------------------

destructor TkrpCustomControlRegion.Destroy;
begin
  UnHookControl;
  FreeRegion;
  inherited Destroy;
  fMaskPicture.Free;
  fMaskPicture := nil;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.ReCreateRegion;
begin
// Don't do it on Loading and Destroying
  if [csLoading, csReading, csDestroying] * ComponentState <> [] then Exit;

// Free ald region if any
  FreeRegion;

// Create new region
  if Assigned(MaskPicture.Graphic) then
  begin
    if not (MaskPicture.Graphic.Empty) then
      fRegion := TkrpRegion.CreateFromMask(MaskPicture.Graphic, MaskColor,
        Inverted)
    else
      fRegion := TkrpRegion.CreateEmpty;
  end else
  if Assigned(MaskImage) then
  begin
    with MaskImage do
      if Assigned(Picture.Graphic) and not (Picture.Graphic.Empty) then
        fRegion := TkrpRegion.CreateFromMask(Picture.Graphic, MaskColor,
          Inverted)
      else
        fRegion := TkrpRegion.CreateEmpty;
  end;

// Apply new region
  ApplyRegion;
end;{procedure TkrpCustomControlRegion.ReCreateRegion}

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.Loaded;
begin
  inherited Loaded;
  RecreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = MaskImage then MaskImage := nil else
    if AComponent = WinControl then WinControl := nil
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.ApplyRegion;
var
  ARect: TRect;
begin
// Don't do it on Loading and Destroying
  if [csLoading, csReading, csDestroying] * ComponentState <> [] then Exit;

  if Assigned(Region) and Assigned(WinControl) and WinControl.HandleAllocated then
    with WinControl do
    begin
    // Check is empty
      if GetRgnBox(fRegion.Region, ARect) = NULLREGION then
      begin
        SetWindowRgn(Handle, 0, True);
        DoChange;
        Exit;
      end;

    // Set position of control by region position if needed
      if PosToRegion then
        with WinControl do
          SetBounds(ARect.Left, ARect.Top, Width, Height);

    // Set size of control by region size if needed
      if SizeToRegion then
        with WinControl do
          SetBounds(Left, Top, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);

    // Move region
      if RegionToClient then
        with ARect do
          OffsetRgn(Region.Region, -Left, -Top);

      OffsetRgn(Region.Region, OffsetX, OffsetY);

    // Create TopLeft region
      fTopLeftRegion := TkrpRegion.CreateAsRegionCopy(Region.Region, 0);
      OffsetRgn(fTopLeftRegion.Region, 1, 1);
      CombineRgn(fTopLeftRegion.Region, Region.Region,
        fTopLeftRegion.Region, RGN_DIFF);

    // Create BottomRight region
      fBottomRightRegion := TkrpRegion.CreateAsRegionCopy(Region.Region, 0);
      OffsetRgn(fBottomRightRegion.Region, -1, -1);
      CombineRgn(fBottomRightRegion.Region, Region.Region,
        fBottomRightRegion.Region, RGN_DIFF);

    // Set region to WinControl
//      SetWindowRgn(Handle, fRegion.Region, Visible);
      SetWindowRgn(Handle, fRegion.Region, True);
    end;{with WinControl do}

  DoChange;
end;{procedure TkrpCustomControlRegion.ApplyRegion}

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.FreeRegion;
begin
// Don't do it on Loading and Destroying
  if [csLoading, csReading, csDestroying] * ComponentState <> [] then Exit;

  if Assigned(WinControl) and WinControl.HandleAllocated then
  begin
    SetWindowRgn(WinControl.Handle, 0, True);
    WinControl.Invalidate;
  end;

// Free all regions
  if Assigned(Region) then Region.Free;
  fRegion := nil;
  if Assigned(fTopLeftRegion) then fTopLeftRegion.Free;
  fTopLeftRegion := nil;
  if Assigned(fBottomRightRegion) then fBottomRightRegion.Free;
  fBottomRightRegion := nil;
end;

//------------------------------------------------------------------------------
// Hook routines

procedure TkrpCustomControlRegion.HookControl;
begin
  if Assigned(WinControl) then
    with WinControl do
    begin
      FOldWndProc := TFarProc(GetWindowLong(Handle, GWL_WndProc));
      FNewWndProc := MakeObjectInstance(HookWndProc);
      SetWindowLong(Handle, GWL_WndProc, LongInt(FNewWndProc));

      FOldWndHandle := Handle;
     end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.UnHookControl;
begin
// Set saved WndProc to WinControl
  if Assigned(WinControl) and WinControl.HandleAllocated and
    Assigned(FOldWndProc) then
    SetWindowLong(WinControl.Handle, GWL_WndProc, LongInt(FOldWndProc));

  if Assigned(FNewWndProc) then FreeObjectInstance(FNewWndProc);

  FNewWndProc := nil;
  FOldWndProc := nil;
  FOldWndHandle := 0;
end;

//------------------------------------------------------------------------------

function TkrpCustomControlRegion.HookControlVerify: Boolean;
begin
  Result := False;
  if Assigned(WinControl) and WinControl.HandleAllocated
    and (WinControl.Handle <> FOldWndHandle) then
  begin
    HookControl;
    ReCreateRegion;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.CallDefault(var Message : TMessage);
begin
  with Message, WinControl do
    Result := CallWindowProc(FOldWndProc, Handle, Msg, wParam, lParam)
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.HookWndProc(var Message : TMessage);
var
  ADC: HDC;
  ABrush: TBrush;
  Color1, Color2, Color3, Color4: TColor;

  //-----------------------------------

  procedure _DrawSingleBorder;
  begin
  // Draw TopLeft part
    ABrush.Color := Color1;
    FillRgn(ADC, fTopLeftRegion.Region, ABrush.Handle);

  // Draw BottomRight part
    ABrush.Color := Color2;
    FillRgn(ADC, fBottomRightRegion.Region, ABrush.Handle);
  end;

  //-----------------------------------

  procedure _DrawDoubleBorder;
  begin
  // Draw TopLeft Inner part
    OffsetRgn(fTopLeftRegion.Region, 1, 1);
    ABrush.Color := Color3;
    FillRgn(ADC, fTopLeftRegion.Region, ABrush.Handle);
    OffsetRgn(fTopLeftRegion.Region, -1, -1);
  // Draw BottomRight Inner part
    OffsetRgn(fBottomRightRegion.Region, -1, -1);
    ABrush.Color := Color2;
    FillRgn(ADC, fBottomRightRegion.Region, ABrush.Handle);
    OffsetRgn(fBottomRightRegion.Region, 1, 1);
  // Draw TopLeft Outer part
    ABrush.Color := Color1;
    FillRgn(ADC, fTopLeftRegion.Region, ABrush.Handle);
  // Draw BottomRight Outer part
    ABrush.Color := Color4;
    FillRgn(ADC, fBottomRightRegion.Region, ABrush.Handle);
  end;{Internal procedure _DrawDoubleBorder}

  //-----------------------------------

begin
  if not (Assigned(WinControl) and WinControl.HandleAllocated) then Exit;

  case Message.Msg of
    WM_DESTROY: begin
      UnHookControl;
    // if WinControl recreates handle, we need rehook it with new handle.
      if not (csDestroying in WinControl.ComponentState) then
        TkrpControlRegionTimer.CreateRehook(Self, 100);
    end;

    WM_Paint: begin

      CallDefault(Message);
      if BorderStyle = bsNone then Exit;

      ADC := GetWindowDC(WinControl.Handle);
      try
        ABrush := TBrush.Create;
        try
          ABrush.Style := bsSolid;

        // Prepare colors
          if BorderLowered then
          begin
            Color2 := clBtnHighLight;
            Color1 := clBtnShadow;
            Color4 := cl3DLight;
            Color3 := cl3DDkShadow;
          end else
          begin
            Color1 := clBtnHighLight;
            Color2 := clBtnShadow;
            Color3 := cl3DLight;
            Color4 := cl3DDkShadow;
          end;

        // Draw border
          if BorderStyle = bsSingle then
            _DrawSingleBorder
          else
            _DrawDoubleBorder;

        finally
          ABrush.Free;
        end;
      finally
        ReleaseDC(WinControl.Handle, ADC)
      end;

      Exit;
    end;{case of WM_Paint}

    WM_LButtonDown: begin
      CallDefault(Message);

    // Drag form if needed
      if (not (csDesigning in ComponentState)) and FormDrag then
      begin
        ReleaseCapture;
        if (Owner is TControl) then
          TControl(Owner).Perform(WM_SYSCOMMAND, SC_MOVE or htCaption, 0);
      end;

      Exit;
    end;{case of WM_LButtonDown}

  end;{case Message.Msg of}

  CallDefault(Message);
end;{procedure TkrpCustomControlRegion.HookWndProc}

//------------------------------------------------------------------------------
// Properties Get/Set

procedure TkrpCustomControlRegion.SetWinControl(A: TWinControl);
begin
  if fWinControl = A then Exit;
// Release old
  UnHookControl;
  FreeRegion;
// Set new
  fWinControl := A;
  if Assigned(fWinControl) then
  begin
    RecreateRegion;
    HookControl;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetBorderStyle(A: TkrpBorderStyle);
begin
  if fBorderStyle = A then Exit;
  fBorderStyle := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetBorderLowered(A: Boolean);
begin
  if fBorderLowered = A then Exit;
  fBorderLowered := A;
  if Assigned(fWinControl) then fWinControl.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetSizeToRegion(A: Boolean);
begin
  if fSizeToRegion = A then Exit;
  fSizeToRegion := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetPosToRegion(A: Boolean);
begin
  if fPosToRegion = A then Exit;
  fPosToRegion := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetRegionToClient(A: Boolean);
begin
  if fRegionToClient = A then Exit;
  fRegionToClient := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetOffsetX(A: Integer);
begin
  if fOffsetX = A then Exit;
  fOffsetX := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetOffsetY(A: Integer);
begin
  if fOffsetY = A then Exit;
  fOffsetY := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetMaskImage(const A: TImage);
begin
  if fMaskImage = A then Exit;
  fMaskImage := A;
// Recreate Region only if no MaskPicture graphic are present
  if Assigned(fMaskPicture.Graphic) and not (fMaskPicture.Graphic.Empty) then
    Exit;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetMaskPicture(const A: TPicture);
begin
  if fMaskPicture = A then Exit;
  fMaskPicture.Assign(A);
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetMaskColor(A: TColor);
begin
  if fMaskColor = A then Exit;
  fMaskColor := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomControlRegion.SetInverted(A:  Boolean);
begin
  if fInverted = A then Exit;
  fInverted := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------
// Event routines

procedure TkrpCustomControlRegion.DoChange;
begin
  if Assigned(fOnChange) then fOnChange(Self);
end;


//==============================================================================
// TkrpFastDrawingPanel
//==============================================================================
// Descendant of TPanel with disabled EraseBackGround, so this controls are
// drawn more faster and without blinking.
{ TkrpFastDrawingPanel }

constructor TkrpFastDrawingPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
end;

//------------------------------------------------------------------------------

procedure TkrpFastDrawingPanel.WMEEraseBkGnd(var Message: TMessage);
begin
  Message.Result := 1;
end;


{******************************************************************************}
initialization
{******************************************************************************}
{$IfDef krpRegions_Trial}
  krpCheckTrialVersion;
{$EndIf krpRegions_Trial}

end{Unit krpRegionsComponents}.
