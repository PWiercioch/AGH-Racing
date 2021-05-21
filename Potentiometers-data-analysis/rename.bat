@echo off

set "new_time=550"

set "old_time=20200917_125501638808"

ren "%old_time%_F_HEAVE_DAMP.txt" "fh_%new_time%.txt"

ren "%old_time%_R_HEAVE_DAMP.txt" "rh_%new_time%.txt"

ren "%old_time%_F_ROLL_DAMP.txt" "fr_%new_time%.txt"

ren "%old_time%_R_ROLL_DAMP.txt" "rr_%new_time%.txt"

ren "%old_time%_TEL_BAMOCAR_RPM.txt" "rpm_%new_time%.txt"

pause