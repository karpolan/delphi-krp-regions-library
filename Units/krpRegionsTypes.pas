{*******************************************************************************

  krpRegions library. Base types.

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
unit krpRegionsTypes;

{$I krpRegions.inc}

interface

uses
  Windows, Classes, Controls, Graphics, Messages, Menus, IniFiles,
  krpRegionsConsts;

type
  PBGRColor = ^TBGRColor;
  TBGRColor = packed record
    R, G, B, A: Byte;
  end;

  TkrpBorderStyle = (bsNone, bsSingle, bsDouble);
  TkrpRunTimeState  = (rtsNormal, rtsSelected, rtsActive, rtsDisabled);
  TkrpRunTimeStates = set of TkrpRunTimeState;

//==============================================================================
// TkrpRegion
//==============================================================================
// Region incapsulating class.

  TkrpRegion = class
  protected
    fRegion: HRgn;
  public
    constructor Create(ARgn: HRgn);
    constructor CreateAsRegionCopy(ARgn: HRgn; AInt: Integer);
    constructor CreateFromRect(ARect: TRect);
    constructor CreateEmpty;
    constructor CreateFromMask(const AMask: TGraphic; AMaskColor: TColor;
      AInverted: Boolean);
    constructor CreateFromMaskColorDefault(const AMask: TGraphic;
      AInverted: Boolean);
    destructor Destroy; override;
  // Properties
    property Region: HRgn read fRegion;
  end;


//==============================================================================
// TkrpRegionsIniFile
//==============================================================================
// Base class of Skin/Scheme files. Windows styled INI file. Has wrappers
// for reading/writing variables from/to the INI file.

  TkrpRegionsIniFile = class(TIniFile)
  protected
    function  GetProject: string;  virtual;
    procedure SetProject(const A: string); virtual;
    function  GetDescription: string; virtual;
    procedure SetDescription(const A: string); virtual;
    function  GetCopyright: string; virtual;
    procedure SetCopyright(const A: string); virtual;
    function  GetAuthor: string; virtual;
    procedure SetAuthor(const A: string); virtual;
    function  GetVersion: string; virtual;
    procedure SetVersion(const A: string); virtual;
  public
  // FileInfo section
    property Project: string read GetProject write SetProject;
    property Description: string read GetDescription write SetDescription;
    property Copyright: string read GetCopyright write SetCopyright;
    property Author: string read GetAuthor write SetAuthor;
    property Version: string read GetVersion write SetVersion;
  end;{TkrpRegionsIniFile = class(TIniFile)}


//==============================================================================
// TkrpRegionsSkinFile
//==============================================================================
// Class for easy support of SkinFiles (Windows styled INI files). Has wrappers
// for reading/writing any of skin variables from/to the skin file.

  TkrpRegionsSkinFile = class(TkrpRegionsIniFile)
  protected
    function  GetPctMask: string; virtual;
    procedure SetPctMask(const A: string); virtual;
    function  GetPctNormal: string; virtual;
    procedure SetPctNormal(const A: string); virtual;
    function  GetPctSelected: string; virtual;
    procedure SetPctSelected(const A: string); virtual;
    function  GetPctActive: string; virtual;
    procedure SetPctActive(const A: string); virtual;
    function  GetPctDisabled: string; virtual;
    procedure SetPctDisabled(const A: string); virtual;
  public
  // Pictures Section
    property PctMask: string read GetPctMask write SetPctMask;
    property PctNormal: string read GetPctNormal write SetPctNormal;
    property PctSelected: string read GetPctSelected write SetPctSelected;
    property PctActive: string read GetPctActive write SetPctActive;
    property PctDisabled: string read GetPctDisabled write SetPctDisabled;
  end;{TkrpRegionsSkinFile = class(TkrpRegionsIniFile)}

  TSkinFile = TkrpRegionsSkinFile;


//==============================================================================
// TkrpLinkedComponent
//==============================================================================
// Use TkrpLinkedComponent component in classes that are not descendants of
// TComponent but needs to respond standard Delphi notification routine. Very
// useful for persistents that contain information about some component which
// can be removed from the form or simply destroyed.

  TkrpFreeNotifyProc = procedure(Instance: TComponent) of object;

  TkrpLinkedComponent = class(TComponent)
  protected
    FNotifier: TkrpFreeNotifyProc;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor CreateInderect(AOwner: TComponent;
      ANotifier: TkrpFreeNotifyProc); virtual;
    property Notifier: TkrpFreeNotifyProc read FNotifier write FNotifier;
  end;


{******************************************************************************}
implementation
{******************************************************************************}
uses
  krpRegionsProcs, Forms;

//==============================================================================
// TkrpRegion
//==============================================================================
// Region incapsulating class.
{ TkrpRegion }

constructor TkrpRegion.Create(ARgn : HRgn);
begin
  inherited Create;
  fRegion := ARgn;
end;

//------------------------------------------------------------------------------

constructor TkrpRegion.CreateAsRegionCopy(ARgn: HRgn; AInt: Integer);
begin
  CreateFromRect(Rect(0, 0, 0, 0));
  CombineRgn(Region, ARgn, ARgn, RGN_COPY);
end;

//------------------------------------------------------------------------------

constructor TkrpRegion.CreateFromMask(const AMask: TGraphic;
  AMaskColor: TColor; AInverted: Boolean);
begin
  Create(krpGraphicToRegion(AMask, AMaskColor, AInverted));
end;

//------------------------------------------------------------------------------

constructor TkrpRegion.CreateFromMaskColorDefault(const AMask: TGraphic;
  AInverted: Boolean);
begin
  Create(krpGraphicToRegionColorDefault(AMask, AInverted));
end;

//------------------------------------------------------------------------------

constructor TkrpRegion.CreateFromRect(ARect: TRect);
begin
  with ARect do
    Create(CreateRectRgn(Left, Top, Right, Bottom));
end;

//------------------------------------------------------------------------------

constructor TkrpRegion.CreateEmpty;
begin
  CreateFromRect(Rect(0, 0, 0, 0));
end;

//------------------------------------------------------------------------------

destructor TkrpRegion.Destroy;
begin
  if Region <> 0 then DeleteObject(Region);
  inherited Destroy;
end;


//==============================================================================
// TkrpRegionsIniFile
//==============================================================================
// Base class of Skin/Scheme files. Windows styled INI file. Has wrappers
// for reading/writing variables from/to the INI file.
{ TkrpRegionsIniFile }

function TkrpRegionsIniFile.GetProject : string;
begin
  Result := ReadString(Sini_Sect_FileInfo, Sini_Field_Project, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsIniFile.SetProject(const A : string);
begin
  WriteString(Sini_Sect_FileInfo, Sini_Field_Project, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsIniFile.GetDescription : string;
begin
  Result := ReadString(Sini_Sect_FileInfo, Sini_Field_Description, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsIniFile.SetDescription(const A : string);
begin
  WriteString(Sini_Sect_FileInfo, Sini_Field_Description, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsIniFile.GetCopyright : string;
begin
  Result := ReadString(Sini_Sect_FileInfo, Sini_Field_Copyright, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsIniFile.SetCopyright(const A : string);
begin
  WriteString(Sini_Sect_FileInfo, Sini_Field_Copyright, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsIniFile.GetAuthor : string;
begin
  Result := ReadString(Sini_Sect_FileInfo, Sini_Field_Author, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsIniFile.SetAuthor(const A : string);
begin
  WriteString(Sini_Sect_FileInfo, Sini_Field_Author, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsIniFile.GetVersion : string;
begin
  Result := ReadString(Sini_Sect_FileInfo, Sini_Field_Version, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsIniFile.SetVersion(const A : string);
begin
  WriteString(Sini_Sect_FileInfo, Sini_Field_Version, A);
end;


//==============================================================================
// TkrpRegionsSkinFile
//==============================================================================
// Class for easy support of SkinFiles (Windows styled INI files). Has wrappers
// for reading/writing any of skin variables from/to the skin file.
{ TkrpRegionsIniFile }

function TkrpRegionsSkinFile.GetPctMask : string;
begin
  Result := ReadString(sknPictures, sknPctMask, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsSkinFile.SetPctMask(const A : string);
begin
  WriteString(sknPictures, sknPctMask, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsSkinFile.GetPctNormal : string;
begin
  Result := ReadString(sknPictures, sknPctNormal, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsSkinFile.SetPctNormal(const A : string);
begin
  WriteString(sknPictures, sknPctNormal, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsSkinFile.GetPctSelected : string;
begin
  Result := ReadString(sknPictures, sknPctSelected, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsSkinFile.SetPctSelected(const A : string);
begin
  WriteString(sknPictures, sknPctSelected, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsSkinFile.GetPctActive : string;
begin
  Result := ReadString(sknPictures, sknPctActive, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsSkinFile.SetPctActive(const A : string);
begin
  WriteString(sknPictures, sknPctActive, A);
end;

//------------------------------------------------------------------------------

function TkrpRegionsSkinFile.GetPctDisabled : string;
begin
  Result := ReadString(sknPictures, sknPctDisabled, '');
end;

//------------------------------------------------------------------------------

procedure TkrpRegionsSkinFile.SetPctDisabled(const A : string);
begin
  WriteString(sknPictures, sknPctDisabled, A);
end;


//==============================================================================
// TkrpLinkedComponent
//==============================================================================
// Use TkrpLinkedComponent component in classes that are not descendants of
// TComponent but needs to respond standard Delphi notification routine. Very
// useful for persistents that contain information about some component which
// can be removed from the form or simply destroyed.
{ TkrpLinkedComponent }

constructor TkrpLinkedComponent.CreateInderect(AOwner: TComponent;
  ANotifier: TkrpFreeNotifyProc);
begin
  FNotifier := ANotifier;
  Create(AOwner);
end;

//------------------------------------------------------------------------------

procedure TkrpLinkedComponent.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (Assigned(FNotifier)) then
    FNotifier(AComponent);
end;

//------------------------------------------------------------------------------

end{unit krpRegionsTypes}.
