{*******************************************************************************

  The Clock - krpRegions library demo project.

  Author:    KARPOLAN
  E-Mail:    karpolan@ABFsoftware.com, karpolan@i.am
  WEB:       http://www.ABFsoftware.com, http://karpolan.i.am
  Copyright © 1996-2000 by KARPOLAN.
  Copyright © 1999, UtilMind Solutions.
  Copyright © 2000 ABF software, Inc.

** History: ********************************************************************

  26 nov 1999 - Added as a Demo to the krpRegion library Version 1.1.
  06 jun 2000 - Now distributed by ABF software, Inc.
    <http://www.ABFsoftware.com>. Some minor changes.
  05 oct 2000 - WM_ERASEBKGND message now is skipped, It prevents flickering
    under Win 2000. Some minor changes.
  12 dec 2000 - Esc key routine added.

*******************************************************************************}
program Clock;

uses
  Forms,
  ClockMain in 'ClockMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
