{*******************************************************************************

  krpRegions library. Collections.

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
unit krpRegionsCollections;

{$I krpRegions.inc}

interface

uses
  Windows, classes, Controls, Graphics, Messages, krpRegionsCollectionItems,
  krpRegionsConsts, krpRegionsProcs;

type

//==============================================================================
// TkrpRegionCollection
//==============================================================================
// A collection of TkrpRegionCollectionItem or it descedants. This class is a
// prototype of all region colections, saves information about Owner (Usualy
// some of TkrpSkingine descendants). This class can invalidate the Owner
// (InvalidateOwner method) and Items (InvalidateItems method).

  TkrpRegionCollection = class(TCollection)
  protected
    FOwner: TPersistent;
  // Properties Get/Set
    function GetItem(Index: Integer): TkrpRegionCollectionItem; virtual;
  public
    constructor Create(AOwner: TPersistent; AItemType: TCollectionItemclass);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;
  // Notification routines
    procedure InvalidateOwner; virtual;
    procedure ReCreateRegions; virtual;
    procedure UpdateRegions; virtual;
    procedure SendCancelMode; virtual;
  // Properties
    property Owner: TPersistent read fOwner;
    property Items[Index: Integer]: TkrpRegionCollectionItem
      read GetItem; default;
  end;{TkrpRegionCollection = class(TCollection}


//==============================================================================
// TkrpColorRegionCollection
//==============================================================================
// A collection of TkrpColorRegionCollectionItem. This class holds a shared Mask
// bitmap for all owned Items.

  TkrpColorRegionCollection = class(TkrpRegionCollection)
  protected
    FMask: TBitmap;
    procedure SetMask(const A: TBitmap); virtual;
  public
  // Properties
    property Mask: TBitmap read FMask write SetMask;
  end;


{******************************************************************************}
implementation
{******************************************************************************}

//==============================================================================
// TkrpRegionCollection
//==============================================================================
// A collection of TkrpRegionCollectionItem or it descedants. This class is a
// prototype of all region colections, saves information about Owner (Usualy
// some of TkrpSkingine descendants). This class can invalidate the Owner
// (InvalidateOwner method) and Items (InvalidateItems method).
{ TkrpRegionCollection }

constructor TkrpRegionCollection.Create(AOwner: TPersistent;
  AItemType: TCollectionItemclass);
begin
  fOwner := AOwner;
  inherited Create(AItemType);
  krpCheckTrialVersion;
end;

//------------------------------------------------------------------------------

destructor TkrpRegionCollection.Destroy;
begin
  Clear;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TkrpRegionCollection.GetOwner: TPersistent;
begin
  Result := fOwner;
end;

//------------------------------------------------------------------------------
// Notification routines

procedure TkrpRegionCollection.InvalidateOwner;
const
  Message: TMessage = (Msg: KR_RegionRecreate; Result: 0);
begin
  Owner.Dispatch(Message);
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollection.RecreateRegions;
var
  i: Integer;
begin
// Recreate regions in all items
  for i := 0 to Count - 1 do
    Items[i].ReCreateRegion;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollection.UpdateRegions;
var
  i: Integer;
begin
// Update all items
  for i := 0 to Count - 1 do
    Items[i].Update;
end;

//------------------------------------------------------------------------------

procedure TkrpRegionCollection.SendCancelMode;
var
  i: Integer;
begin
// Send CancelMode to all items
  for i := 0 to Count - 1 do
    Items[i].SendCancelMode;
end;

//------------------------------------------------------------------------------
// Properties Get/Set

function TkrpRegionCollection.GetItem(Index: Integer): TkrpRegionCollectionItem;
begin
  Result := TkrpRegionCollectionItem(inherited Items[Index]);
end;


//==============================================================================
// TkrpColorRegionCollection
//==============================================================================
// A collection of TkrpColorRegionCollectionItem. This class holds a shared Mask
// bitmap for all owned Items.
{ TkrpColorRegionCollection }

procedure TkrpColorRegionCollection.SetMask(const A: TBitmap);
begin
  fMask := A;
  RecreateRegions;
end;

//------------------------------------------------------------------------------

end{unit krpRegionsCollections}.
