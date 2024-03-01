/*******************************************************************************

  The Clock - krpRegions library demo project. Main form unit.

  Author:    KARPOLAN
  E-Mail:    karpolan@ABFsoftware.com, karpolan@i.am
  WEB:       http://www.ABFsoftware.com, http://karpolan.i.am
  Copyright © 1996-2000 by KARPOLAN.
  Copyright © 1999, UtilMind Solutions.
  Copyright © 2000 ABF software, Inc.

** History: ********************************************************************

  12 dec 2000 - First version of Clock demo for Borlad C++ Builder

*******************************************************************************/

//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ClockMainBcb.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "krpRegionsImages"
#pragma link "krpRegionsSkingines"
#pragma link "krpRegionsSkins"
#pragma link "krpRegionsAboutForm"
#pragma resource "*.dfm"
TfrmMain *frmMain;

const
  String STimeFormat = "hhmm";
  String SDateFormat = "ddmm";

//---------------------------------------------------------------------------

__fastcall TfrmMain::TfrmMain(TComponent* Owner)
  : TForm(Owner)
{
}

//---------------------------------------------------------------------------

void __fastcall TfrmMain::SetDateTimeMode(bool ATime)
{
  FTimeMode = ATime;
  if (FTimeMode)
  {
    FShowSeparator = False;
    FDateTimeFormat = STimeFormat;
    tmClockTimer(NULL);
  }
  else
  {
    FDateTimeFormat = SDateFormat;
    tmDateTimeSwitcher->Enabled = false;
    tmDateTimeSwitcher->Enabled = true;
  };
}

//---------------------------------------------------------------------------

void __fastcall TfrmMain::WMEraseBkGnd(TWMEraseBkgnd &Message)
{
  Message.Result = 1; // Do nothing, It prevents flickering.
}

//---------------------------------------------------------------------------
// Set time mode as default.

void __fastcall TfrmMain::FormCreate(TObject *Sender)
{
  SetDateTimeMode(true);
}

//---------------------------------------------------------------------------
// Blinks with ":"

void __fastcall TfrmMain::tmClockTimer(TObject *Sender)
{
  String TimeStr;

  TimeStr = FormatDateTime(FDateTimeFormat, Now());
  lbHoures1 ->Caption = TimeStr[1];
  lbHoures2 ->Caption = TimeStr[2];
  lbMinutes1->Caption = TimeStr[3];
  lbMinutes2->Caption = TimeStr[4];
  if (FShowSeparator && FTimeMode)
  {
    lbSeparator->Caption = ":";
  }
  else
  {
    lbSeparator->Caption = "";
  };
  FShowSeparator = !FShowSeparator;
}

//---------------------------------------------------------------------------

void __fastcall TfrmMain::tmDateTimeSwitcherTimer(TObject *Sender)
{
  tmDateTimeSwitcher->Enabled = False;
  SetDateTimeMode(true);
}

//---------------------------------------------------------------------------
// Button Close "X" - Regions[0]. Closes application.

void __fastcall TfrmMain::btnCloseClick(TObject *Sender)
{
  Close();
}

//---------------------------------------------------------------------------
// Button Set - Regions[1]. Shows control panel applet for date and time.

void __fastcall TfrmMain::btnSetClick(TObject *Sender)
{
  WinExec("RunDll32.exe shell32.dll, Control_RunDLL timedate.cpl", SW_SHOW);
}

//---------------------------------------------------------------------------
// Button Select "<>" - Regions[2]. Switches Time and Date modes

void __fastcall TfrmMain::btnSelectClick(TObject *Sender)
{
  SetDateTimeMode(!FTimeMode);
}

//---------------------------------------------------------------------------
// Button Ok - Regions[3]. Minimizes application

void __fastcall TfrmMain::btnOkClick(TObject *Sender)
{
   ShowWindow(Application->Handle, SW_MINIMIZE);
}

//---------------------------------------------------------------------------
// Menu item About. Shows about dilog of the krpRegions library.

void __fastcall TfrmMain::miAboutClick(TObject *Sender)
{
  krpRegionsLibraryAbout();
}

//---------------------------------------------------------------------------
// Menu item Exit. Makes animated clik on the Close "X" button - Region[0].

void __fastcall TfrmMain::miExitClick(TObject *Sender)
{
  skngMain->Regions->Items[0]->AnimateClick();
}

//---------------------------------------------------------------------------
// On Esc key do the same thing as on menu item Exit.

void __fastcall TfrmMain::FormKeyDown(TObject *Sender, WORD &Key,
      TShiftState Shift)
{
  if (Key == VK_ESCAPE)
  {
    miExitClick(NULL);
  }
}
//---------------------------------------------------------------------------

