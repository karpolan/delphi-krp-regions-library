:*******************************************************************************
:** Makes distributive 
:**   %1 - name of the destributive product (abfXXX).
:**   %2 - date stamp distributive files should have.
:**   %3 - time stamp distributive files should have.
:*******************************************************************************

RD /Q /S Data 


:******************************************************************************
:** Create the source and distributive folders  
:******************************************************************************
MD Data

:******************************************************************************
:** Copy all needed files  
:******************************************************************************
MD Data\Data
copy _List\Default.lst _List.lst
Copier.exe _List.lst ..\..\ Data\Data

:******************************************************************************
:** Copy all needed installator files (PreSetup dir and Setup.gin file)  
:******************************************************************************
MD Data\PreSetup
xCopy _Gins\Gins.* Data\PreSetup\*.*
xCopy _Gins\Setup.gin Data\*.*

copy Data\Data\ReadMe.txt Data\PreSetup\*.*
del  Data\Data\ReadMe.txt

copy Data\Data\License.txt Data\PreSetup\*.*
del  Data\Data\License.txt


:******************************************************************************
:** Set file attributes to destibutive files
:******************************************************************************
Attrib Data\*.* -R -S -H /S

:******************************************************************************
:** Set date and time stamp to destibutive files
:******************************************************************************
FileDate.exe Data\*.* %2 %3 /r

:******************************************************************************
:** Create destibutive exe file
:******************************************************************************
CD Data
"..\..\..\..\Gins\Build\Build.exe" Setup.gin
xCopy Setup.exe %1.*
FileDate.exe %1.* %2 %3 
CD ..\

:******************************************************************************
:** Delete temp files and dirs 
:******************************************************************************
RD /Q /S Data\Data 
RD /Q /S Data\PreSetup 
del Data\Setup.*
del _List.lst
