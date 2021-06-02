# Desktop-automation
Simple batch scripts to queue computations on a desktop PC.

Numerical simulations use so-called meshes in order to obtain results. On average PC mesh creation takes about 2 hours of work time. This script was made to allow queuing mesh generation e.g. through the night. 

CFD software used with this script is ANSYS Fluent.

Script was made to be used by people not familiar with batch scripts or programming as a whole. Simplicity was the main concern while creating these scripts. After one time setup user only needs to change one line in text editor. 

Script was used by a team of almost 10 people saving them considerable amount of time.

Created 05.2020

## Setup
Files *Mesh_S.jou* and *Mesh_V.jou* are instructions for ANSYS Fluent. In those files 2 lines require attention:
```
/file/read-mesh "directory\@.msh"
/file/write-mesh "directory\@.msh"
```
User needs to specify directory from which input files will be read and directory to which output files will be saved.

*@* symbol is the file name, it is changed using batch scripts.

In files *Mesh_S.bat* and *Mesh_V.bat* user needs to specify directory in which ANSYS Fluent is installed:
```
"C:\Program Files\ANSYS Inc\v194\fluent\ntbin\win64\fluent.exe" -r19.4.0 -shortcut 3d -g -tm10 -t10 -meshing -wait -i %%a.jou > %%a.txt
```
Additionally in line above number of mesher processes can be specified:
```
-tm -t
```
All generated meshes were kept in one directory in cloud storage. Thanks to this above steps needed to be made only once for each user.

## Running
All the user has to do is specify input file names (excluding extensions) in line:
```
set list=
```
After saving changes script a be run by double-clicking on its icon. 

Terminal prompts which mesh is currently being generated. During calculations output files are generated in real time allowing user to spot possible errors.
