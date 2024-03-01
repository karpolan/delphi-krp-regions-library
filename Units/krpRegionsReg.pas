{*******************************************************************************

  krpRegions library. Components and classes registration routines.

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
unit krpRegionsReg;

{$I krpRegions.inc}
{$WARNINGS OFF}

interface

procedure Register;

{******************************************************************************}
implementation
{******************************************************************************}
{$R *.res}
uses
{$IfDef D6}
  DesignIntf,
{$Else D6}
  DsgnIntf,
{$EndIf D6}  
  Classes, Dialogs, Graphics,
{$IfDef krpRegions_UseGif} krpRegionsGif, {$EndIf krpRegions_UseGif}
{$IfDef krpRegions_UsePcx} krpRegionsPcx, {$EndIf krpRegions_UsePcx}
  krpRegionsConsts, krpRegionsDesigning,  krpRegionsDialogs, krpRegionsSkins,
  krpRegionsComponents, krpRegionsImages, krpRegionsSkingines;

//------------------------------------------------------------------------------

procedure Register;
begin
// krpRegionsComponents unit
  RegisterClass(TkrpCustomControlRegion);
    RegisterComponentEditor(TkrpCustomControlRegion, TkrpRegionsDefaultEditor);
  RegisterComponents(SkrpComponentPalette, [TkrpControlRegion,
    TkrpFastDrawingPanel]);
  RegisterPropertyEditor(TypeInfo(string), TkrpControlRegion, SkrpAbout,
    TkrpAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TkrpFastDrawingPanel, SkrpAbout,
    TkrpAboutProperty);
// krpRegionsImages unit
  RegisterClass(TkrpCustomRegionImage);
    RegisterComponentEditor(TkrpCustomRegionImage, TkrpRegionsDefaultEditor);
  RegisterComponents(SkrpComponentPalette, [TkrpRegionImage]);
  RegisterPropertyEditor(TypeInfo(string), TkrpCustomRegionImage, SkrpAbout,
    TkrpAboutProperty);
// krpRegionsSkines unit
  RegisterClass(TkrpCustomSkin);
    RegisterComponentEditor(TkrpCustomSkin, TkrpRegionsDefaultEditor);
  RegisterComponents(SkrpComponentPalette, [TkrpSkin, TkrpSkinFile]);
  RegisterPropertyEditor(TypeInfo(string), TkrpCustomSkin, SkrpAbout,
    TkrpAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TkrpSkinFile, 'FileName',
    TkrpSkinFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TkrpSkinFile, 'MaskName',
    TkrpShortFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TkrpSkinFile, 'PictureNormal',
    TkrpShortFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TkrpSkinFile, 'PictureSelected',
    TkrpShortFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TkrpSkinFile, 'PictureActive',
    TkrpShortFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TkrpSkinFile, 'PictureDisabled',
    TkrpShortFileNameProperty);
// krpRegionsSkingines unit
  RegisterClass(TkrpCustomSkingine);
    RegisterComponentEditor(TkrpCustomSkingine, TkrpCustomSkingineEditor);
  RegisterComponents(SkrpComponentPalette, [TkrpRectSkingine,
    TkrpColorSkingine]);
  RegisterComponentEditor(TkrpColorSkingine, TkrpColorSkingineEditor);
// krpRegionsDialogs unit
  RegisterComponents(SkrpComponentPalette, [TkrpOpenSkinDialog]);
    RegisterComponentEditor(TkrpOpenSkinDialog, TkrpRegionsDefaultEditor);
  RegisterPropertyEditor(TypeInfo(string), TkrpOpenSkinDialog, SkrpAbout,
    TkrpAboutProperty);
end;{Procedure Register}

//------------------------------------------------------------------------------

end{unit krpRegionsReg}.
