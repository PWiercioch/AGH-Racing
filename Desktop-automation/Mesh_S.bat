@echo off
:: allows use of variables in for loop - changes variable value to current case name
setlocal enabledelayedexpansion
:: select cases to run
set list=C_U_48 C_U_66 C_U_68 C_U_71 C_U_72

:: implementation of search and replace, change @ to case name in generic script file
for %%a in (%list%) do ( 

	for /f "delims=" %%b in (Mesh_S.jou) DO ( 

		set TEXT=%%b

		set "TEXT=!TEXT:@=%%a!"

		echo !TEXT! >> %%a.jou
	)
	
	echo Meshing %%a
	
	:: run calculations
	"C:\Program Files\ANSYS Inc\v194\fluent\ntbin\win64\fluent.exe" -r19.4.0 -shortcut 3d -g -tm10 -t10 -meshing -wait -i %%a.jou > %%a.txt

	:: delete temp file
	del %%a.jou

)

echo done

pause