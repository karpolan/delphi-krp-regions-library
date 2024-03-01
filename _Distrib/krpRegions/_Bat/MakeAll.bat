:*******************************************************************************
:** Makes distributive for all versions of Delphi or C++Builder
:**   %1 - name of destributive (abfXXX).
:**   %2 - name of folder where distributive will becreated.
:**   %3 - date stamp distributive files should have.
:**   %4 - time stamp distributive files should have.
:*******************************************************************************
RD /Q /S %2

:******************************************************************************
:** Make distributives 
:******************************************************************************
if %2==Full goto Full

:call _Bat\Make.bat %1 %2 D2 C:\Borland\Delphi2\bin\ %1Reg.pas %3 %4 
call _Bat\Make.bat %1 %2 D3 C:\Borland\Delphi3\bin\ %1_D3.dpk %3 %4 
call _Bat\Make.bat %1 %2 D4 C:\Borland\Delphi4\bin\ %1_D4.dpk %3 %4 
call _Bat\Make.bat %1 %2 D5 C:\Borland\Delphi5\bin\ %1_D5.dpk %3 %4 
call _Bat\Make.bat %1 %2 D6 C:\Borland\Delphi6\bin\ %1_D6.dpk %3 %4 
call _Bat\Make.bat %1 %2 D7 C:\Borland\Delphi7\bin\ %1_D7.dpk %3 %4 
call _Bat\Make.bat %1 %2 D9 C:\Borland\BDS\3.0\bin\ %1_D9.dpk %3 %4 

:call _Bat\Make.bat %1 %2 C1 C:\Borland\CBuilder1\bin\ %1Reg.pas %3 %4  
call _Bat\Make.bat %1 %2 C3 C:\Borland\CBuilder3\bin\ %1_C3.bpk %3 %4  
call _Bat\Make.bat %1 %2 C4 C:\Borland\CBuilder4\bin\ %1_C4.bpk %3 %4  
call _Bat\Make.bat %1 %2 C5 C:\Borland\CBuilder5\bin\ %1_C5.bpk %3 %4  
call _Bat\Make.bat %1 %2 C6 C:\Borland\CBuilder6\bin\ %1_C6.bpk %3 %4  

goto End

:Full
call _Bat\Make.bat %1 %2 X X X %3 %4  
copy %2\%1_%2_X.exe %2\%1_%2.exe
del  %2\%1_%2_X.exe

:End

                                                                           