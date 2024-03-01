:**********************************************************
: %1 - Base file name, abfComponents for example
: %2 - $Ver$ value
: %3 - $VerS$ value
: %4 - $VerC$ value
:**********************************************************

:==========================================================
: Delete old files
:==========================================================
attrib %1_*.res -R
del %1_*.res 
attrib %1_X.rc -R
del %1_X.rc 

:==========================================================
: Create new *.rc file
:==========================================================
copy %1_X._rc %1_X.rc
Replacer %1_X.rc $Ver$  %2 
Replacer %1_X.rc $VerS$ %3 
Replacer %1_X.rc $VerC$ %4 

:==========================================================
: Create new *.res file and save it under different names
:==========================================================
brcc32 %1_X.rc
copy %1_X.res %1_D3.res
copy %1_X.res %1_D4.res
copy %1_X.res %1_D5.res
copy %1_X.res %1_D6.res
copy %1_X.res %1_D7.res
copy %1_X.res %1_D9.res

copy %1_X.res %1_C3.res
copy %1_X.res %1_C4.res
copy %1_X.res %1_C5.res
copy %1_X.res %1_C6.res

:==========================================================
: Delete temp files
:==========================================================
del %1_X.rc 
del %1_X.res

:==========================================================
: Set ReadOnly attributes
:==========================================================
:attrib %1_*.res +R
