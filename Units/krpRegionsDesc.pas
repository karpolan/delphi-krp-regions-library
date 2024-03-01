{*******************************************************************************

  krpRegions library. Property descriptors.

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
unit krpRegionsDesc;

{$I krpRegions.inc}

interface

uses
  Windows, SysUtils, classes, Graphics, Controls, StdCtrls, krpRegionsTypes;

type
  TkrpDescCallBack = procedure of object;

//==============================================================================
// TkrpRunTimeDesc
//==============================================================================
// This class is a prototype for all 4 RunTime states property descriptors.

  TkrpRunTimeDesc = class(TPersistent)
  protected
    fRunTimeState: TkrpRunTimeState;
    fOwner: TPersistent;
    procedure SetRunTimeState(A: TkrpRunTimeState); virtual;
  public
    CallBack: TkrpDescCallBack;
    constructor Create(AOwner: TPersistent;
      ACallBack: TkrpDescCallBack); virtual;
  // Properties
    property Owner: TPersistent read fOwner;
    property RunTimeState: TkrpRunTimeState read fRunTimeState
      write SetRunTimeState;
  end;


//==============================================================================
// TkrpRunTimeBooleanDesc
//==============================================================================
// Boolean RunTime 4 states property descriptor.

  TkrpRunTimeBooleanDesc = class(TkrpRunTimeDesc)
  protected
    fNormal  : Boolean;
    fSelected: Boolean;
    fActive  : Boolean;
    fDisabled: Boolean;
  // Properties Get/Set
    function  GetCurrent: Boolean;
    procedure SetNormal  (A: Boolean);
    procedure SetSelected(A: Boolean);
    procedure SetActive  (A: Boolean);
    procedure SetDisabled(A: Boolean);
  public
    constructor CreateWithData(AOwner: TPersistent; ACallBack: TkrpDescCallBack;
      ANormal, ASelected, AActive, ADisabled: Boolean);
    property Current: Boolean read GetCurrent;
  published
    property Normal: Boolean read fNormal write SetNormal;
    property Selected: Boolean read fSelected write SetSelected;
    property Active: Boolean read fActive write SetActive;
    property Disabled: Boolean read fDisabled write SetDisabled;
  end;{TkrpRunTimeColorDesc = class(TkrpRunTimeDesc)}


//==============================================================================
// TkrpRunTimeColorDesc
//==============================================================================
// TColor RunTime 4 states property descriptor.

  TkrpRunTimeColorDesc = class(TkrpRunTimeDesc)
  protected
    fNormal  : TColor;
    fSelected: TColor;
    fActive  : TColor;
    fDisabled: TColor;
  // Properties Get/Set
    function  GetCurrent: TColor;
    procedure SetNormal  (A: TColor);
    procedure SetSelected(A: TColor);
    procedure SetActive  (A: TColor);
    procedure SetDisabled(A: TColor);
  public
    constructor CreateWithData(AOwner: TPersistent; ACallBack: TkrpDescCallBack;
      ANormal, ASelected, AActive, ADisabled: TColor);
    property Current: TColor read GetCurrent;
  published
    property Normal: TColor read fNormal write SetNormal;
    property Selected: TColor read fSelected write SetSelected;
    property Active: TColor read fActive write SetActive;
    property Disabled: TColor read fDisabled write SetDisabled;
  end;{TkrpRunTimeColorDesc = class(TkrpRunTimeDesc)}


//==============================================================================
// TkrpRunTimeCursorDesc
//==============================================================================
// TCursor RunTime 4 states property descriptor.

  TkrpRunTimeCursorDesc = class(TkrpRunTimeDesc)
  protected
    fNormal  : TCursor;
    fSelected: TCursor;
    fActive  : TCursor;
    fDisabled: TCursor;
  // Properties Get/Set
    function GetCurrent: TCursor;
  public
    constructor CreateWithData(AOwner: TPersistent; ACallBack: TkrpDescCallBack;
      ANormal, ASelected, AActive, ADisabled: TCursor);
    property Current: TCursor read GetCurrent;
  published
    property Normal: TCursor read fNormal write fNormal;
    property Selected: TCursor read fSelected write fSelected;
    property Active: TCursor read fActive write fActive;
    property Disabled: TCursor read fDisabled write fDisabled;
  end;{TkrpRunTimeCursorDesc = class(TkrpRunTimeDesc)}


//==============================================================================
// TkrpRunTimeBitmapDesc
//==============================================================================
// TBitmap RunTime 4 states property descriptor.

  TkrpRunTimeBitmapDesc = class(TkrpRunTimeDesc)
  protected
    fNormal  : TBitmap;
    fSelected: TBitmap;
    fActive  : TBitmap;
    fDisabled: TBitmap;
  // Properties Get/Set
    function  GetCurrent: TBitmap;
    procedure SetNormal  (const A: TBitmap);
    procedure SetSelected(const A: TBitmap);
    procedure SetActive  (const A: TBitmap);
    procedure SetDisabled(const A: TBitmap);
  public
    constructor Create(AOwner: TPersistent;
      ACallBack: TkrpDescCallBack); override;
    constructor CreateWithData(AOwner: TPersistent; ACallBack: TkrpDescCallBack;
      ANormal, ASelected, AActive, ADisabled: TBitmap);
    destructor Destroy; override;
  // Properties
    property Current: TBitmap read GetCurrent;
  published
    property Normal: TBitmap read fNormal write SetNormal;
    property Selected: TBitmap read fSelected write SetSelected;
    property Active: TBitmap read fActive write SetActive;
    property Disabled: TBitmap read fDisabled write SetDisabled;
  end;{TkrpRunTimeBitmapDesc = class(TkrpRunTimeDesc)}


//==============================================================================
// TkrpRunTimePictureDesc
//==============================================================================
// TPicture RunTime 4 states property descriptor.

  TkrpRunTimePictureDesc = class(TkrpRunTimeDesc)
  protected
    fNormal  : TPicture;
    fSelected: TPicture;
    fActive  : TPicture;
    fDisabled: TPicture;
  // Properties Get/Set
    function  GetCurrent: TPicture;
    procedure SetNormal  (const A: TPicture);
    procedure SetSelected(const A: TPicture);
    procedure SetActive  (const A: TPicture);
    procedure SetDisabled(const A: TPicture);
  public
    constructor Create(AOwner: TPersistent;
      ACallBack: TkrpDescCallBack); override;
    constructor CreateWithData(AOwner: TPersistent; ACallBack: TkrpDescCallBack;
      ANormal, ASelected, AActive, ADisabled: TPicture);
    destructor Destroy; override;
  // Properties
    property Current: TPicture read GetCurrent;
  published
    property Normal: TPicture read fNormal write SetNormal;
    property Selected: TPicture read fSelected write SetSelected;
    property Active: TPicture read fActive write SetActive;
    property Disabled: TPicture read fDisabled write SetDisabled;
  end;{TkrpRunTimePictureDesc = class(TkrpRunTimeDesc)}


{******************************************************************************}
implementation
{******************************************************************************}

//==============================================================================
// TkrpRunTimeDesc
//==============================================================================
// This class is a prototype for all 4 RunTime states property descriptors.
{ TkrpRunTimeDesc }

constructor TkrpRunTimeDesc.Create(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack);
begin
  fOwner   := AOwner;
  CallBack := ACallBack;
  inherited Create;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeDesc.SetRunTimeState(A: TkrpRunTimeState);
begin
  if fRunTimeState = A then Exit;
  fRunTimeState := A;
  if Assigned(CallBack) then CallBack;
end;


//==============================================================================
// TkrpRunTimeBooleanDesc
//==============================================================================
// Boolean RunTime 4 states property descriptor.
{ TkrpRunTimeBooleanDesc }

constructor TkrpRunTimeBooleanDesc.CreateWithData(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack; ANormal, ASelected, AActive, ADisabled: Boolean);
begin
  Create(AOwner, ACallBack);
  fNormal   := ANormal;
  fSelected := ASelected;
  fActive   := AActive;
  fDisabled := ADisabled;
end;

//------------------------------------------------------------------------------

function  TkrpRunTimeBooleanDesc.GetCurrent: Boolean;
begin
  case RunTimeState of
    rtsSelected : Result := fSelected;
    rtsActive   : Result := fActive;
    rtsDisabled : Result := fDisabled;
    else          Result := fNormal;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBooleanDesc.SetNormal(A: Boolean);
begin
  if fNormal = A then Exit;
  fNormal := A;
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBooleanDesc.SetSelected(A: Boolean);
begin
  if fSelected = A then Exit;
  fSelected := A;
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBooleanDesc.SetActive(A: Boolean);
begin
  if fActive = A then Exit;
  fActive := A;
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBooleanDesc.SetDisabled(A: Boolean);
begin
  if fDisabled = A then Exit;
  fDisabled := A;
  if Assigned(CallBack) then CallBack;
end;


//==============================================================================
// TkrpRunTimeColorDesc
//==============================================================================
// TColor RunTime 4 states property descriptor.
{ TkrpRunTimeColorDesc }

constructor TkrpRunTimeColorDesc.CreateWithData(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack; ANormal, ASelected, AActive, ADisabled: TColor);
begin
  Create(AOwner, ACallBack);
  fNormal   := ANormal;
  fSelected := ASelected;
  fActive   := AActive;
  fDisabled := ADisabled;
end;

//------------------------------------------------------------------------------

function TkrpRunTimeColorDesc.GetCurrent: TColor;
begin
  case RunTimeState of
    rtsSelected : Result := fSelected;
    rtsActive   : Result := fActive;
    rtsDisabled : Result := fDisabled;
    else          Result := fNormal;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeColorDesc.SetNormal(A: TColor);
begin
  if fNormal = A then Exit;
  fNormal := A;
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeColorDesc.SetSelected(A: TColor);
begin
  if fSelected = A then Exit;
  fSelected := A;
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeColorDesc.SetActive(A: TColor);
begin
  if fActive = A then Exit;
  fActive := A;
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeColorDesc.SetDisabled(A: TColor);
begin
  if fDisabled = A then Exit;
  fDisabled := A;
  if Assigned(CallBack) then CallBack;
end;


//==============================================================================
// TkrpRunTimeCursorDesc
//==============================================================================
// TCursor RunTime 4 states property descriptor.
{ TkrpRunTimeCursorDesc }

constructor TkrpRunTimeCursorDesc.CreateWithData(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack; ANormal, ASelected, AActive, ADisabled: TCursor);
begin
  Create(AOwner, ACallBack);
  fNormal   := ANormal;
  fSelected := ASelected;
  fActive   := AActive;
  fDisabled := ADisabled;
end;

//------------------------------------------------------------------------------

function  TkrpRunTimeCursorDesc.GetCurrent: TCursor;
begin
  case RunTimeState of
    rtsSelected : Result := fSelected;
    rtsActive   : Result := fActive;
    rtsDisabled : Result := fDisabled;
    else          Result := fNormal;
  end;
end;


//==============================================================================
// TkrpRunTimeBitmapDesc
//==============================================================================
// TBitmap RunTime 4 states property descriptor.
{ TkrpRunTimeBitmapDesc }

constructor TkrpRunTimeBitmapDesc.Create(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack);
begin
  inherited Create(AOwner, ACallBack);
  fNormal   := TBitmap.Create;
  fSelected := TBitmap.Create;
  fActive   := TBitmap.Create;
  fDisabled := TBitmap.Create;
end;

//------------------------------------------------------------------------------

constructor TkrpRunTimeBitmapDesc.CreateWithData(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack; ANormal, ASelected, AActive, ADisabled: TBitmap);
begin
  Create(AOwner, ACallBack);
  SetNormal(ANormal);
  SetSelected(ASelected);
  SetActive(AActive);
  SetDisabled(ADisabled);
end;

//------------------------------------------------------------------------------

destructor TkrpRunTimeBitmapDesc.Destroy;
begin
  fNormal  .Free;
  fSelected.Free;
  fActive  .Free;
  fDisabled.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TkrpRunTimeBitmapDesc.GetCurrent: TBitmap;
begin
  case RunTimeState of
    rtsSelected : Result := fSelected;
    rtsActive   : Result := fActive;
    rtsDisabled : Result := fDisabled;
    else          Result := fNormal;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBitmapDesc.SetNormal(const A: TBitmap);
begin
  if fNormal = A then Exit;
  fNormal.Assign(A);
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBitmapDesc.SetSelected(const A: TBitmap);
begin
  if fSelected = A then Exit;
  fSelected.Assign(A);
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBitmapDesc.SetActive(const A: TBitmap);
begin
  if fActive = A then Exit;
  fActive.Assign(A);
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimeBitmapDesc.SetDisabled(const A: TBitmap);
begin
  if fDisabled = A then Exit;
  fDisabled.Assign(A);
  if Assigned(CallBack) then CallBack;
end;


//==============================================================================
// TkrpRunTimePictureDesc
//==============================================================================
// TPicture RunTime 4 states property descriptor.
{ TkrpRunTimePictureDesc }

constructor TkrpRunTimePictureDesc.Create(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack);
begin
  inherited Create(AOwner, ACallBack);
  fNormal   := TPicture.Create;
  fSelected := TPicture.Create;
  fActive   := TPicture.Create;
  fDisabled := TPicture.Create;
end;

//------------------------------------------------------------------------------

constructor TkrpRunTimePictureDesc.CreateWithData(AOwner: TPersistent;
  ACallBack: TkrpDescCallBack; ANormal, ASelected, AActive, ADisabled: TPicture);
begin
  Create(AOwner, ACallBack);
  SetNormal(ANormal);
  SetSelected(ASelected);
  SetActive(AActive);
  SetDisabled(ADisabled);
end;

//------------------------------------------------------------------------------

destructor TkrpRunTimePictureDesc.Destroy;
begin
  fNormal  .Free;
  fSelected.Free;
  fActive  .Free;
  fDisabled.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TkrpRunTimePictureDesc.GetCurrent: TPicture;
begin
  case RunTimeState of
    rtsSelected : Result := fSelected;
    rtsActive   : Result := fActive;
    rtsDisabled : Result := fDisabled;
    else          Result := fNormal;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimePictureDesc.SetNormal(const A: TPicture);
begin
  if fNormal = A then Exit;
  fNormal.Assign(A);
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimePictureDesc.SetSelected(const A: TPicture);
begin
  if fSelected = A then Exit;
  fSelected.Assign(A);
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimePictureDesc.SetActive(const A: TPicture);
begin
  if fActive = A then Exit;
  fActive.Assign(A);
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

procedure TkrpRunTimePictureDesc.SetDisabled(const A: TPicture);
begin
  if fDisabled = A then Exit;
  fDisabled.Assign(A);
  if Assigned(CallBack) then CallBack;
end;

//------------------------------------------------------------------------------

end{unit krpRegionsDesc}.
