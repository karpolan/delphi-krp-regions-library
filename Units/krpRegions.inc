{*******************************************************************************

  krpRegions library. Compiler directives.

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

{$Define Delphi}

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
{$Define C6}
{$Define CPB6}
{$Define D7}
{$Define D8}
{$Define D9}

//------------------------------------------------------------------------------
// Delphi 1

{$IfDef VER80}
  {$Define D1_ONLY}

  {$UnDef D2}
  {$UnDef C1}
  {$UnDef CPB1}
  {$UnDef D3}
  {$UnDef C3}
  {$UnDef CPB3}
  {$UnDef D4}
  {$UnDef C4}
  {$UnDef CPB4}
  {$UnDef D5}
  {$UnDef C5}
  {$UnDef CPB5}
  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 2

{$IfDef VER90}
  {$Define D2_ONLY}

  {$UnDef C1}
  {$UnDef CPB1}
  {$UnDef D3}
  {$UnDef C3}
  {$UnDef CPB3}
  {$UnDef D4}
  {$UnDef C4}
  {$UnDef CPB4}
  {$UnDef D5}
  {$UnDef C5}
  {$UnDef CPB5}
  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// CBuilder 1

{$IfDef VER93}
  {$Define C1_ONLY}

  {$UnDef  Delphi}
  {$Define Builder}
  {$Define BCB}

  {$UnDef D3}
  {$UnDef C3}
  {$UnDef CPB3}
  {$UnDef D4}
  {$UnDef C4}
  {$UnDef CPB4}
  {$UnDef D5}
  {$UnDef C5}
  {$UnDef CPB5}
  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 3

{$IfDef VER100}
  {$Define D3_ONLY}

  {$UnDef C3}
  {$UnDef CPB3}
  {$UnDef D4}
  {$UnDef C4}
  {$UnDef CPB4}
  {$UnDef D5}
  {$UnDef C5}
  {$UnDef CPB5}
  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// CBuilder 3

{$IfDef VER110}
  {$Define C3_ONLY}

  {$UnDef  Delphi}
  {$Define Builder}

  {$UnDef D4}
  {$UnDef C4}
  {$UnDef CPB4}
  {$UnDef D5}
  {$UnDef C5}
  {$UnDef CPB5}
  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 4

{$IfDef VER120}
  {$Define D4_ONLY}

  {$UnDef C4}
  {$UnDef CPB4}
  {$UnDef D5}
  {$UnDef C5}
  {$UnDef CPB5}
  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// CBuilder 4

{$IfDef VER125}
  {$Define C4_ONLY}

  {$UnDef  Delphi}
  {$Define Builder}

  {$UnDef D5}
  {$UnDef C5}
  {$UnDef CPB5}
  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi/CBuilder 5

{$IfDef VER130}
  {$IfDef BCB}
    {$Define C5_ONLY}

    {$UnDef  Delphi}
    {$Define Builder}
  {$Else BCB}
    {$Define D5_ONLY}

    {$UnDef C5}
    {$UnDef CPB5}
  {$EndIf BCB}

  {$UnDef D6}
  {$UnDef C6}
  {$UnDef CPB6}
  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi/CBuilder 6

{$IfDef VER140}
  {$IfDef BCB}
    {$Define C6_ONLY}

    {$UnDef  Delphi}
    {$Define Builder}
  {$Else BCB}
    {$Define D6_ONLY}

    {$UnDef C6}
    {$UnDef CPB6}
  {$EndIf BCB}

  {$UnDef D7}
  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 7

{$IfDef VER150}
  {$Define D7_ONLY}

  {$UnDef D8}
  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 8

{$IfDef VER160}
  {$Define D8_ONLY}

  {$UnDef D9}
{$EndIf}

//------------------------------------------------------------------------------
// Delphi 9

{$IfDef VER170}
  {$Define D9_ONLY}
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
