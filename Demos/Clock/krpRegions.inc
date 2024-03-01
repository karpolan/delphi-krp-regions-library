{*******************************************************************************

  krpRegions library. Compiler directives.

  Author: KARPOLAN

  Copyright © 1996-2002 by KARPOLAN.
  Copyright © 1999, UtilMind Solutions.
  Copyright © 2000-2002 ABF software, Inc.
  All Rights Reserved.

  e-mail: info@ABFsoftware.com, karpolan@ABFsoftware.com
  web:    http://www.ABFsoftware.com

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

//==============================================================================
// Default compiler options.
//==============================================================================
{$B-} // Complete Boolean Evaluation
{$R-} // Range-Checking
{$T-} // Typed @ operator
{$X+} // Extended syntax
{$P+} // Open string params
{$J+} // Writeable structured consts
{$H+} // Use long strings by default
{$Q-} // Overflow checking


//==============================================================================
// Determination of the Delphi/C++Builder version.
//==============================================================================

//------------------------------------------------------------------------------
// Delphi 1

{$IfDef VER80}
  {$Define D1_ONLY}
  {$Define Delphi}
  {$Define D1}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 2

{$IfDef VER90}
  {$Define D2_ONLY}
  {$Define Delphi}
  {$Define D1}
  {$Define D2}
{$EndIf}

//------------------------------------------------------------------------------
// CBuilder 1

{$IfDef VER93}
  {$Define BCB}
  {$Define C1_ONLY}
  {$Define Builder}
  {$Define C1}
  {$Define CPB1}
  {$Define D1}
  {$Define D2}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 3

{$IfDef VER100}
  {$Define D3_ONLY}
  {$Define Delphi}
  {$Define D1}
  {$Define D2}
  {$Define C1}
  {$Define CPB1}
  {$Define D3}
{$EndIf}

//------------------------------------------------------------------------------
// CBuilder 3

{$IfDef VER110}
  {$Define C3_ONLY}
  {$Define Builder}
  {$Define D1}
  {$Define D2}
  {$Define C1}
  {$Define CPB1}
  {$Define D3}
  {$Define C3}
  {$Define CPB3}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 4

{$IfDef VER120}
  {$Define D4_ONLY}
  {$Define Delphi}
  {$Define D1}
  {$Define D2}
  {$Define C1}
  {$Define CPB1}
  {$Define D3}
  {$Define C3}
  {$Define CPB3}
  {$Define D4}
{$EndIf}

//------------------------------------------------------------------------------
// CBuilder 4

{$IfDef VER125}
  {$Define C4_ONLY}
  {$Define Builder}
  {$Define D1}
  {$Define D2}
  {$Define C1}
  {$Define CPB1}
  {$Define D3}
  {$Define C3}
  {$Define CPB3}
  {$Define D4}
  {$Define C4}
  {$Define CPB4}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi/CBuilder 5

{$IfDef VER130}
  {$Define D1}
  {$Define D2}
  {$Define C1}
  {$Define CPB1}
  {$Define D3}
  {$Define C3}
  {$Define CPB3}
  {$Define D4}
  {$Define C4}
  {$Define CPB4}
  {$Define D5}
  {$IfDef BCB}
    {$Define C5_ONLY}
    {$Define Builder}
    {$Define C5}
    {$Define CPB5}
  {$Else BCB}
    {$Define D5_ONLY}
    {$Define Delphi}
  {$EndIf BCB}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi/CBuilder 6

{$IfDef VER140}
  {$Define D1}
  {$Define D2}
  {$Define C1}
  {$Define CPB1}
  {$Define D3}
  {$Define C3}
  {$Define CPB3}
  {$Define D4}
  {$Define C4}
  {$Define CPB4}
  {$Define D5}
  {$Define C5}
  {$Define CPB5}
  {$Define D6}
  {$IfDef BCB}
    {$Define C6_ONLY}
    {$Define Builder}
    {$Define C6}
    {$Define CPB6}
  {$Else BCB}
    {$Define D6_ONLY}
    {$Define Delphi}
  {$EndIf BCB}
{$EndIf}


{*******************************************************************************
  Directives turn on/off some file support.
*******************************************************************************}
{$Define krpRegions_UseGif}
{$Define krpRegions_UsePcx}

{*******************************************************************************
  Directive DEBUG turn on/off some debug messages.
*******************************************************************************}
//{$Define DEBUG}

{*******************************************************************************
  Directive krpRegion_Trial turn on/off Trial message.
*******************************************************************************}
//{$Define krpRegions_Trial}
