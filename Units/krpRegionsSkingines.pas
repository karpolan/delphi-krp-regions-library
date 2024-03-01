{*******************************************************************************

  krpRegions library. Skingines.

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
unit krpRegionsSkingines;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, SysUtils, classes, Graphics, Controls,
  krpRegionsCollections, krpRegionsCollectionItems, krpRegionsDesc,
  krpRegionsTypes, krpRegionsConsts, krpRegionsImages, krpRegionsSkins;

type
  EkrpSkingine = class(Exception);

//==============================================================================
// TkrpCustomSkingine
//==============================================================================
// Prototype of Skin/Region Engines (Skingines) components. Contains a
// collection of Regions. Items of that collection hold own simple regions.
// The instance creates a complex Region from Mask and set this region to the
// Owner (TForm). When a ShowCaption property is True, region of Owner's
// caption is added to the complex Region, so the caption become visible.
// An order of Items in the Regions collection is a Z order (Top most captures
// the mouse input, so the TopMost region should be the Last in collection).
//  WARNING !!! Only one TkrpCustomSkingine or its descendant component is
// allowed on a Form at the same time.
//  WARNING !!! Don't use Hint and Cursor property directly because it can be
// changed by Regions at runtime.

  TkrpCustomSkingine = class(TkrpCustomRegionImage)
  private
    FShowCaption: Boolean;
    FFormResize: Boolean;
    FRegionToForm: Boolean;
    FPaintRegionByRect: Boolean;
    FOnChange: TNotifyEvent;
  // Messages
    procedure WMEraseBkgnd(var Message: TMessage); message WM_EraseBkgnd;
    procedure WMSize(var Message: TMessage); message WM_Size;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure KRRegionRecreate(var Message: TMessage); message KR_RegionRecreate;
    procedure KRRegionActivate(var Message: TKRRegion); message KR_RegionActivate;
    procedure KRRegionDeactivate(var Message: TKRRegion); message KR_RegionDeactivate;
    procedure KRUpdateRegionArea(var Message: TKRUpdateRegionArea); message KR_UpdateRegionArea;
  protected
    FLoaded: Boolean; // Override previous flag
    FRegions: TkrpRegionCollection;
    FActiveRegion: TkrpRegionCollectionItem;
    FBitmaps: TkrpRunTimeBitmapDesc;
    FSkin: TkrpCustomSkin;
    FMousePos: TPoint;
    FNeedRedraw, FRegionChanging: Boolean;
    FOldParentWndProc: TFarProc;
    FNewParentWndProc: Pointer;
    FOldParentHandle: THandle;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
    procedure SetParent(AParent: TWinControl); override;
  // Misc
    procedure CreateRegionsCollection; virtual;
    function IsBitmapsStored: Boolean; virtual;
    procedure UpdateCursor; virtual;
    procedure SendCancelModeToRegions; virtual;
    procedure SelectRegionUnderCursor; virtual;
  // Parent hook
    procedure HookParent; virtual;
    procedure UnHookParent; virtual;
    function HookParentVerify: Boolean; virtual;
    procedure HookParentWndProc(var Message: TMessage); virtual;
  // Event handlers
    procedure DoChange; dynamic;
  // Properties Get/Set
    procedure SetActiveRegion(const A: TkrpRegionCollectionItem); virtual;
    procedure SetRegions(const A: TkrpRegionCollection); virtual;
    procedure SetBitmaps(const A: TkrpRunTimeBitmapDesc); virtual;
    procedure SetSkin(const A: TkrpCustomSkin); virtual;
    function GetOwnerOffsetX: Integer; virtual;
    function GetOwnerOffsetY: Integer; virtual;
    procedure SetRegionToForm(A: Boolean); virtual;
    procedure SetShowCaption(A: Boolean); virtual;
    procedure SetFormResize(A: Boolean); virtual;
  // Events
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  // Region routines
    procedure ReCreateRegion; override;
    procedure ApplyRegion; virtual;
    procedure RemoveRegion; virtual;
    function RegionAtPos(const Pos: TPoint;
      AllowDisabled: Boolean): TkrpRegionCollectionItem; virtual;
  // Misc
    procedure ResizeForm; virtual;
    procedure Update; override;
  // Properties
    property Regions: TkrpRegionCollection read FRegions write SetRegions;
    property ActiveRegion: TkrpRegionCollectionItem read fActiveRegion
      write SetActiveRegion;
    property Mask stored IsBitmapsStored;
    property MaskColor stored IsBitmapsStored;
    property Bitmaps: TkrpRunTimeBitmapDesc read FBitmaps write SetBitmaps
      stored IsBitmapsStored;
    property Skin: TkrpCustomSkin read FSkin write SetSkin;
    property MousePos: TPoint read FMousePos;
    property OwnerOffsetX: Integer read GetOwnerOffsetX;
    property OwnerOffsetY: Integer read GetOwnerOffsetY;
    property RegionToForm: Boolean read FRegionToForm write SetRegionToForm
      default True;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption
      default False;
    property ShowMaskInDesigner default False;
    property FormResize: Boolean read FFormResize write SetFormResize
      default True;
    property PaintRegionByRect: Boolean read FPaintRegionByRect
      write FPaintRegionByRect default False;
  end;{TkrpCustomSkingine = class(TkrpCustomRegionImage)}


//==============================================================================
// TkrpRectSkingine
//==============================================================================
// Rect regions skingine

  TkrpRectSkingine = class(TkrpCustomSkingine)
  protected
    procedure CreateRegionsCollection; override;
  published
  // Properties
    property About;
    property Bitmaps;
    property Enabled;
    property FormResize;
    property FormDrag;
    property Mask;
    property MaskColor;
    property ParentShowHint;
    property PopupMenu;
    property RegionToForm;
    property Regions;
    property ShowCaption;
    property ShowHint;
    property ShowMaskInDesigner;
    property Skin;
    property Transparent;
    property Visible;
  // Events
    property OnChange;
  end;


//==============================================================================
// TkrpColorSkingine
//==============================================================================
// This component is a realization of the AREA_BY_COLOR™ algorithm by KARPOLAN.
// A Descendant of TkrpCustomSkingine so works like it, Contains collection of
// TkrpColorRegionCollectionItem, each Item holds a simple region created from
// Mask of the Skingine or from the OwnMask by color key. The TkrpColorSkingine
// combines all Regions to one and set this complex Region to the Owner (TForm).

  TkrpColorSkingine = class(TkrpCustomSkingine)
  protected
    procedure CreateRegionsCollection; override;
  public
    constructor Create(AOwner: TComponent); override;
  // Region Routines
    procedure ReCreateRegion; override;
  published
  // Properties
    property About;
    property Bitmaps;
    property Enabled;
    property FormResize;
    property Mask;
    property ParentShowHint;
    property PopupMenu;
    property RegionToForm;
    property Regions;
    property ShowCaption;
    property ShowHint;
    property ShowMaskInDesigner default True;
    property Skin;
    property Transparent;
    property Visible;
  // Events
    property OnChange;
  end;{TkrpColorSkingine = class(TkrpCustomSkingine)}


{******************************************************************************}
implementation
{******************************************************************************}

uses
  Forms, Dialogs, ExtCtrls, krpRegionsProcs;


type
  
//==============================================================================
// TkrpSkingineTimer
//==============================================================================
// Timer for TkrpCustomSkingine component

  TkrpSkingineTimer = class(TTimer)
    constructor CreateRehook(AOwner: TComponent; AInterval: Cardinal);
    procedure OnTimerRehook(Sender: TObject);
  end;

{ TkrpSkingineTimer }

constructor TkrpSkingineTimer.CreateRehook(AOwner: TComponent; AInterval: Cardinal);
begin
  Create(AOwner);
  Interval := AInterval;
  OnTimer := OnTimerRehook;
  Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TkrpSkingineTimer.OnTimerRehook(Sender: TObject);
begin
  if Owner is TkrpCustomSkingine then
  begin
    Enabled := not TkrpCustomSkingine(Owner).HookParentVerify;
    if Enabled then Exit;
  end;

// Free timer after work
  Free;
end;



//==============================================================================
// TkrpCustomSkingine
//==============================================================================
// Prototype of Skin/Region Engines (Skingines) components. Contains a
// collection of Regions. Items of that collection hold own simple regions.
// The instance creates a complex Region from Mask and set this region to the
// Owner (TForm). When a ShowCaption property is True, region of Owner's
// caption is added to the complex Region, so the caption become visible.
// An order of Items in the Regions collection is a Z order (Top most captures
// the mouse input, so the TopMost region should be the Last in collection).
//  WARNING !!! Only one TkrpCustomSkingine or its descendant component is
// allowed on a Form at the same time.
//  WARNING !!! Don't use Hint and Cursor property directly because it can be
// changed by Regions at runtime.
{ TkrpCustomSkingine }

const
  strErr_ComponentExists = 'The %:0s component or its descendant is already present on the form, only one %:0s component or it descendant allowed on the form at the same time';
  strErr_WrongOwner      = 'Owner is not a TForm descendant';
  strErr_WrongParent     = 'Parent must be a TForm, drop on a Form please';

//------------------------------------------------------------------------------

constructor TkrpCustomSkingine.Create(AOwner: TComponent);
var
  i: Integer;
begin
  FOldParentHandle := 0;
  
// Check for Owner class
  if not (AOwner is TForm) then raise Exception.Create(strErr_WrongOwner);

// Check for same object existing
  with AOwner do
    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TkrpCustomSkingine) then
        raise Exception.CreateFmt(strErr_ComponentExists,
          [TkrpCustomSkingine.ClassName]);

// Create Regions Collection depending on the Skingine class
  CreateRegionsCollection;

// Create property descriptors
  fBitmaps := TkrpRunTimeBitmapDesc.CreateWithData(Self, nil, nil, nil, nil,
    nil);
  fRegionToForm      := True;
  fNeedRedraw        := True;
  fActiveRegion      := nil;
  fShowCaption       := False;
  fFormResize        := True;
  fPaintRegionByRect := False;
  inherited Create(AOwner);
  fBitmaps.CallBack  := Update;
  ShowMaskInDesigner := False;
end;{constructor TkrpCustomSkingine.Create}

//------------------------------------------------------------------------------

destructor TkrpCustomSkingine.Destroy;
begin
  UnHookParent;
  fRegionChanging := True;
  inherited Destroy;
// Free all Pictures
  fBitmaps.Free;
// Free all objects
  fRegions.Free;
  fRegions := nil;
end;

//------------------------------------------------------------------------------
// Region routines

procedure TkrpCustomSkingine.ReCreateRegion;
var
  Save: Boolean;
begin
// Don't do it on Loading, Destroying or Changing
  if fRegionChanging or (not fLoaded) or
    (csDestroying in ComponentState) then Exit;

// Turn off drawing and recreating of region(s)
  Save := fRegionChanging;
  fRegionChanging := True;
  try
  // Reset Region if needed
    if Assigned(fRegion) then fRegion.Free;
  // Create new regon from Mask or Empty
    if Assigned(Mask) and (not Mask.Empty) then
    begin
    // Create Region from Mask by MaskColor Color
      fRegion := TkrpRegion.CreateFromMask(Mask, MaskColor, False);
    // Offset combined region depend BorderStyle
      OffsetRgn(fRegion.Region, OwnerOffsetX, OwnerOffsetY);
    end else
      fRegion := TkrpRegion.CreateEmpty;

  // Combine standard caption if needed
    if ShowCaption then
      CombineRgn(fRegion.Region, krpGetCaptionRegion(Owner as TForm),
        fRegion.Region, RGN_OR);

  // Reset Picture and set flag for redrawing
    Picture := nil;
    fNeedRedraw := True;

  // Check for region setting
    if (not RegionToForm) or RegionIsEmpty then
    begin
      RemoveRegion;
      Exit; // !!! to finally part
    end;

  // Update and Resize if needed
    if FormResize then ResizeForm;

  // Set combined region to the Owner
    ApplyRegion;
  finally
    DoChange;
    fRegionChanging := Save;
  end;
end;{procedure TkrpCustomSkingine.ReCreateRegion}

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.ApplyRegion;
begin
  if (not RegionToForm) or RegionIsEmpty then Exit;
  if (csDesigning in ComponentState) then Exit;

// Set combined region to window
{ Var 1
 with (Owner as TForm) do
    SetWindowRgn(Handle, fRegion.Region, True);{}
{ Var 2}
  if Assigned(Parent) and Parent.HandleAllocated then
    SetWindowRgn(Parent.Handle, fRegion.Region, True);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.RemoveRegion;
begin
// Remove a region from window
{ Var 1
  if (csDesigning in ComponentState) then Exit;
  SetWindowRgn((Owner as TForm).Handle, 0, True);{}
{ Var 2}
  if Assigned(Parent) and Parent.HandleAllocated then
    SetWindowRgn(Parent.Handle, 0, True);
end;

//------------------------------------------------------------------------------

function TkrpCustomSkingine.RegionAtPos(const Pos: TPoint;
  AllowDisabled: Boolean): TkrpRegionCollectionItem;
var
  i: Integer;
begin
  if AllowDisabled then
  begin
    for i := Regions.Count - 1 downto 0 do
    begin
      Result := Regions[i];
      if PtInRegion(Result.Region, Pos.X, Pos.Y) then Exit;
    end;
  end else
  begin
    for i := Regions.Count - 1 downto 0 do
    begin
      Result := Regions[i];
      if Result.Enabled and PtInRegion(Result.Region, Pos.X, Pos.Y) then
        Exit;
    end;
  end;
  Result := nil;
end;{function TkrpCustomSkingine.RegionAtPos}

//------------------------------------------------------------------------------
// Misc

procedure TkrpCustomSkingine.ResizeForm;
begin
  if (not Assigned(Mask)) or (Mask.Empty) then Exit;
// Resize Form's Clien Area to Mask size
  with (Owner as TForm) do
  begin
    ClientWidth  := Mask.Width;
    ClientHeight := Mask.Height;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.Update;
begin
// Don't do it on Loading, Destroying and Changing
  if fRegionChanging or (not fLoaded) or (csDestroying in ComponentState) then
    Exit;

  inherited Update;
  UpdateCursor;

  if not fNeedRedraw and not (csDesigning in ComponentState) then Exit;

  fRegionChanging := True;
  try
    Picture := nil;
  // Draw default Bitmap
    if not (Bitmaps.Normal.Empty) then Canvas.Draw(0, 0, Bitmaps.Normal);
  // Update all Regions
    Regions.UpdateRegions;
  finally
    fNeedRedraw := False;
    fRegionChanging := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.Loaded;
begin
  inherited Loaded;
  fLoaded := True; // Override previous flag
// If the skin component is present it will make all changes on own loading
  if Assigned(Skin) then Exit;
  SetMask(fMask);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opInsert then
  begin
    if (AComponent = Self) and (csDesigning in ComponentState) then
      fLoaded := True;
  end else
    if (AComponent = fSkin) then fSkin := nil;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.WndProc(var Message: TMessage);
var
  ARegion: TkrpRegionCollectionItem;

  //-------------------------------------

  procedure _MouseMessageToRegions;
  begin
    fMousePos := SmallPointToPoint(TWMMouse(Message).Pos);

  // Check for Enabled Region under cursor
    ARegion := RegionAtPos(fMousePos, True{False});
    if (ActiveRegion <> ARegion) then
    begin
      if Assigned(ARegion) and (ARegion.RuntimeState <> rtsDisabled)
        and not (csDesigning in ComponentState) then
      begin
      // Show Region's Hint if Needed
        Application.CancelHint;
        if ARegion.Visible and ShowHint then
        begin
          Hint := ARegion.Hint;
          Application.HintMouseMessage(Self, Message);
        end else
          Hint := '';
      end;
    // Change Active Region if mouse is not captured
      if not MouseCapture then ActiveRegion := ARegion;
    end;{if (ActiveRegion <> ARegion) then}

  // Send a message to ActiveRegion if is not disabled
    if Assigned(ActiveRegion) and (ActiveRegion.RuntimeState <> rtsDisabled)
      and not (csDesigning in ComponentState) then
    begin
      ActiveRegion.Dispatch(Message);
      Exit;
    end;
  end;{Internal procedure _MouseMessageToRegions}

  //-------------------------------------

begin
  if fNeedRedraw then Update;
  UpdateCursor;
  case Message.Msg of
    WM_CANCELMODE: SendCancelModeToRegions;
    WM_MouseFirst..WM_MouseLast: begin
      _MouseMessageToRegions;
      if Message.Msg = WM_LBUTTONUP then SendCancelModeToRegions;
      if Message.Result <> 0 then Exit;
    end;
  end;
  inherited WndProc(Message);
end;{procedure TkrpCustomSkingine.WndProc}

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  if (AParent = nil) then Exit;
  if not (AParent is TForm) then
    raise EkrpSkingine.Create(strErr_WrongParent);

  HookParent;
end;

//------------------------------------------------------------------------------
// Misc

procedure TkrpCustomSkingine.CreateRegionsCollection;
begin
  fRegions := TkrpRegionCollection.Create(Self, TkrpRegionCollectionItem);
end;

//------------------------------------------------------------------------------

function TkrpCustomSkingine.IsBitmapsStored : Boolean;
begin
  Result := not Assigned(Skin);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.UpdateCursor;
begin
  if Assigned(ActiveRegion) then Cursor := ActiveRegion.Cursor
  else Cursor := crDefault;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SendCancelModeToRegions;
begin
  fRegionChanging := True;
  try
    Regions.SendCancelMode;
  finally
    fRegionChanging := False;
  end;
// Update
  fNeedRedraw := True;
  Update;
  SelectRegionUnderCursor;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SelectRegionUnderCursor;
var
  Message: TWMMouse;
  Wnd: HWnd;
  Pos: TPoint;
begin
  GetCursorPos(Pos);
  MouseCapture := False;
  ActiveRegion := nil;
// Check the window under cursor
  Wnd := WindowFromPoint(Pos);
  if Wnd <> (Owner as TForm).Handle then Exit;
// Emulate mouse move message to change the cursor or hint
  Message.Msg := WM_MouseMove;
  Message.Pos := PointToSmallPoint(ScreenToClient(Pos));
  WndProc(TMessage(Message));
end;

//------------------------------------------------------------------------------
// Parent hook

procedure TkrpCustomSkingine.HookParent;
begin
  UnHookParent;
  if (csDesigning in ComponentState) then Exit;

  if Assigned(Parent) then
    with Parent do
    begin
      FOldParentWndProc := TFarProc(GetWindowLong(Handle, GWL_WndProc));
      FNewParentWndProc := MakeObjectInstance(HookParentWndProc);
      SetWindowLong(Handle, GWL_WndProc, LongInt(FNewParentWndProc));

      FOldParentHandle  := Handle;
    end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.UnHookParent;
begin
// Set saved WndProc to Parent
  if Assigned(Parent) and Parent.HandleAllocated and
    Assigned(FOldParentWndProc) then
    SetWindowLong(Parent.Handle, GWL_WndProc, LongInt(FOldParentWndProc));

  if Assigned(FNewParentWndProc) then FreeObjectInstance(FNewParentWndProc);

  FNewParentWndProc := nil;
  FOldParentWndProc := nil;
  FOldParentHandle := 0;
end;

//------------------------------------------------------------------------------
// Updates hook if parent handle was changed

function TkrpCustomSkingine.HookParentVerify: Boolean;
begin
  Result := False;
  if Assigned(Parent) and Parent.HandleAllocated
    and (Parent.Handle <> FOldParentHandle) then
  begin
    HookParent;
    ReCreateRegion;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.HookParentWndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_DESTROY: begin
      UnHookParent;
    // if Parent recreates handle, we need rehook it with new handle.
      if Assigned(Parent) and (not (csDestroying in Parent.ComponentState)) then
        TkrpSkingineTimer.CreateRehook(Self, 25);
    end;

    WM_ERASEBKGND: begin
      if not Transparent then
      begin
        Message.Result := 1;
        Exit;
      end;
    end;
  end;

  with Message, Parent do
    Result := CallWindowProc(FOldParentWndProc, Handle, Msg, wParam, lParam);
end;

//------------------------------------------------------------------------------
// Event handlers

procedure TkrpCustomSkingine.DoChange;
begin
  if Assigned(fOnChange) then fOnChange(Self);
end;

//------------------------------------------------------------------------------
// Properties Get/Set

procedure TkrpCustomSkingine.SetActiveRegion(const A: TkrpRegionCollectionItem);
const
  msg_RegionMouseLeave: TMessage = (Msg: KR_RegionMouseLeave; Result: 0);
  msg_RegionMouseEnter: TMessage = (Msg: KR_RegionMouseEnter; Result: 0);
begin
  if fActiveRegion = A then Exit;
// Send message to current active region for Mouse Leave routine
  if Assigned(fActiveRegion) then fActiveRegion.Dispatch(msg_RegionMouseLeave);
  fActiveRegion := A;
  if not Assigned(fActiveRegion) then Exit;
// Send message to new active region for Mouse Enter routine
  fActiveRegion.Dispatch(msg_RegionMouseEnter);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SetRegions(const A: TkrpRegionCollection);
begin
  fRegions.Assign(A);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SetBitmaps(const A: TkrpRunTimeBitmapDesc);
begin
  fBitmaps.Assign(A);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SetSkin(const A: TkrpCustomSkin);
begin
  fRegionChanging := True;
  try
  // Reset previous Skin's Master
    if Assigned(fSkin) then
      if A = nil then fSkin.Master := nil // Update
      else fSkin.SetMasterToNil;          // Don't update
  // Set new Skin
    fSkin := A;
    if Assigned(fSkin) then fSkin.Master := Self; // Update
  finally
    fRegionChanging := False;
  end;

// Recreate region depending on new settings
  RecreateRegion;
end;

//------------------------------------------------------------------------------

function TkrpCustomSkingine.GetOwnerOffsetX: Integer;
begin
  Result := 0;
// At design time offset is not depended on BorderStyle
  if (csDesigning in ComponentState) then Exit;
  if not Assigned(Owner) then Exit;
// Calculate the offset depending on BorderStyle
  case (Owner as TForm).BorderStyle of
    bsSingle,
    bsToolWindow : Result := GetSystemMetrics(SM_CXFixedFrame);
    bsSizeable,
    bsSizeToolWin: Result := GetSystemMetrics(SM_CXSizeFrame);
    bsDialog     : Result := GetSystemMetrics(SM_CXDlgFrame);
  end;
end;

//------------------------------------------------------------------------------

function TkrpCustomSkingine.GetOwnerOffsetY: Integer;
begin
  Result := 0;
// At design time offset is not depended on BorderStyle
  if (csDesigning in ComponentState) then Exit;
  if not Assigned(Owner) then Exit;
// Calculate the offset depending on BorderStyle
  case (Owner as TForm).BorderStyle of
    bsSingle     : Result := GetSystemMetrics(SM_CYFixedFrame) +
                             GetSystemMetrics(SM_CYCaption   );
    bsSizeable   : Result := GetSystemMetrics(SM_CYSizeFrame ) +
                             GetSystemMetrics(SM_CYCaption   );
    bsDialog     : Result := GetSystemMetrics(SM_CYDlgFrame  ) +
                             GetSystemMetrics(SM_CYCaption   );
    bsToolWindow : Result := GetSystemMetrics(SM_CYFixedFrame) +
                             GetSystemMetrics(SM_CYSmCaption );
    bsSizeToolWin: Result := GetSystemMetrics(SM_CXSizeFrame ) +
                             GetSystemMetrics(SM_CYSmCaption );
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SetRegionToForm(A: Boolean);
begin
  if fRegionToForm = A then Exit;
  fRegionToForm := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SetShowCaption(A: Boolean);
begin
  if fShowCaption = A then Exit;
  fShowCaption := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.SetFormResize(A: Boolean);
begin
  if fFormResize = A then Exit;
  fFormResize := A;
  if fFormResize then ResizeForm;
end;

//------------------------------------------------------------------------------
// Messages

procedure TkrpCustomSkingine.WMEraseBkgnd(var Message: TMessage);
begin
  Message.Result := 1;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.WMSize(var Message: TMessage);
begin
//  ReCreateRegion;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.WMSetCursor(var Message: TWMSetCursor);
begin
  if Assigned(ActiveRegion) then
    Windows.SetCursor(Screen.Cursors[ActiveRegion.Cursor])
  else inherited;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.KRRegionRecreate(var Message: TMessage);
begin
  Message.Result := 1;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.KRRegionActivate(var Message: TKRRegion);
begin
  Message.Result := 1;
  if Assigned(Message.Region^) then ActiveRegion := Message.Region^
  else ActiveRegion := nil;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.KRRegionDeactivate(var Message: TKRRegion);
begin
  Message.Result := 1;
  if ActiveRegion = Message.Region^ then
  begin
  // Reset current active region
    ActiveRegion := nil;
    SelectRegionUnderCursor;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingine.KRUpdateRegionArea(var Message: TKRUpdateRegionArea);

  //-------------------------------------

  procedure _UpdateArea(const APict : TBitmap);
  begin
    if (APict = nil) or (APict.Empty) then
    begin
      fNeedRedraw := True;
      Exit;
    end;

    with Message do
    begin
    // Set clip region
      if not fPaintRegionByRect then
        SelectClipRgn(Canvas.Handle, Region.Region);

    // Draw region
      Canvas.CopyRect(Region^.BoundsRect, APict.Canvas, Region^.BoundsRect);

    // Remove clip region
      if not fPaintRegionByRect then
        SelectClipRgn(Canvas.Handle, 0);
    end;

  end;{Internal procedure _UpdateArea}

  //-------------------------------------

begin
// Ignore messages if...
  if (not fLoaded) or (csDestroying in ComponentState) then Exit;

// At designins the state is always rtsNormal
  if (csDesigning in ComponentState) then Exit;
  with Message do
  begin
    if not Assigned(Region^) then Exit;
  // Ignore messages if changing. Disabled are not ignored!!!
    if fRegionChanging and (State <> rtsDisabled){} then Exit;
    Result := 1;
    case State of
//      rtsNormal  : fNeedRedraw := True;  // Doesn't automatically enable !!! 
      rtsNormal  : _UpdateArea(Bitmaps.Normal);
      rtsSelected: _UpdateArea(Bitmaps.Selected);
      rtsActive  : _UpdateArea(Bitmaps.Active);
      rtsDisabled: _UpdateArea(Bitmaps.Disabled);
    end;
  end;
end;{procedure TkrpCustomSkingine.KRUpdateRegionArea}


//==============================================================================
// TkrpRectSkingine
//==============================================================================
// Rect regions skingine
{ TkrpRectSkingine }

procedure TkrpRectSkingine.CreateRegionsCollection;
begin
  fRegions := TkrpRegionCollection.Create(Self, TkrpRectRegionCollectionItem);
end;


//==============================================================================
// TkrpColorSkingine
//==============================================================================
// This component is a realization of AREA-BY-COLOR™ algorithm by KARPOLAN.
// A Descendant of TkrpCustomSkingine so works like it, Contains collection of
// TkrpColorRegionCollectionItem, each Item holds a simple region created from
// Mask of the Skingine or from the OwnMask by color key. The TkrpColorSkingine
// combines all Regions to one and set this complex Region to the Owner (TForm).
{ TkrpColorSkingine }

constructor TkrpColorSkingine.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ShowMaskInDesigner := True;
end;

//------------------------------------------------------------------------------
// Region routines

procedure TkrpColorSkingine.ReCreateRegion;
var
  i: Integer;
  Save: Boolean;
begin
// Don't do it on Loading, Destroying and Changing
  if fRegionChanging or (not fLoaded) or (csDestroying in ComponentState) then
    Exit;
// Turn off drawing and recreating of region(s)
  Save := fRegionChanging;
  fRegionChanging := True;
  try
  // Recreeate region
    if Assigned(fRegion) then fRegion.Free;
    fRegion := TkrpRegion.CreateEmpty;

  // Recreate all regions without notification
    TkrpColorRegionCollection(Regions).Mask := fMask;

  // Combine all regions to one
    for i := 0 to Regions.Count - 1 do
      with Regions[i] do
        if Visible then
          CombineRgn(fRegion.Region, Regions[i].Region, fRegion.Region, RGN_OR);

  // Offset combined region depending on BorderStyle
    OffsetRgn(fRegion.Region, OwnerOffsetX, OwnerOffsetY);

  // Combine standard caption if needed
    if ShowCaption then
      CombineRgn(fRegion.Region, krpGetCaptionRegion(Owner as TForm),
        fRegion.Region, RGN_OR);

  // Reset Picture and set flag for redrawing
    Picture := nil;
    fNeedRedraw := True;

  // Check for region setting
    if (not RegionToForm) or RegionIsEmpty then
    begin
      RemoveRegion;
      Exit; // !!! to finally part
    end;

  // Update and Resize if needed
    if FormResize then ResizeForm;

  // Set combined region to the Owner 
    ApplyRegion;
  finally
    DoChange;
    fRegionChanging := Save;
  end;
end;{procedure TkrpColorSkingine.ReCreateRegion}

//------------------------------------------------------------------------------

procedure TkrpColorSkingine.CreateRegionsCollection;
begin
  fRegions := TkrpColorRegionCollection.Create(Self,
    TkrpColorRegionCollectionItem);
end;


{******************************************************************************}
initialization
{******************************************************************************}
{$IfDef krpRegions_Trial}
  krpCheckTrialVersion;
{$EndIf krpRegions_Trial}

end{unit krpRegionsSkingines}.
