:*******************************************************************************
:** MakeAll.bat has follow parameters:
:**   %1 - name of the distributive (abfXXX).
:**   %2 - name of folder where distributive will be created (Full, Trial).
:**   %3 - date stamp distributive files should have (MM/DD/YY).
:**   %4 - time stamp distributive files should have (HH-MM-SS).
:*******************************************************************************
:call _Bat\MakeAll.bat krpRegions Trial %1 %2
:call _Bat\MakeAll.bat krpRegions WOS   %1 %2
call _Bat\MakeAll.bat krpRegions Full  %1 %2

