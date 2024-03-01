{*******************************************************************************

  krpRegions library. Non-visual containers for skins.

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
unit krpRegionsSkins;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, classes, SysUtils, Graphics, Controls,
  krpRegionsTypes, krpRegionsDesc;

type

//==============================================================================
// TkrpCustomSkin
//==============================================================================
// A prototype of all skin storages.

  TkrpCustomSkin = class(TComponent)
  private
    fAbout: string;
  protected
    fMask: TPicture;
    fPictures: TkrpRunTimePictureDesc;
    fMaster: TComponent;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  // Properties Get/Set
    procedure SetMask(const A: TPicture); virtual;
    procedure SetPictures(const A: TkrpRunTimePictureDesc); virtual;
    procedure SetMaster(const A: TComponent); virtual;
  // Properties
    property About: string read fAbout write fAbout stored False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Update; virtual;
    procedure Reset; virtual;
    procedure SetMasterToNil; virtual;
  // Properties
    property Mask: TPicture read fMask write SetMask;
    property Pictures: TkrpRunTimePictureDesc read fPictures
      write SetPictures;
    property Master: TComponent read fMaster write SetMaster;
  end;{TkrpCustomSkin = class(TComponent)}


//==============================================================================
// TkrpSkin
//==============================================================================
// Descendant of TkrpCustomSkin with published properties, so it can be used at
// design-time.

  TkrpSkin = class(TkrpCustomSkin)
  published
    property About;
    property Mask;
    property Pictures;
  end;


//==============================================================================
// TkrpSkinFile
//==============================================================================
// Component is a skin storage for working with skin files. Provides access to
// a skin file and a skin's data (mask and pictures).

  TkrpSkinFile = class(TkrpCustomSkin)
  protected
    fSkinFile: TkrpRegionsSkinFile;
    fFileName: string;
    fAutoCreateFile: Boolean;
    procedure Loaded; override;
  // Skin file routines
    procedure DestroySkinFile; dynamic;
    procedure RestoreDefaultNames; dynamic;
  // Properties Get/Set
    function  GetDirName: string; virtual;
    procedure SetFileName(const A: string); virtual;
    function  GetMaskName: string; virtual;
    procedure SetMaskName(const A: string); virtual;
    function  GetPictureNormal: string; virtual;
    procedure SetPictureNormal(const A: string); virtual;
    function  GetPictureSelected: string; virtual;
    procedure SetPictureSelected(const A: string); virtual;
    function  GetPictureActive: string; virtual;
    procedure SetPictureActive(const A: string); virtual;
    function  GetPictureDisabled: string; virtual;
    procedure SetPictureDisabled(const A: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Reset; override;
  // Skin file routines
    procedure RestoreDefaultSkin; dynamic;
    procedure ReCreateSkinFile; dynamic;
  // File routines
    function GetFullFileName: string; virtual;
    function LoadSkinFromFile(const AFileName: string): Boolean; virtual;
  // Properties
    property SkinFile: TkrpRegionsSkinFile read fSkinFile;
    property DirName: string read GetDirName;
  published
  // Properties
    property About;
  // Warning !!! AutoCreateFile should be loaded before DirName - don't change
  // properies order !!!
    property AutoCreateFile: Boolean read fAutoCreateFile write fAutoCreateFile
      default False;
    property FileName: string read fFileName write SetFileName;
    property MaskName: string read GetMaskName write SetMaskName stored False;
    property PictureNormal: string read GetPictureNormal write SetPictureNormal
      stored False;
    property PictureSelected: string read GetPictureSelected
      write SetPictureSelected  stored False;
    property PictureActive: string read GetPictureActive write SetPictureActive
      stored False;
    property PictureDisabled: string read GetPictureDisabled
      write SetPictureDisabled stored False;
  end;{TkrpSkinFile = class(TkrpCustomSkin)}


{******************************************************************************}
implementation
{******************************************************************************}

uses
{$IfDef DEBUG}
  Dialogs,
{$EndIf DEBUG}
{$IfDef D4}
  Jpeg,  // Don't remove !!! It enables JPEG support
{$Else}
  {$IfDef D3}
     {$IfDef Delphi}
  Jpeg,  // Don't remove !!! It enables JPEG support
     {$EndIf Delphi}
  {$EndIf D3}
{$EndIf D4}
  Forms, krpRegionsConsts, krpRegionsProcs, krpRegionsSkingines;


//==============================================================================
// TkrpCustomSkin
//==============================================================================
// A prototype of all skin storages.
{ TkrpCustomSkin }

constructor TkrpCustomSkin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  krpCheckTrialVersion;
  fMask := TPicture.Create;
  fPictures := TkrpRunTimePictureDesc.CreateWithData(Self, nil, nil, nil,
    nil, nil);
  fPictures.CallBack := Update;
end;

//------------------------------------------------------------------------------

destructor TkrpCustomSkin.Destroy;
begin
  fPictures.Free;
  fMask    .Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkin.Update;
begin
// Don't do it on Loading and Destroying
  if [csLoading, csReading, csDestroying] * ComponentState <> [] then Exit;

  if not Assigned(Master) then Exit;

  if (Master is TkrpCustomSkingine) then
    with TkrpCustomSkingine(Master) do
    begin
    // Set mask to skingine without recreation of region
      krpPictureToBitmap(Self.fMask, Mask);

    // Set Bitmaps property of skingine
      with Bitmaps do
      begin
        krpPictureToBitmap(Pictures.Normal  , Normal  );
        krpPictureToBitmap(Pictures.Selected, Selected);
        krpPictureToBitmap(Pictures.Active  , Active  );
        krpPictureToBitmap(Pictures.Disabled, Disabled);
      end;

    // Apply changes and repaint skingine
      Update;
    end;
end;{procedure TkrpCustomSkin.Update}

//------------------------------------------------------------------------------

procedure TkrpCustomSkin.Reset;
begin
  SetMasterToNil;
  fMask.Assign(nil);
  with Pictures do
  begin
    Normal  .Assign(nil);
    Selected.Assign(nil);
    Active  .Assign(nil);
    Disabled.Assign(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkin.SetMasterToNil;
begin
  fMaster := nil;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkin.Loaded;
begin
  inherited Loaded;
  SetMask(fMask);
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkin.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = fMaster then fMaster := nil;
  end;
end;


//------------------------------------------------------------------------------
// Properties Get/Set

procedure TkrpCustomSkin.SetMask(const A: TPicture);
begin
  fMask.Assign(A);
// Don't do it on Loading and Destroying
  if [csLoading, csReading, csDestroying] * ComponentState <> [] then Exit;
  
  if Assigned(Master) and (Master is TkrpCustomSkingine) then
  begin
    Update;
//    TkrpCustomSkingine(Master).Mask.Assign(nil);
    krpPictureToBitmap(fMask, TkrpCustomSkingine(Master).Mask);
    TkrpCustomSkingine(Master).RecreateRegion;
  end;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkin.SetPictures(const A: TkrpRunTimePictureDesc);
begin
  fPictures.Assign(A);
  Update;
end;

//------------------------------------------------------------------------------

procedure TkrpCustomSkin.SetMaster(const A: TComponent);
begin
  if fMaster = A then Exit;
  fMaster := A;
  Update;
end;


//==============================================================================
// TkrpSkinFile
//==============================================================================
// Component is a skin storage for working with skin files. Provides access to
// a skin file and a skin's data (mask and pictures).
{ TkrpSkinFile }

const
//  strNoSkinFile  = 'Skin File doesn''t exists';
  strNoSkinFile  = 'No skin file...';

//------------------------------------------------------------------------------

constructor TkrpSkinFile.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  fAutoCreateFile := False;
  RestoreDefaultNames;
end;

//------------------------------------------------------------------------------

destructor TkrpSkinFile.Destroy;
begin
  inherited Destroy;
  DestroySkinFile;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.Reset;
begin
  RestoreDefaultNames;
  inherited Reset;
end;


//==============================================================================
// Skin file routines

procedure TkrpSkinFile.RestoredefaultSkin;
begin
  RestoreDefaultNames;
  ReCreateSkinFile;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.ReCreateSkinFile;
var
  ADir: string;
begin
// Destroy previous Skin file
  DestroySkinFile;
  if not FileExists(GetFullFileName) then
  begin
    if (csDesigning in ComponentState) then Exit;
{$IfDef DEBUG}
    ShowMessage('DEBUG at ' + Name + '.ReCreateSkinFile : ' +
                Format('File "%s" doesn''t exists!', [GetFullFileName]));
{$EndIf DEBUG}
    RestoreDefaultNames;
    Exit;
  end;

// Save dir name
  ADir := DirName;
  fSkinFile := TkrpRegionsSkinFile.Create(GetFullFileName);
  try
    krpLoadPictureFromFile(Mask, krpExpandRelativeFileNameEx(ADir, MaskName));
    with Pictures do
    begin
      krpLoadPictureFromFile(Normal  , krpExpandRelativeFileNameEx(ADir, PictureNormal));
      krpLoadPictureFromFile(Selected, krpExpandRelativeFileNameEx(ADir, PictureSelected));
      krpLoadPictureFromFile(Active  , krpExpandRelativeFileNameEx(ADir, PictureActive));
      krpLoadPictureFromFile(Disabled, krpExpandRelativeFileNameEx(ADir, PictureDisabled));
    end;
    SetMask(Mask);
  finally
    Update;
  end;
end;{procedure TkrpSkinFile.ReCreateSkinFile}


//==============================================================================
// File routines

function TkrpSkinFile.GetFullFileName: string;
begin
  Result := krpExpandRelativeFileName(FileName);
end;

//------------------------------------------------------------------------------

function TkrpSkinFile.LoadSkinFromFile(const AFileName: string): Boolean;
begin
  FileName := AFileName;
  Result := (FileName = AFileName)
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.DestroySkinFile;
begin
  if Assigned(fSkinFile) then fSkinFile.Free;
  fSkinFile := nil;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.RestoreDefaultNames;
begin
  fFileName := sknFileName;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.Loaded;
begin
  inherited Loaded;
end;


//==============================================================================
// Properties Get/Set

function TkrpSkinFile.GetDirName: string;
begin
  Result := ExtractFilePath(GetFullFileName);
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.SetFileName(const A: string);
const
  strMessage = 'File "%s" doesn''t exists! Set the FileName property anyway?';
var
  OldFileName : string;

  //-------------------------------------

  procedure _TryCreateFile;
  begin
    try
    // try to create a file
      FileClose(FileCreate(GetFullFileName));
    except
    // Restore old file name
      fFileName := OldFileName;
    end;
  end;{procedure _TryCreateFile}

  //-------------------------------------

  function _WrongName_NeedExit: Boolean;
  begin
    Result := True;
    if (csDesigning in ComponentState) then
    begin
      if [csLoading, csReading, csDestroying] * ComponentState = [] then
        if MessageBoxEx(0, PChar(Format(strMessage, [A])), 'Warning',
          MB_IconExclamation or MB_YesNo or MB_DEFBUTTON2, 0) <> ID_YES then
        begin
        // Restore old file name
          fFileName := OldFileName;
          Exit;
        end;
    // Set property anyway
      Result := False;
    end else
    begin
{$IfDef DEBUG}
      ShowMessage('DEBUG at ' + Name + '.SetFileName : ' +
        Format('File "%s" doesn''t exists!', [GetFullFileName]));
{$EndIf DEBUG}
    // Restore old file name
      fFileName := OldFileName;
    end;
  end;{function _WrongName_NeedExit}

  //-------------------------------------

begin
// Save file name
  OldFileName := fFileName;
  fFileName := A;

// Check file existing
  if not FileExists(GetFullFileName) then
  begin
    if AutoCreateFile then _TryCreateFile else
    if _WrongName_NeedExit then Exit;
  end;

// Everething OK... Create all stuff
  ReCreateSkinFile;
end;{procedure TkrpSkinFile.SetFileName}

//------------------------------------------------------------------------------

function TkrpSkinFile.GetMaskName: string;
begin
  if (Assigned(SkinFile)) then Result := SkinFile.PctMask
  else Result := strNoSkinFile;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.SetMaskName(const A: string);
begin
  if (Assigned(SkinFile)) then SkinFile.PctMask := A;
  krpLoadPictureFromFile(Mask, A);
// Full update
  ReCreateSkinFile;
end;

//------------------------------------------------------------------------------

function TkrpSkinFile.GetPictureNormal: string;
begin
  if (Assigned(SkinFile)) then Result := fSkinFile.PctNormal
  else Result := strNoSkinFile;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.SetPictureNormal(const A: string);
begin
  if (Assigned(SkinFile)) then SkinFile.PctNormal := A;
  krpLoadPictureFromFile(Pictures.Normal, A);
  Update;
end;

//------------------------------------------------------------------------------

function TkrpSkinFile.GetPictureSelected: string;
begin
  if (Assigned(SkinFile)) then Result := fSkinFile.PctSelected
  else Result := strNoSkinFile;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.SetPictureSelected(const A: string);
begin
  if (Assigned(SkinFile)) then SkinFile.PctSelected := A;
  krpLoadPictureFromFile(Pictures.Selected, A);
  Update;
end;

//------------------------------------------------------------------------------

function TkrpSkinFile.GetPictureActive: string;
begin
  if (Assigned(SkinFile)) then Result := fSkinFile.PctActive
  else Result := strNoSkinFile;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.SetPictureActive(const A: string);
begin
  if (Assigned(SkinFile)) then SkinFile.PctActive := A;
  krpLoadPictureFromFile(Pictures.Active, A);
  Update;
end;

//------------------------------------------------------------------------------

function TkrpSkinFile.GetPictureDisabled: string;
begin
  if (Assigned(SkinFile)) then Result := fSkinFile.PctDisabled
  else Result := strNoSkinFile;
end;

//------------------------------------------------------------------------------

procedure TkrpSkinFile.SetPictureDisabled(const A: string);
begin
  if (Assigned(SkinFile)) then SkinFile.PctDisabled := A;
  krpLoadPictureFromFile(Pictures.Disabled, A);
  Update;
end;


{******************************************************************************}
initialization
{******************************************************************************}
{$IfDef krpRegions_Trial}
  krpCheckTrialVersion;
{$EndIf krpRegions_Trial}

end{unit krpRegionsSkins}.
