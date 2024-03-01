//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("krpRegions_C4.res");
USEPACKAGE("vcl40.bpi");
USEUNIT("krpRegionsReg.pas");
USEPACKAGE("vclx40.bpi");
USEPACKAGE("vcljpg40.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
