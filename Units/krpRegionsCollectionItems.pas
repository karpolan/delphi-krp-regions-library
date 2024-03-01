{*******************************************************************************

  krpRegions library. Collection items.

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
unit krpRegionsCollectionItems;

{$I krpRegions.inc}

interface

uses
{$IfDef D4}
  ActnList,
{$EndIf D4}
  Windows, Classes, Controls, Graphics, Messages, Menus, krpRegionsConsts,
  krpRegionsTypes, krpRegionsDesc;

type

  TkrpRegionCollectionItem = class;


{$IfDef D4}
//==============================================================================
// TkrpActionLink
//==============================================================================
// Action link class is used in regions

  TkrpActionLink = class(TActionLink)
  protected
    FClient: TkrpRegionCollectionItem;
    procedure AssignClient(AClient: TObject); override;
    function IsCaptionLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    function DoShowHint(var HintStr: string): Boolean; virtual;
    procedure SetCaption(const Value: string); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TkrpActionLinkClass = class of TkrpActionLink;
{$EndIf D4}  

//==============================================================================
// TkrpRegionCollectionItem
//==============================================================================
// This class is a prototype for all region collection items. Holds the region
// by incapsulating of the TkrpRegion object. Provides mouse support routines.
// FormDrag property - turn On/Off auto draging of owner Form.
// Visible - Add/Remove to/from combined region of Skingine.
// The class can invalidate own collection by InvalidateOwner method.

  PkrpRegionCollectionItem = ^TkrpRegionCollectionItem;
  TkrpRegionCollectionItem = class(TCollectionItem)
  private
    FOnMouseMove : TMouseMoveEvent;
    FOnMouseDown : TMouseEvent;
    FOnMouseUp   : TMouseEvent;
    FOnClick     : TNotifyEvent;
    FOnDblClick  : TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
  // Messages
    procedure WMMouseMove    (var Message: TWMMouseMove    ); message WM_MOUSEMOVE;
    procedure WMLButtonDown  (var Message: TWMLButtonDown  ); message WM_LBUTTONDOWN;
    procedure WMLButtonUp    (var Message: TWMLButtonUp    ); message WM_LBUTTONUP;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDown  (var Message: TWMRButtonDown  ); message WM_RBUTTONDOWN;
    procedure WMRButtonUp    (var Message: TWMRButtonUp    ); message WM_RBUTTONUP;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure KRRegionMouseEnter(var Message: TMessage);      message KR_RegionMouseEnter;
    procedure KRRegionMouseLeave(var Message: TMessage);      message KR_RegionMouseLeave;
  protected
    FRegion: TkrpRegion;
    FBoundsRect, FClientRect: TRect;
    FRunTimeState: TkrpRunTimeState;
    FRunTimeStates: TkrpRunTimeStates;
    FEnabled, FFormDrag, FMouseInRegion, FPressed, FVisible: Boolean;
    FCursor: TCursor;
    FCursors: TkrpRunTimeCursorDesc;
    FHint: string;
    FName: string;
    FPopupMenu: TPopupMenu;
    FAnimated, FAnimatedClicked: Boolean;
{$IfDef D4}
    FLinkedComponent: TkrpLinkedComponent;
    FActionLink: TBasicActionLink;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;
    function GetActionLinkClass: TBasicActionLinkClass; dynamic;
    procedure DoActionChange(Sender: TObject);
    procedure DoLinkedNotification(Instance: TComponent); virtual;
{$EndIf D4}
    procedure FreeRegion; dynamic;
    procedure UpdateRunTimeState; dynamic;
    procedure ActivateSelf; dynamic;
    procedure DeactivateSelf; dynamic;
    function IsMouseMessageInRegion(const Message: TWMMove): Boolean;
  // Event handlers
    procedure DoMouseDown(var Message: TWMMouse; Button: TMouseButton;
      Shift: TShiftState);
    procedure DoMouseUp(var Message: TWMMouse; Button: TMouseButton);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure Click; dynamic;
    procedure DblClick; dynamic;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;
  // Properties Get/Set
    function GetRegion: HRgn; virtual;
    function GetOwnerControl: TControl; virtual;
    procedure SetRunTimeState(A: TkrpRuntimeState); virtual;
    procedure SetRunTimeStates(A: TkrpRunTimeStates); virtual;
    procedure SetCursors(const A: TkrpRunTimeCursorDesc); virtual;
    function GetCursor: TCursor;
    procedure SetName(const A: string); virtual;
    procedure SetEnabled(A: Boolean); virtual;
    procedure SetVisible(A: Boolean); virtual;
{$IfDef D4}
    function GetAction: TBasicAction; virtual;
    procedure SetAction(const Value: TBasicAction); virtual;
  // Properties
    property ActionLink: TBasicActionLink read FActionLink write FActionLink;
{$EndIf D4}
  // Events
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure ReCreateRegion; virtual;
    function GetDisplayName: string; override;
  // Invalidate routines
    procedure InvalidateOwner; dynamic;
    procedure Update; dynamic;
    procedure SendCancelMode; dynamic;
  // Emulation routines
    procedure AnimateSelection; dynamic;
    procedure AnimateDeSelection; dynamic;
    procedure AnimateActivate; dynamic;
    procedure AnimateDeActivate; dynamic;
    procedure AnimateClick; dynamic;
  // Properties
    property BoundsRect: TRect read FBoundsRect;
    property ClientRect: TRect read FClientRect;
    property Cursor: TCursor read GetCursor;
    property Cursors: TkrpRunTimeCursorDesc read fCursors write SetCursors;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property FormDrag: Boolean read FFormDrag write fFormDrag default False;
    property Hint: string read FHint write FHint;
    property MouseInRegion: Boolean read fMouseInRegion;
    property Name: string read FName write SetName;
    property OwnerControl: TControl read GetOwnerControl;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Pressed: Boolean read FPressed;
    property Region: HRgn read GetRegion;
    property RuntimeState: TkrpRuntimeState read FRuntimeState
      write SetRuntimeState;
    property RunTimeStates: TkrpRunTimeStates read FRunTimeStates
      write SetRunTimeStates;
    property Visible: Boolean read FVisible write SetVisible default True;
{$IfDef D4}
    property Action: TBasicAction read GetAction write SetAction;
{$EndIf D4}
  end;{TkrpRegionCollectionItem = class(TCollectionItem)}


//==============================================================================
// TkrpRectRegionCollectionItem
//==============================================================================
// This class holds rectangual region. Can be used as "Hot Area" of skins.
{ TkrpRectRegionCollectionItem }

  TkrpRectRegionCollectionItem = class(TkrpRegionCollectionItem)
  protected
  // Properties Get/Set
    function  GetLeft: Integer;
    procedure SetLeft(A: Integer); virtual;
    function  GetTop: Integer;
    procedure SetTop(A: Integer); virtual;
    function  GetWidth: Integer;
    procedure SetWidth(A: Integer); virtual;
    function  GetHeight: Integer;
    procedure SetHeight(A: Integer); virtual;
  public
    procedure ReCreateRegion; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); virtual;
  published
  // Properties
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property RunTimeStates;
    property Cursors;
    property Enabled;
    property FormDrag;
    property Hint;
    property Name;
    property PopupMenu;
    property Visible;
{$IfDef D4}
    property Action;
{$EndIf D4}
  // Events
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
    property OnMouseEnter;
    property OnMouseLeave;
  end;{TkrpRectRegionCollectionItem = class(TkrpRegionCollectionItem)}


//==============================================================================
// TkrpColorRegionCollectionItem
//==============================================================================
// This class holds a region are made from the Mask bitmap of the owner
// collection or from OwnMask bitmap by the MaskColor color key. Used as
// "AREA_BY_COLOR" region.

  TkrpColorRegionCollectionItem = class(TkrpRegionCollectionItem)
  protected
    fInverted: Boolean;
    fMaskColor: TColor;
    fOwnMask: TBitmap;
    procedure FreeRegion; override;
  // Properties Get/Set
    procedure SetInverted(A: Boolean); virtual;
    procedure SetMaskColor(A: TColor); virtual;
    procedure SetOwnMask(const A: TBitmap); virtual;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure ReCreateRegion; override;
  published
  // Properties
    property Inverted: Boolean read fInverted write SetInverted default False;
    property MaskColor: TColor read fMaskColor write SetMaskColor
      default $00000000;
    property Name;
    property OwnMask: TBitmap read fOwnMask write SetOwnMask;
    property RunTimeStates;
    property Cursors;
    property Enabled;
    property FormDrag;
    property Hint;
    property PopupMenu;
    property Visible;
{$IfDef D4}
    property Action;
{$EndIf D4}
  // Events
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
    property OnMouseEnter;
    property OnMouseLeave;
  end;{TkrpColorRegionCollectionItem = class(TkrpRegionCollectionItem)}


//==============================================================================
// Message Wrappers
//==============================================================================

  TKRRegion = record
    Msg    : Cardinal;
    Region : PkrpRegionCollectionItem; // 4 bytes pointer
    Param  : DWord;                    // 4 bytes filler
    Result : LongInt;
  end;

  TKRUpdateRegionArea = record
    Msg    : Cardinal;
    Region : PkrpRegionCollectionItem; // 4 bytes pointer
    State  : TkrpRunTimeState;         // 4 bytes enumerated
    Result : LongInt;
  end;

{******************************************************************************}
implementation
{******************************************************************************}

uses
  SysUtils,
  krpRegionsCollections, krpRegionsProcs, Forms;


{$IfDef D4}
//==============================================================================
// TkrpActionLink
//==============================================================================
// Action link class is used in regions
{ TkrpActionLink }

procedure TkrpActionLink.AssignClient(AClient: TObject);
begin
  FClient := AClient as TkrpRegionCollectionItem;
end;

//------------------------------------------------------------------------------

function TkrpActionLink.DoShowHint(var HintStr: string): Boolean;
begin
  Result := True;
  if Action is TCustomAction then
  begin
    if TCustomAction(Action).DoHint(HintStr) and Application.HintShortCuts and
      (TCustomAction(Action).ShortCut <> scNone) then
    begin
      if HintStr <> '' then
        HintStr := Format('%s (%s)', [HintStr, ShortCutToText(TCustomAction(Action).ShortCut)]);
    end;
  end;
end;

//------------------------------------------------------------------------------

function TkrpActionLink.IsCaptionLinked: Boolean;
begin
// Unused
  Result := False;
{  Result := inherited IsCaptionLinked and
    (FClient.Caption = (Action as TCustomAction).Caption);{}
end;

//------------------------------------------------------------------------------

function TkrpActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

//------------------------------------------------------------------------------

function TkrpActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

//------------------------------------------------------------------------------

function TkrpActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

//------------------------------------------------------------------------------

function TkrpActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

//------------------------------------------------------------------------------

procedure TkrpActionLink.SetCaption(const Value: string);
begin
// Unused
//  if IsCaptionLinked then FClient.Caption := Value;
end;

//------------------------------------------------------------------------------

procedure TkrpActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

//------------------------------------------------------------------------------

procedure TkrpActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

//------------------------------------------------------------------------------

procedure TkrpActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

//------------------------------------------------------------------------------

procedure TkrpActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

{$EndIf D4}


//==============================================================================
// TkrpRegionCollectionItem
//==============================================================================
// This class is a prototype for all region collection items. Holds the region
// by incapsulating of the TkrpRegion object. Provides mouse support routines.
// FormDrag property - turn On/Off auto draging of owner Form.
// Visible - Add/Remove to/from combined region of Skingine.
// The class can invalidate own collection by InvalidateOwner method.
{ TkrpRegionCollectionItem }

constructor TkrpRegionCollectionItem.Create(Collection: TCollection);
begin
  fRegion := nil;
  inherited Create(Collection);
  fRunTimeStates := [rtsNormal, rtsSelected, rtsActive, rtsDisabled];
  fEnabled       := True;
  fFormDrag      := False;
  fHint          := '';
  fVisible       := True;
// Create property descriptors
  fCursors := TkrpRunTimeCursorDesc.CreateWithData(Self, nil,
    crDefault, crHandPoint, crHandPoint, crDefault);
{$IfDef D4}
  fLinkedComponent := TkrpLinkedComponent.CreateInderect(nil,
    DoLinkedNotification);
{$EndIf D4}
end;

//------------------------------------------------------------------------------

destructor TkrpRegionCollectionItem.Destroy;
begin
// Free all stuff
  if Assigned(fCursors) then fCursors.Free;
  fCursors := nil;
  FreeRegion;
{$IfDef D4}
  if Assigned(fActionLink) then fActionLink.Free;
  fActionLink := nil;
  fLinkedComponent.Free;
{$EndIf D4}
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.ReCreateRegion;
begin
  if Assigned(fRegion) then GetRgnBox(fRegion.Region, fBoundsRect)
  else fBoundsRect := Rect(0, 0, 0, 0);
  fClientRect := Rect(0, 0, fBoundsRect.Right - fBoundsRect.Left,
    fBoundsRect.Bottom - fBoundsRect.Top);
  Update;
end;

//------------------------------------------------------------------------------

function TkrpRegionCollectionItem.GetDisplayName: string;
begin
  if Name = '' then Result := inherited GetDisplayName
  else Result := Name;
end;

//------------------------------------------------------------------------------
// Invalidate routines

procedure TkrpRegionCollectionItem.InvalidateOwner;
begin
  if Assigned(Collection) and (Collection is TkrpRegionCollection) then
    TkrpRegionCollection(Collection).InvalidateOwner;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.Update;
begin
  UpdateRunTimeState;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SendCancelMode;
begin
  fPressed := False;
  fMouseInRegion := False;
//  Update;
end;

//------------------------------------------------------------------------------
// Emulation routines

procedure TkrpRegionCollectionItem.AnimateSelection;
begin
  if fAnimated then Exit;
  fAnimated := True;
  try
    RuntimeState := rtsSelected;
    krpDelay(50);
  finally
    fAnimated := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.AnimateDeSelection;
begin
  if fAnimated then Exit;
  fAnimated := True;
  try
    RuntimeState := rtsNormal;
    krpDelay(50);
    DeactivateSelf;
  finally
    fAnimated := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.AnimateActivate;
begin
  if fAnimated then Exit;
  fAnimated := True;
  try
    RuntimeState := rtsActive;
    krpDelay(80);
  finally
    fAnimated := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.AnimateDeActivate;
begin
  if fAnimated then Exit;
  fAnimated := True;
  try
    RuntimeState := rtsSelected;
    krpDelay(80);
  finally
    fAnimated := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.AnimateClick;
begin
  if fAnimatedClicked then Exit;
  fAnimatedClicked := True;
  try
    AnimateSelection;
    AnimateActivate;
    AnimateDeActivate;
    Click;
    AnimateDeSelection;
    Update;
  finally
    fAnimatedClicked := False;
  end;
end;

//------------------------------------------------------------------------------
{$IfDef D4}

procedure TkrpRegionCollectionItem.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Enabled = True) then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.Hint = '') then
        Self.Hint := Hint;
      if not CheckDefaults or (Self.Visible = True) then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

//------------------------------------------------------------------------------

function TkrpRegionCollectionItem.GetActionLinkClass: TBasicActionLinkClass;
begin
  Result := TkrpActionLink;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.DoLinkedNotification(Instance: TComponent);
begin
  if Instance = Action then Action := nil;
end;

{$EndIf D4}
//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.FreeRegion;
begin
  if Assigned(fRegion) then fRegion.Free;
  fRegion := nil;
// Redraw OwnerControl without current region
  Update;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.UpdateRunTimeState;
begin
// Change RunTime state depending on all propery states
  if not Enabled then RunTimeState := rtsDisabled else
  if not Visible then RunTimeState := rtsNormal else
  if Pressed then
  begin
    if MouseInRegion then RunTimeState := rtsActive
    else RunTimeState := rtsSelected;
  end else
  if MouseInRegion then RunTimeState := rtsSelected
  else RunTimeState := rtsNormal;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.ActivateSelf;
var
  Message: TKRRegion;
begin
  if not Assigned(OwnerControl) then Exit;
  with Message do
  begin
    Msg := KR_RegionActivate;
    Region := @Self;
    Result := 0;
  end;
  OwnerControl.Dispatch(Message);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.DeactivateSelf;
var
  Message: TKRRegion;
begin
  fPressed := False;
  fMouseInRegion := False;
  if not Assigned(OwnerControl) then Exit;
  with Message do
  begin
    Msg := KR_RegionDeactivate;
    Region := @Self;
    Result := 0;
  end;
  OwnerControl.Dispatch(Message);
end;

//------------------------------------------------------------------------------

function TkrpRegionCollectionItem.IsMouseMessageInRegion(const Message: TWMMove): Boolean;
begin
  Result := PtInRegion(Region, Message.XPos, Message.YPos)
end;


//------------------------------------------------------------------------------
// Event handlers

procedure TkrpRegionCollectionItem.DoMouseDown(var Message: TWMMouse;
  Button: TMouseButton; Shift: TShiftState);

  //-------------------------------------

  procedure _DoLeftBottonDown;
  begin
    if FormDrag then
    try
      Message.Result := -1;
      ReleaseCapture;
      with TControl(OwnerControl.Owner) do
        Perform(WM_SysCommand, SC_Move or htCaption, 0);
      Exit;
    except
    end;
    Update;
  end;{Internal procedure _DoLeftBottonDown}

  //-------------------------------------

begin
  case Button of
    mbLeft: _DoLeftBottonDown;
  end;
  
  with Message do
    MouseDown(Button, KeysToShiftState(Keys) + Shift, XPos, YPos);
end;{procedure TkrpRegionCollectionItem.DoMouseDown}

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.DoMouseUp(var Message: TWMMouse;
  Button: TMouseButton);

  //-------------------------------------

  procedure _DoRightBottonUp;
  var
    Pos: TPoint;
    Control: TControl;
  begin
    if Message.Result <> 0 then Exit;

    if not Assigned(fPopupMenu) then
    begin
    // Activate owner's Popup
      Control := OwnerControl;
      if Assigned(Control) then Control.Dispatch(Message);
      Exit;
    end;

    if not fPopupMenu.AutoPopup then Exit;
    try
    // Activate own Popup
      Pos := Screen.ActiveForm.ClientToScreen(SmallPointToPoint(Message.Pos));
      fPopupMenu.Popup(Pos.X, Pos.Y);
    except
    end;
  end;{Internal procedure _DoRightBottonUp;}

  //-------------------------------------

begin
  if Button = mbRight then _DoRightBottonUp;
  with Message do
    MouseUp(Button, KeysToShiftState(Keys), XPos, YPos);
end;{procedure TkrpRegionCollectionItem.DoMouseUp}

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.MouseMove(Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then FOnMouseMove(Self, Shift, X, Y);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.MouseDown(Button: TMouseButton;
  Shift: TShiftState;  X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then FOnMouseDown(Self, Button, Shift, X, Y);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then FOnMouseUp(Self, Button, Shift, X, Y);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.Click;
begin
{$IfDef D4}
// Call OnClick if assigned and not equal to associated action's OnExecute.
// If associated action's OnExecute assigned then call it, otherwise, call
// OnClick.
  if Assigned(FOnClick) and Assigned(Action) and
    (@FOnClick <> @Action.OnExecute) then
    FOnClick(Self)
  else
  if Assigned(OwnerControl) and not (csDesigning in OwnerControl.ComponentState)
    and Assigned(Action) and Assigned(Action.OnExecute) then
    Action.Execute
  else
{$EndIf D4}
  if Assigned(FOnClick) then FOnClick(Self);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.DblClick;
begin
  if Assigned(FOnDblClick) then FOnDblClick(Self);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.MouseEnter;
begin
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.MouseLeave;
begin
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

//------------------------------------------------------------------------------
// Properties Get/Set

function TkrpRegionCollectionItem.GetRegion: HRgn;
begin
  Result := 0;
  if Assigned(fRegion) then Result := fRegion.Region;
end;

//------------------------------------------------------------------------------

function TkrpRegionCollectionItem.GetOwnerControl: TControl;
begin
  Result := nil;
  if (Collection is TkrpRegionCollection) then
    if (TkrpRegionCollection(Collection).Owner is TControl) then
      Result := TControl(TkrpRegionCollection(Collection).Owner);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SetRunTimeState(A: TkrpRuntimeState);
var
  Message: TKRUpdateRegionArea;
begin
  if not (A in RuntimeStates) then A := rtsNormal;
  if (fRuntimeState = A) and (A <> rtsDisabled) then Exit;
  fRuntimeState := A;

// Apply RunTime state to all property descriptors
  fCursors.RunTimeState := fRuntimeState;

// Check for OwnerControl existing
  if not Assigned(OwnerControl) then Exit;

// Prepare and send the message for Skingine
  with Message do
  begin
    Msg    := KR_UpdateRegionArea;
    Region := @Self;
    State  := RunTimeState;
    Result := 0;
  end;
  OwnerControl.Dispatch(Message);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SetRunTimeStates(A: TkrpRunTimeStates);
begin
  fRunTimeStates := A + [rtsNormal];
// Apply RunTimeState to new allowed value
  SetRunTimeState(RuntimeState);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SetCursors(const A: TkrpRunTimeCursorDesc);
begin
  fCursors.Assign(A);
end;

//------------------------------------------------------------------------------

function TkrpRegionCollectionItem.GetCursor: TCursor;
begin
  Result := Cursors.Current;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SetName(const A: string);
begin
  if fName = A then Exit;
  fName := A;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SetEnabled(A: Boolean);
begin
  if fEnabled = A then Exit;
  fEnabled := A;
  Update;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SetVisible(A: Boolean);
begin
  if fVisible = A then Exit;
  fVisible := A;
  ReCreateRegion;
  InvalidateOwner;
end;

//------------------------------------------------------------------------------
{$IfDef D4}

function TkrpRegionCollectionItem.GetAction: TBasicAction;
begin
  if Assigned(ActionLink) then Result := ActionLink.Action else Result := nil;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    if Assigned(ActionLink) then ActionLink.Free;
    ActionLink := nil;
  end else
  begin
    if not Assigned(ActionLink) then
      ActionLink := GetActionLinkClass.Create(Self);
    ActionLink.Action := Value;
    ActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
    Value.FreeNotification(FLinkedComponent);
  end;
end;

{$EndIf D4}

//------------------------------------------------------------------------------
// Messages

procedure TkrpRegionCollectionItem.WMMouseMove(var Message: TWMMouseMove);
var
  OldValue: Boolean;
begin
  OldValue := fMouseInRegion;
  fMouseInRegion := PtInRegion(Region, Message.XPos, Message.YPos);
  with Message do
    MouseMove(KeysToShiftState(Keys), XPos, YPos);
  if fMouseInRegion <> OldValue then Update;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.WMLButtonDown(var Message: TWMLButtonDown);
begin
  fPressed := True;
  DoMouseDown(Message, mbLeft, []);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.WMLButtonUp(var Message: TWMLButtonUp);
var
  OldValue: Boolean;
begin
  OldValue := fPressed;
  fPressed := False;
  DoMouseUp(Message, mbLeft);
  if OldValue and PtInRegion(Region, Message.XPos, Message.YPos) then
    Click;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  DblClick;
  DoMouseDown(Message, mbLeft, [ssDouble]);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.WMRButtonDown(var Message: TWMRButtonDown);
begin
  DoMouseDown(Message, mbRight, []);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.WMRButtonUp(var Message: TWMRButtonUp);
begin
  DoMouseUp(Message, mbRight);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.WMRButtonDblClk(var Message: TWMRButtonDblClk);
begin
  DoMouseDown(Message, mbRight, [ssDouble]);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.KRRegionMouseEnter(var Message: TMessage);
begin
  fMouseInRegion := True;
  MouseEnter;
  Update;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollectionItem.KRRegionMouseLeave(var Message: TMessage);
begin
  fMouseInRegion := False;
//  fPressed := False;
  MouseLeave;
  Update;
end;


//==============================================================================
// TkrpRectRegionCollectionItem
//==============================================================================
// This class holds rectangual region. Can be used as "Hot Area" of skins.
{ TkrpRectRegionCollectionItem }

procedure TkrpRectRegionCollectionItem.ReCreateRegion;
begin
  if Assigned(fRegion) then fRegion.Free;
  fRegion := TkrpRegion.CreateFromRect(BoundsRect);
  inherited ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpRectRegionCollectionItem.SetBounds(ALeft, ATop, AWidth,
  AHeight : Integer);
begin
  with fBoundsRect do
    if (Left = ALeft) and (Top = ATop) and (Right = ALeft + AWidth) and
      (Bottom = ATop + AHeight) then Exit;
  fBoundsRect := Rect(ALeft, ATop, ALeft + AWidth, ATop + AHeight);
  fClientRect := Rect(0, 0, fBoundsRect.Right - fBoundsRect.Left,
    fBoundsRect.Bottom - fBoundsRect.Top);
  ReCreateRegion;
end;

//------------------------------------------------------------------------------
// Properties Get/Set 

function TkrpRectRegionCollectionItem.GetLeft: Integer;
begin
  Result := BoundsRect.Left;
end;

//------------------------------------------------------------------------------

procedure TkrpRectRegionCollectionItem.SetLeft(A: Integer);
begin
  if Left = A then Exit;
  SetBounds(A, Top, Width, Height);
end;

//------------------------------------------------------------------------------

function TkrpRectRegionCollectionItem.GetTop: Integer;
begin
  Result := BoundsRect.Top;
end;

//------------------------------------------------------------------------------

procedure TkrpRectRegionCollectionItem.SetTop(A: Integer);
begin
  if Top = A then Exit;
  SetBounds(Left, A, Width, Height);
end;

//------------------------------------------------------------------------------

function TkrpRectRegionCollectionItem.GetWidth: Integer;
begin
  Result := BoundsRect.Right - BoundsRect.Left;
end;

//------------------------------------------------------------------------------

procedure TkrpRectRegionCollectionItem.SetWidth(A: Integer);
begin
  if Width = A then Exit;
  SetBounds(Left, Top, A, Height);
end;

//------------------------------------------------------------------------------

function TkrpRectRegionCollectionItem.GetHeight: Integer;
begin
  Result := BoundsRect.Bottom - BoundsRect.Top;
end;

//------------------------------------------------------------------------------

procedure TkrpRectRegionCollectionItem.SetHeight(A: Integer);
begin
  if Height = A then Exit;
  SetBounds(Left, Top, Width, A);
end;


//==============================================================================
// TkrpColorRegionCollectionItem
//==============================================================================
// This class holds a region are made from the Mask bitmap of the owner
// collection or from OwnMask bitmap by the MaskColor color key. Used as
// "Area_By_Color" region.
{TkrpColorRegionCollectionItem}

constructor TkrpColorRegionCollectionItem.Create(Collection: TCollection);
begin
  fInverted   := False;
  fOwnMask    := TBitmap.Create;
  fMaskColor  := $00000000;
  inherited Create(Collection);
end;

//------------------------------------------------------------------------------

destructor TkrpColorRegionCollectionItem.Destroy;
begin
  inherited Destroy;
  fOwnMask.Free;
  fOwnMask := nil;
end;

//------------------------------------------------------------------------------

procedure TkrpColorRegionCollectionItem.ReCreateRegion;
begin
  if Assigned(fRegion) then fRegion.Free;
  fRegion := nil;
// Create region from OwnMask if exists
  if Assigned(OwnMask) and (not OwnMask.Empty) then
    fRegion := TkrpRegion.CreateFromMask(OwnMask, MaskColor, Inverted)
  else
// Create region from Colection's Mask if exists
  if (Collection is TkrpColorRegionCollection) then
    with TkrpColorRegionCollection(Collection) do
      if Assigned(Mask) and (not Mask.Empty) then
        fRegion := TkrpRegion.CreateFromMask(Mask, MaskColor, Inverted);
// Set Bounds
  if Assigned(fRegion) then
    GetRgnBox(fRegion.Region, fBoundsRect)
  else
    fBoundsRect := Rect(0, 0, 0, 0);

  fClientRect := Rect(0, 0, fBoundsRect.Right - fBoundsRect.Left,
    fBoundsRect.Bottom - fBoundsRect.Top);
  InvalidateOwner;
end;

//------------------------------------------------------------------------------

procedure TkrpColorRegionCollectionItem.FreeRegion;
begin
  if Assigned(fRegion) then fRegion.Free;
  fRegion := nil;
// Recreate all OwnerControl regions
  InvalidateOwner;
end;

//------------------------------------------------------------------------------
// Properties Get/Set

procedure TkrpColorRegionCollectionItem.SetInverted(A : Boolean);
begin
  if fInverted = A then Exit;
  fInverted := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpColorRegionCollectionItem.SetOwnMask(const A: TBitmap);
begin
  fOwnMask.Assign(A);
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpColorRegionCollectionItem.SetMaskColor(A : TColor);
begin
  if fMaskColor = A then Exit;
  fMaskColor := A;
  ReCreateRegion;
end;

//------------------------------------------------------------------------------

end{unit krpRegionsCollectionItems}.
