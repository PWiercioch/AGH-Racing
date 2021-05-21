@echo off

set "new_time=441"

sed -i -e s/:/0/g fh_%new_time%.txt

sed -i -e s/:/0/g rh_%new_time%.txt

sed -i -e s/:/0/g fr_%new_time%.txt

sed -i -e s/:/0/g rr_%new_time%.txt

sed -i -e s/:/0/g rpm_%new_time%.txt

sed -i -e s/,/./g fh_%new_time%.txt

sed -i -e s/,/./g rh_%new_time%.txt

sed -i -e s/,/./g fr_%new_time%.txt

sed -i -e s/,/./g rr_%new_time%.txt

sed -i -e s/,/./g rpm_%new_time%.txt

del sed*

pause