{*******************************************************************************

  krpRegions library. Constants unit.

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
unit krpRegionsConsts;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, Graphics;

const

//==============================================================================
// Misc
//==============================================================================

  CR = #13'';
  LF = #10'';
  CRLF = CR + LF;
  SkrpAbout = 'About';

//==============================================================================
//  Library
//==============================================================================

  krpVCLVersionMajor   = 2;
  krpVCLVersionMinor   = 0;
  krpVCLVersionRelease = 0;
  krpVCLVersionBuild   = 299;
  krpVCLVersion = (krpVCLVersionMajor shl 24) or (krpVCLVersionMinor shl 16) or
    (krpVCLVersionRelease shl 8) or krpVCLVersionBuild;

  SkrpVCLVersion = '2.0.0.299';
  SkrpCompanyName = 'ABF software, Inc.';
  SkrpComponentPalette = 'krpRegions';
  clLink: TColor = $00CAFDFC;

//------------------------------------------------------------------------------
// http://

  SkrpWeb = 'www.abf-dev.com/krp-regions-library.shtml';
//  SkrpWeb_Register = SkrpWeb;
  SkrpWeb_Register = 'www.abf-dev.com/buy.shtml';

//------------------------------------------------------------------------------
// mailto:

  SkrpEmail = 'krp-regions-library@abf-dev.com';

//==============================================================================
// Messages, captions, errors, etc.
//==============================================================================

{$IfDef krpRegions_Trial}
  SkrpMsgTrial =
    'This application uses an unregistered' + CRLF +
    'version of the ABF software, Inc. product.' + CRLF +
    'Do you want to register it right now?';

  SabfMsgHacked =
    'This application uses a HACKED version of the ABF software, Inc. product.' + CRLF +
    'STOP using it! It is ILLEGAL! Register it! Do you want to register it right now?';
{$EndIf krpRegions_Trial}

//==============================================================================
// Messages const (KR = krpRegions)
//==============================================================================

  KR_Base             = WM_User + 1000;
  KR_RegionRecreate   = KR_Base + 1;
  KR_RegionMouseEnter = KR_Base + 2;
  KR_RegionMouseLeave = KR_Base + 3;
  KR_RegionActivate   = KR_Base + 4;
  KR_RegionDeactivate = KR_Base + 5;
  KR_UpdateRegionArea = KR_Base + 100;

//==============================================================================
// INI file consts
//==============================================================================

  Sini_Sect_FileInfo      = 'FileInfo';    // File Info section
  Sini_Field_Project      = 'Project';     // Project is a target of scheme file
  Sini_Field_Description  = 'Description'; // Description of file: Name, etc.
  Sini_Field_Version      = 'Version';     // Version of file.
  Sini_Field_Author       = 'Author';      // Author of file: Name, Nickname, etc.
  Sini_Field_Copyright    = 'Copyright';   // Legal copyright.

//==============================================================================
// Skin file const (skn = Skin)
//==============================================================================

  sknFileName      = 'skin.ini';

// FileInfo Section - contain information about file (for backward capability)
  sknFileInfo      = Sini_Sect_FileInfo;     // Section Description.
  sknFIProject     = Sini_Field_Project;     // Project is a target file of skin
  sknFIDescription = Sini_Field_Description; // Description of file: Name, etc.
  sknFIVersion     = Sini_Field_Version;     // Version of file.
  sknFIAuthor      = Sini_Field_Author;      // Author of file: Name, Nickname, etc.
  sknFICopyright   = Sini_Field_Copyright;   // Legal copyright.

// Pictures Section - contain information about skin's files
  sknPictures      = 'Pictures';    // Section Description.
  sknPctMask       = 'Mask';        // Name of Mask file.
  sknPctNormal     = 'Normal';      // Name of Normal   Picture file.
  sknPctSelected   = 'Selected';    // Name of Selected Picture file.
  sknPctActive     = 'Active';      // Name of Active   Picture file.
  sknPctDisabled   = 'Disabled';    // Name of Disabled Picture file.

// For future use
  sknRegions  = 'Regions';
  sknRgnCount = 'Count';

//==============================================================================
// Othes string consts
//==============================================================================

  SkrpAppPath: string = ''; // There will be a path of the application file
  SkrpSkinFileFilter = 'Skin file (skin.ini)|' + sknFileName;
  SkrpDefaultFilter  = 'All files (*.*)|*.*';
  SkrpUnknown = '(Unknown)';
  SkrpNone = '(None)';


{******************************************************************************}
implementation
{******************************************************************************}

uses
  SysUtils;

{$IfDef krpRegions_Trial}
var
  S: string;
{$EndIf krpRegions_Trial}

{******************************************************************************}
initialization
{******************************************************************************}
{$IfDef krpRegions_Trial}
// Prevent removing of constant by optimization.
  S := SabfMsgHacked + ' ';
{$EndIf krpRegions_Trial}

// Get application path
  SkrpAppPath := ExtractFilePath(ParamStr(0));

end{unit krpRegionsConsts}.
