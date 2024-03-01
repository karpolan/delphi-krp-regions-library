{*******************************************************************************

  The Clock - krpRegions library demo project. Main form unit.

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
unit ClockMain;

{$I krpRegions.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellApi, Menus, Buttons,
  krpRegionsSkins, krpRegionsImages, krpRegionsSkingines, krpRegionsAboutForm;

type

//==============================================================================
// TfrmMain
//==============================================================================

  TfrmMain = class(TForm)
    skngMain: TkrpColorSkingine;
    pnTablo: TPanel;
      lbHoures1: TLabel;
      lbHoures2: TLabel;
      lbSeparator: TLabel;
      lbMinutes1: TLabel;
      lbMinutes2: TLabel;
    sknMain: TkrpSkin;
    tmClock: TTimer;
    tmDateTimeSwitcher: TTimer;
    pmBody: TPopupMenu;
      miAbout: TMenuItem;
      mi1: TMenuItem;
      miExit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure tmClockTimer(Sender: TObject);
    procedure tmDateTimeSwitcherTimer(Sender: TObject);
  { 'Buttons' events }
    procedure btnCloseClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  { Menu events }
    procedure miAboutClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FShowSeparator: Boolean;
    FTimeMode: Boolean;
    FDateTimeFormat: String;
  { Messages routines }
    procedure WMEraseBkGnd(var Message: TMessage); message WM_ERASEBKGND;
  public
    procedure SetDateTimeMode(ATime: Boolean);
  end;{TfrmMain = class(TForm)}

var
  frmMain: TfrmMain;

{******************************************************************************}
implementation
{******************************************************************************}
{$R *.DFM}

const
  STimeFormat = 'hhmm';
  SDateFormat = 'ddmm';

//==============================================================================
// TfrmMain
//==============================================================================
{ TfrmMain }

//------------------------------------------------------------------------------

procedure TfrmMain.SetDateTimeMode(ATime: Boolean);
begin
  FTimeMode := ATime;
  if FTimeMode then
  begin
    FShowSeparator := False;
    FDateTimeFormat := STimeFormat;
    tmClockTimer(nil);
  end else
  begin
    FDateTimeFormat := SDateFormat;
    tmDateTimeSwitcher.Enabled := False;
    tmDateTimeSwitcher.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.WMEraseBkGnd(var Message: TMessage);
begin
  Message.Result := 1; // Do nothing, It prevents flickering.
end;

//------------------------------------------------------------------------------
// Set time mode as default.

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SetDateTimeMode(True);
end;

//------------------------------------------------------------------------------
// Blinks with ":"

procedure TfrmMain.tmClockTimer(Sender: TObject);
var
  TimeStr: string;
begin
  TimeStr := FormatDateTime(FDateTimeFormat, Now);
  lbHoures1 .Caption := TimeStr[1];
  lbHoures2 .Caption := TimeStr[2];
  lbMinutes1.Caption := TimeStr[3];
  lbMinutes2.Caption := TimeStr[4];
  if FShowSeparator and FTimeMode then lbSeparator.Caption := ':'
  else lbSeparator.Caption := '';
  FShowSeparator := not FShowSeparator;
end;

//------------------------------------------------------------------------------

procedure TfrmMain.tmDateTimeSwitcherTimer(Sender: TObject);
begin
  (Sender as TTimer).Enabled := False;
  SetDateTimeMode(True);
end;

//------------------------------------------------------------------------------
// Button Close "X" - Regions[0]. Closes application.

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
// Button Set - Regions[1]. Shows control panel applet for date and time.

procedure TfrmMain.btnSetClick(Sender: TObject);
begin
  WinExec('RunDll32.exe shell32.dll,Control_RunDLL timedate.cpl', SW_SHOW);
end;

//------------------------------------------------------------------------------
// Button Select "<>" - Regions[2]. Switches Time and Date modes

procedure TfrmMain.btnSelectClick(Sender: TObject);
begin
  SetDateTimeMode(not FTimeMode);
end;

//------------------------------------------------------------------------------
// Button Ok - Regions[3]. Minimizes application

procedure TfrmMain.btnOkClick(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_MINIMIZE);
end;

//------------------------------------------------------------------------------
// Menu item About. Shows about dilog of the krpRegions library.

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  krpRegionsLibraryAbout;
end;

//------------------------------------------------------------------------------
// Menu item Exit. Makes animated clik on the Close "X" button - Region[0].

procedure TfrmMain.miExitClick(Sender: TObject);
begin
  skngMain.Regions[0].AnimateClick;
end;

//------------------------------------------------------------------------------
// On Esc key do the same thing as on menu item Exit.

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then miExitClick(nil);
end;

//------------------------------------------------------------------------------

end{unit ClockMain}.
