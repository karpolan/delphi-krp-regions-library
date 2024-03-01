:*******************************************************************************
:** Makes distributive for one version of Delphi or C++Builder
:**   %1 - name of the destributive product (abfXXX)
:**   %2 - folder name where distributive will be created
:**   %3 - Delphi or C++Builder abbreviation D2 - Delphi 2, C4 - C++Builder 4
:**   %4 - compiler path depending on Delphi/C++Builder version (..\bin\)
:**   %5 - files or parameters for compiling.
:**   %6 - date stamp distributive files should have.
:**   %7 - time stamp distributive files should have.
:*******************************************************************************

:******************************************************************************
:** Create the source and distributive folders  
:******************************************************************************
MD %2
MD %3

:******************************************************************************
:** Copy all needed source files  
:******************************************************************************
copy _SrcList\%2\common.lst + _SrcList\%2\%3.lst _List.lst
Copier.exe _List.lst ..\..\ %3

:******************************************************************************
:** Build source files and make *.int files 
:******************************************************************************
cd %3\units
:if %2==Full goto PasToInt

if %3==C1 %4dcc32.exe %5 -b -JPHN>_Compiling.txt
if %3==C3 %4make.exe -f%5 >_Compiling.txt
if %3==C4 %4make.exe -f%5 >_Compiling.txt
if %3==C5 goto build_C5  
if %3==C6 goto build_C6  
if %3==D2 %4dcc32.exe %5 -b >_Compiling.txt
if %3==D3 %4dcc32.exe %5 -b >_Compiling.txt
if %3==D4 %4dcc32.exe %5 -b >_Compiling.txt
if %3==D5 %4dcc32.exe %5 -b >_Compiling.txt
if %3==D6 %4dcc32.exe %5 -b >_Compiling.txt
if %3==D7 %4dcc32.exe %5 -b >_Compiling.txt
if %3==D9 %4dcc32.exe %5 -b >_Compiling.txt
goto PasToInt

:** Build C5 **
:build_C5
%4bpr2mak.exe %5 -oC5.mak 
%4make.exe -fC5.mak >_Compiling.txt
goto PasToInt

:** Build C6 **
:build_C6
%4bpr2mak.exe %5 -oC6.mak 
%4make.exe -fC6.mak >_Compiling.txt
goto PasToInt

:******************************************************************************
:** Make *.int files 
:******************************************************************************
:PasToInt
cd ..\
PasToInt.exe /r
cd ..\

:******************************************************************************
:** Copy all needed distributive files (Data dir) 
:******************************************************************************
MD %2\Data
copy _DstList\%2\common.lst + _DstList\%2\%3.lst  _List.lst
Copier.exe _List.lst %3 %2\Data

:******************************************************************************
:** Copy all needed installator files (PreSetup dir and Setup.gin file)  
:******************************************************************************
MD %2\PreSetup
Copy _Gins\Gins.* %2\PreSetup\*.*
Copy ..\..\Docs\License.txt %2\PreSetup\*.*
Copy ..\..\Docs\ReadMe.txt %2\PreSetup\ReadMe.*
Copy _Gins\Setup.gin %2\*.*

:******************************************************************************
:** Prepare some info files 
:******************************************************************************
:Copy %2\PreSetup\ReadMe.txt %2\Data\ReadMe.txt
:Copy %2\PreSetup\License.txt %2\Data\License.txt
Copy ..\..\Docs\ABF.url %2\Data\*.*
if %3==C1 goto Attrib
if %3==D2 goto Attrib
Copy ..\Delpher.exe %2\Data\*.*
Copy ..\%1.cfg %2\Data\*.*

:******************************************************************************
:** Set file attributes to destibutive files
:******************************************************************************
Attrib %2\*.* -R -S -H /S

:******************************************************************************
:** Set date and time stamp to destibutive files
:******************************************************************************
FileDate.exe %2\*.* %6 %7 /r

:******************************************************************************
:** Create destibutive exe file
:******************************************************************************
CD %2
"..\..\..\..\Gins\Build162\Build.exe" Setup.gin
Copy Setup.exe %1_%2_%3.*
FileDate.exe %1_%2_%3.* %6 %7 
CD ..\

:******************************************************************************
:** Delete temp files and dirs 
:******************************************************************************
RD /Q /S %3
RD /Q /S %2\Data 
RD /Q /S %2\PreSetup 
del %2\Setup.*
del _List.lst
