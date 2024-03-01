{*******************************************************************************

  krpRegions library. Image controls unit.

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
unit krpRegionsImages;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, classes, Graphics, Controls, krpRegionsTypes;

type

//==============================================================================
// TkrpCustomRegionImage
//==============================================================================
// A base class for all skingines, provides a regions support and draws
// region area at design-time. Component can drag owner form if FormDrag
// property is True.

  TkrpCustomRegionImage = class(TGraphicControl)
  private
    FAbout: string;
    procedure WMLButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
  protected
    FFormDrag: Boolean;
    FMask: TBitmap;
    FMaskColor: TColor;
    FPicture: TPicture;
    FRegion: TkrpRegion;
    FTransparent: Boolean;
    FDrawing: Boolean;
    FLoaded: Boolean;
    FShowMaskInDesigner: Boolean;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Paint; override;
    function DestRect: TRect; dynamic;
    procedure PictureChanged(Sender: TObject); dynamic;
  // Properties Get/Set
    function GetCanvas: TCanvas; virtual;
    procedure SetMask(const A: TBitmap); virtual;
    procedure SetMaskColor(A: TColor); virtual;
    procedure SetPicture(const A: TPicture); virtual;
    procedure SetTransparent(A: Boolean); virtual;
    procedure SetShowMaskInDesigner(A: Boolean); virtual;
  // Properties
    property About: string read FAbout write FAbout stored False;
    property FormDrag: Boolean read FFormDrag write FFormDrag default False;
    property Mask: TBitmap read FMask write SetMask;
    property MaskColor: TColor read FMaskColor write SetMaskColor
      default $00000000;
    property Picture: TPicture read FPicture write SetPicture;
    property Transparent: Boolean read FTransparent write SetTransparent
      default False;
    property ShowMaskInDesigner: Boolean read FShowMaskInDesigner
      write SetShowMaskInDesigner default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReCreateRegion; virtual;
    function RegionIsEmpty: Boolean; virtual;
  // Properties
    property Canvas: TCanvas read GetCanvas;
    property Region: TkrpRegion read FRegion;
  end;{TkrpCustomRegionImage = class(TGraphicControl)}


//==============================================================================
// TkrpRegionImage
//==============================================================================
// A descendant of TkrpCustomRegionImage with published properties, so it can be
// used at design-time.

  TkrpRegionImage = class(TkrpCustomRegionImage)
  published
  // Properties
    property About;
    property Enabled;
    property FormDrag;
    property Hint;
    property Mask;
    property MaskColor;
    property ParentShowHint;
    property Picture;
    property PopupMenu;
    property ShowHint;
    property ShowMaskInDesigner;
    property Transparent;
    property Visible;
  // Events
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;{TkrpRegionImage = class(TkrpCustomRegionImage)}


{******************************************************************************}
implementation
{******************************************************************************}

uses
{$IfDef D4}
  Jpeg,  // Don't remove !!! It enables JPEG support
{$Else}
  {$IfDef D3}
     {$IfDef Delphi}
  Jpeg,  // Don't remove !!! It enables JPEG support
     {$EndIf Delphi}
  {$EndIf D3}
{$EndIf D4}
  krpRegionsProcs;

//==============================================================================
// TkrpCustomRegionImage
//==============================================================================
// A base class for all skingines, provides a regions support and draws
// region area at design-time. Component can drag owner form if FormDrag
// property is True.
{ TkrpCustomRegionImage }

constructor TkrpCustomRegionImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  krpCheckTrialVersion;
  fMask := TBitmap.Create;

  fPicture := TPicture.Create;
  fPicture.OnChange := PictureChanged;

  fRegion      := nil;
  Align        := alClient;
  fMaskColor   := $00000000;
  fFormDrag    := False;
  fTransparent := False;
  fShowMaskInDesigner := True;
end;

//------------------------------------------------------------------------------

destructor TkrpCustomRegionImage.Destroy;
begin
// Free grpaphics
  fPicture.Free;
  fMask.Free;

// Free Region
  if Assigned(fRegion) then fRegion.Free;
  fRegion := nil;

  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.ReCreateRegion;
begin
// Don't do it on Loading and Destroying
  if (not fLoaded) or (csDestroying in ComponentState) then Exit;

// Reset Region if needed
  if Assigned(fRegion) then fRegion.Free;

// Create a new region, from Mask or empty
  if Assigned(Mask) and (not Mask.Empty) then
    fRegion := TkrpRegion.CreateFromMask(Mask, MaskColor, False)
  else
    fRegion := TkrpRegion.CreateEmpty;

// Reset Picture an update
  Picture := nil;
  Repaint;
end;

//------------------------------------------------------------------------------

function TkrpCustomRegionImage.RegionIsEmpty: Boolean;
var
  R: TRect;
begin
  Result := True;
  if Assigned(Region) then
    if GetRgnBox(Region.Region, R) = NULLREGION then Exit;
  Result := False;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.Loaded;
begin
  inherited Loaded;
  fLoaded := True;

// Create region as it is stored in the DFM
  RecreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opInsert then
  begin
    if (AComponent = Self) and (csDesigning in ComponentState) then
      fLoaded := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.Paint;

  //------------------------------------

  procedure _DrawBorder;
  begin
    with (inherited Canvas) do
    begin
{      if not Transparent then
      begin
        Brush.Color := clBtnFace;
        Brush.Style := bsSolid;
        FillRect(ClientRect);
      end;{}
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
  end;{Internal procedure _DrawBorder}

  //------------------------------------

  procedure _DrawPicture;
  var
    Save: Boolean;
  begin
    Save := fDrawing;
    fDrawing := True;
    with (inherited Canvas) do
    try
      Draw(0, 0, Picture.Graphic);
    finally
      fDrawing := Save;
    end;
  end;{Internal procedure _DrawPicture}

  //------------------------------------

  procedure _DrawMask;
  var
    Save: Boolean;
  begin
    Save := fDrawing;
    fDrawing := True;
    with (inherited Canvas) do
    try
      Draw(0, 0, Mask)
    finally
      fDrawing := Save;
    end;
  end;{Internal procedure _DrawMask}

  //------------------------------------

  procedure _DrawPattern;
  var
    ARgn: HRgn;
    ABrush: HBrush;
  begin
    with (inherited Canvas) do
    begin
      SetBkMode(Handle, Windows.TRANSPARENT);
      ARgn := CreateRectRgnIndirect(ClientRect);
      try
        if Assigned(Region) then CombineRgn(ARgn, ARgn, Region.Region, rgn_Diff);
        ABrush := CreateHatchBrush(hs_DiagCross, clBlack);
        try
          FillRgn(Handle, ARgn, ABrush);
        finally
          DeleteObject(ABrush);
        end;
      finally
        DeleteObject(ARgn);
      end;
    end;{with inherited Canvas do}
  end;{Internal procedure _DrawPattern}

  //------------------------------------

begin
  if (csDesigning in ComponentState) then
  begin
    _DrawBorder;
    if ShowMaskInDesigner then _DrawMask else _DrawPicture;
    _DrawPattern;
  end else
    _DrawPicture;
end;{procedure TkrpCustomRegionImage.Paint}

//------------------------------------------------------------------------------

function TkrpCustomRegionImage.DestRect: TRect;
begin
  Result := Rect(0, 0, Mask.Width, Mask.Height);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.PictureChanged(Sender: TObject);
var
  G: TGraphic;
begin
  G := Picture.Graphic;
  if Assigned(G) then
  begin
    if not ((G is TMetaFile) or (G is TIcon)) then
      G.Transparent := fTransparent;
    if (not G.Transparent) then
      ControlStyle := ControlStyle + [csOpaque]
    else
      ControlStyle := ControlStyle - [csOpaque];
    if fDrawing then Update;
  end else
    ControlStyle := ControlStyle - [csOpaque];
  if (not fDrawing) then Invalidate;
end;

//------------------------------------------------------------------------------
// Properties Get/Set

function TkrpCustomRegionImage.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if (Picture.Graphic = nil) then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width    := Width;
      Bitmap.Height   := Height;
      Picture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;

  if (Picture.Graphic is TBitmap) then
    Result := TBitmap(Picture.Graphic).Canvas
  else
    Result := inherited Canvas;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.SetMask(const A: TBitmap);
begin
  fMask.Assign(A);
  RecreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.SetMaskColor(A: TColor);
begin
  if fMaskColor = A then Exit;
  fMaskColor := A;
  RecreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.SetPicture(const A: TPicture);
begin
  fPicture.Assign(A);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.SetTransparent(A: Boolean);
begin
  if fTransparent = A then Exit;
  fTransparent := A;
  PictureChanged(Self);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.SetShowMaskInDesigner(A: Boolean);
begin
  fShowMaskInDesigner := A;
  Repaint;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomRegionImage.WMLButtonDown(var Msg: TWMLButtonDown);
begin
  inherited;
  if not FormDrag then Exit;
  if Assigned(Owner) and (Owner is TControl) then
  begin
    ReleaseCapture;
    TControl(Owner).Perform(WM_SysCommand, SC_Move or htCaption, 0);
  end;
end;


{******************************************************************************}
initialization
{******************************************************************************}
{$IfDef krpRegions_Trial}
  krpCheckTrialVersion;
{$EndIf krpRegions_Trial}

end{unit krpRegionsImages}.

