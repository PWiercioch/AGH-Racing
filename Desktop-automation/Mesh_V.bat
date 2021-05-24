@echo off
:: allows use of variables in for loop - changes variable value to current case name
setlocal enabledelayedexpansion
:: select cases to run
set list=C_S_102 C_S_103 C_S_104 C_S_105 C_S_106 C_S_107 C_S_108

:: implementation of search and replace, change @ to case name in generic script file
for %%a in (%list%) do (

	for /f "delims=" %%b in (Mesh_V.jou) DO ( 

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