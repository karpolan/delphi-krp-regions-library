/*******************************************************************************

  The Clock - krpRegions library demo project.

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
USERES("Clock.res");
USEFORM("..\ClockMainBcb.cpp", frmMain);

//---------------------------------------------------------------------------

WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
  try
  {
    Application->Initialize();
    Application->CreateForm(__classid(TfrmMain), &frmMain);
    Application->Run();
  }
  catch (Exception &exception)
  {
    Application->ShowException(&exception);
  }
  return 0;
}

//---------------------------------------------------------------------------
