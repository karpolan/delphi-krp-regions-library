{*******************************************************************************

  Lens - magnifying glass.

  Author:    KARPOLAN
  E-Mail:    karpolan@ABFsoftware.com, karpolan@i.am
  WEB:       http://www.ABFsoftware.com, http://karpolan.i.am
  Copyright � 1996-2000 by KARPOLAN.
  Copyright � 1999 UtilMind Solutions.
  Copyright � 2000 ABF software, Inc.
  All rights reserved.

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

  DISCLAIMER

  THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS WITHOUT WARRANTY OF ANY KIND,
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE PERSON USING THE
SOFTWARE BEARS ALL RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE.
THE AUTHOR WILL NOT BE LIABLE FOR ANY SPECIAL, INCIDENTAL, CONSEQUENTIAL,
INDIRECT OR SIMILAR DAMAGES DUE TO LOSS OF DATA OR ANY OTHER REASON, EVEN IF
THE AUTHOR OR AN AGENT OF THE AUTHOR HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES. IN NO EVENT SHALL THE AUTHOR'S LIABILITY FOR ANY DAMAGES EVER
EXCEED THE PRICE PAID FOR THE LICENSE TO USE THE SOFTWARE, REGARDLESS OF THE
FORM OF THE CLAIM.

** History: ********************************************************************

  29 oct 1999 - 1.0 first release.
  02 nov 1999 - 1.1 added keyboard support. Skin, position and zoom values
    are stored in the system registry now.
  05 nov 1999 - 1.11 fixed bug under Win95 (Square lens)....
  09 nov 1999 - 1.2 added Help.
  27 nov 1999 - 1.21 Added new features of the krpRegions library version 1.1,
    fixed help file.
  06 jun 2000 - 1.3 Added new features of the krpRegions library version 1.2,
    Now distributed by ABF software, Inc. <http://www.ABFsoftware.com>.
    Some minor changes.
  16 jun 2000 - 1.31 Fixed bug under Windows NT and Windows 2000 in 15/16 bit
    (32768/65536 colors) video modes. Added color value hint.
  25 nov 2000 - 1.4 Upgrade from the web feature. New skin for people with
    poor eyesight. More keyboard control combination: F9 - BIG skin;
    F5, F6, F7, F8, Shift + "+", Shift + "-" - zoom manipulation. Added more
    languages in the installation program.

*******************************************************************************}
program Lens;

{$I Lens.inc}

uses
  Forms,
  LensMainForm in 'LensMainForm.pas' {frmMain},
  LensAboutForm in 'LensAboutForm.pas' {frmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
