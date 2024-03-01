{*******************************************************************************

  krpRegions library. Disign-time stuff.

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
unit krpRegionsDesigning;

{$I krpRegions.inc}

interface

uses
{$IfDef D6}
  DesignIntf, DesignEditors, DesignMenus,
{$Else D6}
  DsgnIntf,
{$EndIf D6}
  Classes;

type

//==============================================================================
// TkrpAboutProperty
//==============================================================================

  TkrpAboutProperty = class(TStringProperty)
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

//==============================================================================
// TkrpFileNameProperty
//==============================================================================

  TkrpFileNameProperty = class(TStringProperty)
  protected
    function GetFilter: string; virtual;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

//==============================================================================
// TkrpShortFileNameProperty
//==============================================================================

  TkrpShortFileNameProperty = class(TkrpFileNameProperty)
  public
    procedure Edit; override;
  end;

//==============================================================================
// TkrpSkinFileNameProperty
//==============================================================================

  TkrpSkinFileNameProperty = class(TkrpFileNameProperty)
  protected
    function GetFilter: string; override;
  end;

//==============================================================================
// TkrpDirNameProperty
//==============================================================================

  TkrpDirNameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

//==============================================================================
// TkrpRegionsDefaultEditor
//==============================================================================

  TkrpRegionsDefaultEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
  end;

//==============================================================================
// TkrpCustomSkingineEditor
//==============================================================================

  TkrpCustomSkingineEditor = class(TComponentEditor)
  protected
    procedure EditRegion; virtual;
    procedure AddRegion; virtual;
    procedure DeleteRegion; virtual;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
  end;

//==============================================================================
// TkrpColorSkingineEditor
//==============================================================================

  TkrpColorSkingineEditor = class(TkrpCustomSkingineEditor)
  protected
    procedure AddRegion; override;
  end;

{******************************************************************************}
implementation
{******************************************************************************}

uses
  FileCtrl, Windows, SysUtils, Dialogs, Forms,
  krpRegionsConsts, krpRegionsSkingines, krpRegionsCollectionItems,
  krpRegionsAboutForm, krpRegionsDialogs;

//==============================================================================
// TkrpAboutProperty
//==============================================================================
{ TkrpAboutProperty }

procedure TkrpAboutProperty.Edit;
begin
  krpRegionsLibraryAbout;
end;

//------------------------------------------------------------------------------

function TkrpAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paReadOnly, paDialog];
end;

//------------------------------------------------------------------------------

function TkrpAboutProperty.GetValue: string;
begin
  Result := 'Ver ' + SkrpVCLVersion;
end;


//==============================================================================
// TkrpFileNameProperty
//==============================================================================
{ TkrpFileNameProperty }

procedure TkrpFileNameProperty.Edit;
var
  ADialog: TOpenDialog;
begin
  ADialog := TOpenDialog.Create(Application);
  with ADialog do
  try
    FileName   := GetValue;
    InitialDir := ExtractFilePath(FileName);
    FileName   := ExtractFileName(FileName);
    Filter     := GetFilter;
    Options    := Options + [ofHideReadOnly];
    if Execute then SetValue(FileName);
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

function TkrpFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

//------------------------------------------------------------------------------

function TkrpFileNameProperty.GetFilter : string;
begin
  Result := SkrpDefaultFilter;
end;


//==============================================================================
// TkrpShortFileNameProperty
//==============================================================================
{ TkrpShortFileNameProperty }

procedure TkrpShortFileNameProperty.Edit;
var
  ADialog: TOpenDialog;
begin
  ADialog := TOpenDialog.Create(Application);
  with ADialog do
  try
    FileName   := GetValue;
    InitialDir := ExtractFilePath(FileName);
    FileName   := ExtractFileName(FileName);
    Filter     := GetFilter;
    Options    := Options + [ofHideReadOnly];
    if Execute then SetValue(ExtractFileName(FileName));
  finally
    Free;
  end;
end;{procedure TkrpShortFileNameProperty.Edit}


//==============================================================================
// TkrpSkinFileNameProperty
//==============================================================================
{ TkrpSkinFileNameProperty }

function TkrpSkinFileNameProperty.GetFilter: string;
begin
  Result := SkrpSkinFileFilter + '|' + SkrpDefaultFilter;
end;


//==============================================================================
// TkrpDirNameProperty
//==============================================================================
{ TkrpDirNameProperty }

procedure TkrpDirNameProperty.Edit;
var
  RegStr: string;
begin
  RegStr := GetValue;
  if SelectDirectory(RegStr, [sdAllowCreate, sdPerformCreate], 0) then
    SetValue(RegStr);
end;

//------------------------------------------------------------------------------

function TkrpDirNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;


//==============================================================================
// TkrpRegionsDefaultEditor
//==============================================================================
{ TkrpRegionsDefaultEditor }

procedure TkrpRegionsDefaultEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: krpRegionsLibraryAbout;
    else inherited ExecuteVerb(Index);
  end;
end;

//------------------------------------------------------------------------------

function TkrpRegionsDefaultEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'About...';
    else inherited GetVerb(Index);
  end;
end;

//------------------------------------------------------------------------------

function TkrpRegionsDefaultEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 1;
end;


//==============================================================================
// TkrpCustomSkingineEditor
//==============================================================================
{ TkrpCustomSkingineEditor }

procedure TkrpCustomSkingineEditor.ExecuteVerb(Index : Integer);
begin
  with TkrpCustomSkingine(Component) do
    case Index of
      0: EditRegion;
      1: AddRegion;
      2: DeleteRegion;
      3: Exit; // Do nothing
      4: krpRegionsLibraryAbout;
      else inherited ExecuteVerb(Index);
    end;
end;

//------------------------------------------------------------------------------

function TkrpCustomSkingineEditor.GetVerb(Index : Integer): string;
begin
  case Index of
    0: Result := 'Edit region';
    1: Result := 'Add region';
    2: Result := 'Delete region';
    3: Result := '-';
    4: Result := 'About...';
    else inherited GetVerb(Index);
  end;
end;

//------------------------------------------------------------------------------

function TkrpCustomSkingineEditor.GetVerbCount : Integer;
begin
  Result := inherited GetVerbCount + 5;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingineEditor.EditRegion;
begin
// Select region under cursor
  try
    Designer.SelectComponent(TkrpCustomSkingine(Component).ActiveRegion);{}
{    with TkrpCustomSkingine(Component) do
      Designer.SelectComponent(RegionAtPos(MousePos, True));{}
    Designer.Modified;
  except
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingineEditor.AddRegion;
begin
// Create new region and select it
  try
    Designer.SelectComponent(TkrpCustomSkingine(Component).Regions.Add);
    Designer.Modified;
  except
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkingineEditor.DeleteRegion;
const
  strMessage = 'Do you really want to delete "%s" region?';
var
  ARegion: TkrpRegionCollectionItem;
begin
  with TkrpCustomSkingine(Component) do
  begin
    if ActiveRegion = nil then Exit;
    ARegion := ActiveRegion;

  // Turn of Active Region
    ActiveRegion := nil;
    Designer.Modified;

  // Question
    if Application.MessageBox(
      PChar(Format(strMessage, [ARegion.GetDisplayName])),
      PChar(Application.Title),
      MB_IconQuestion or MB_YesNo or MB_DefButton2) <> ID_Yes then Exit;

  // Free region and update
    ARegion.Free;
    ReCreateRegion;
  end;
  Designer.Modified;
end;{procedure TkrpCustomSkingineEditor.DeleteRegion}


//==============================================================================
// TkrpColorSkingineEditor
//==============================================================================
{ TkrpColorSkingineEditor }

procedure TkrpColorSkingineEditor.AddRegion;
var
  ARegion: TkrpColorRegionCollectionItem;
begin
  with TkrpColorSkingine(Component) do
  begin
    ARegion := TkrpColorRegionCollectionItem(Regions.Add);
  // Set region color form mask pixel color if no such region pressent
    if (ActiveRegion = nil) and (not Mask.Empty) then
      ARegion.MaskColor := Mask.Canvas.Pixels[MousePos.X, MousePos.Y];
    Designer.Modified;
  end;

// Select new region in designer
  try
    Designer.SelectComponent(ARegion);
    Designer.Modified;
  except
  end;
end;

//------------------------------------------------------------------------------

end{unit krpRegionsDesigning}.
