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

#ifndef ClockMainBcbH
#define ClockMainBcbH

//---------------------------------------------------------------------------

#include <Controls.hpp>
#include <Graphics.hpp>
#include <Classes.hpp>
#include <Messages.hpp>
#include <Windows.hpp>
#include <System.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Graphics.hpp>
#include <Menus.hpp>
#include <StdCtrls.hpp>
#include "krpRegionsImages.hpp"
#include "krpRegionsSkingines.hpp"
#include "krpRegionsSkins.hpp"
#include "krpRegionsAboutForm.hpp"

//---------------------------------------------------------------------------

class TfrmMain : public TForm
{
__published:
// IDE-managed Components
  TkrpColorSkingine *skngMain;
  TPanel *pnTablo;
  TLabel *lbHoures1;
  TLabel *lbHoures2;
  TLabel *lbSeparator;
  TLabel *lbMinutes1;
  TLabel *lbMinutes2;
  TkrpSkin *sknMain;
  TTimer *tmClock;
  TTimer *tmDateTimeSwitcher;
  TPopupMenu *pmBody;
  TMenuItem *miAbout;
  TMenuItem *mi1;
  TMenuItem *miExit;
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall tmClockTimer(TObject *Sender);
  void __fastcall tmDateTimeSwitcherTimer(TObject *Sender);
  void __fastcall btnCloseClick(TObject *Sender);
  void __fastcall btnSetClick(TObject *Sender);
  void __fastcall btnSelectClick(TObject *Sender);
  void __fastcall btnOkClick(TObject *Sender);
  void __fastcall miAboutClick(TObject *Sender);
  void __fastcall miExitClick(TObject *Sender);
  void __fastcall FormKeyDown(TObject *Sender, WORD &Key,
          TShiftState Shift);
public:
  __fastcall TfrmMain(TComponent* Owner);
  void __fastcall SetDateTimeMode(bool ATime);

private:
  bool FShowSeparator;
  bool FTimeMode;
  String FDateTimeFormat;

	MESSAGE void __fastcall WMEraseBkGnd(TWMEraseBkgnd &Message);

// Message map
BEGIN_MESSAGE_MAP
  VCL_MESSAGE_HANDLER(WM_ERASEBKGND, TWMEraseBkgnd, WMEraseBkGnd);
END_MESSAGE_MAP(TForm);
};

//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif
