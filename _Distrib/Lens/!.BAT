:*******************************************************************************
:** Calls MakeIt.bat file to create distributive. 
:** MakeIt.bat has follow parameters:
:**   %1 - name of the distributive (abfXXX).
:**   %2 - date stamp distributive files should have (MM/DD/YY).
:**   %3 - time stamp distributive files should have (HH-MM-SS).
:*******************************************************************************
call _Bat\MakeIt.bat LensInstall %1 %2
