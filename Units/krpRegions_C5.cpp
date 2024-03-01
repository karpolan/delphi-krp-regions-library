//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("krpRegions_C5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("krpRegionsReg.pas");
USEPACKAGE("vclx50.bpi");
USEPACKAGE("vcljpg50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  return 1;
}
//---------------------------------------------------------------------------
