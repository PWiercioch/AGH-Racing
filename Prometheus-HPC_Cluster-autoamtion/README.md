# Prometheus-HPC_Cluster-automation

This repository contains script used to automate the computation process of numerical simulations. 

CFD simulations require large computational resources. Not many PCs have the ability to simulate air flowing over a race car. In our case one simulation required over 100 GB of RAM and lasted about 6 hours on 48 processes. Such computations were made on a HPC Cluster Prometheus a part of PL-Grid infrastructure. Last season we were able to complete over 600 simulations which is equal of 150 days of non-stop computing. 

Initially we used graphic mode to handle all the necessary tasks. It had some advantages but many more issues:
* we do not have a on demand and unlimited access to a cluster. We couldn't afford to waste computation time given to us, which often lead to setting up new simulations at 3 or 4 AM.
* Simulations must have been constantly watched over: if an error occurred simulation stopped and precious computation time was running out.
* Setting up a simulation required some experience and couldn't be done by anyone in the team.
* After finished simulations output data was manually pasted to our database.

A lot of time was wasted to repetitive tasks. Also burden of keeping all the simulations running was placed on only one person.

The aim of scripts contained in this repository was to automate the repetitive tasks which would save much time but also make computational process simple enough that every team member could run simulations by him or herself. Most of the team members being mechanical engineers a little or none programming or Linux knowledge was assumed. Secondary goal was to make scripts easy to modify for following simulations after initial setup.

## Table of contents
- [Workflow](#workflow)
- [Fluent script](#fluent-script)
- [Convergence evaluation](#convergence-evaluation)
- [Report generator](#report-generator)
- [Scripts setup and use](#scripts-setup-and-use)

## Workflow
Prometheus uses workload manager Slurm. The main file in this repository therefore is ***symu.slurm***.

It begins with setting up jobs parameters: number of computational nodes and processes, amount of maximal running time and users email address to which notifications would be sent.

The remaining of the scripts are Linux commands to perform basic file operations and run calculations. 

Outline of subsequent operations:
* modify generic scripts for specific simulation using ***sed*** command.
* run calculations on ANSYS Fluent (99% of the computation time happens here)
* perform simple file operations to make Fluent output files compatible with Matlab scripts
* process output data in Matlab - create plots and compute metrics helpful in judging solvers convergence
* organize files - delete temp scripts and move plots to specific directory
* prepare input data and scripts using ***sed*** command
* run report generator written in Matlab
* organize files

## Fluent script
Files with extensions ***.jou*** are ANSYS Fluent journals, they are a set of direct instructions to solver. Most of the simulations are set identically. To automate this process a single generic ***.case*** file was prepared. It contains information about boundary conditions, solver settings and which results to be saved in output files. To analyse geometry change to aerodynamic package one must simply replace computational mesh (a geometric model made of millions of cells: tetrahedrons, hexahedrons and polyhedrons). 

```
/file/read-case /net/archive/groups/plggfsracing/CASE_NEW.cas
/file/replace-mesh "plgscratch/@V.msh.gz" ok
```
Above lines read generic ***.case*** file and replace the mesh. In a ***.slurm*** script ***plgscratch*** is replaced to specific user work directory and ***@*** is replaced with mesh name. Both replacements are done using the sed command. In our workflow mesh names ended with letter ***V*** for ***volumetric*** and default extension  was compressed ***.msh.gz***.

```
/solve/report-files/edit c_x_y file-name "plgscratch/Out/@.out" name "@" quit
/solve/report-files/edit c_x_y_components file-name "plgscratch/Out/@_components.out" name "@_components" quit
/file/auto-save/root-name "plgscratch/@"
/solve/report-files/edit c_x_y_massflow file-name "plgscratch/Out/@_massflow.out" name "@_massflow" quit
```
Above lines specify directory and name for output files. They are modified accordingly to specific user similar to former ones. 

```
/file/export/ensight-gold "plgscratch/Cases/@/@" mean-pressure mean-x-velocity mean-y-velocity mean-z-velocity mean-x-wall-shear mean-y-wall-shear mean-z-wall-shear turb-kinetic-energy y-plus () yes * () () no
```
This command exports Ensight files - they can be used to post-processing (colorful images visualizing airflow around the race car).

<p align="center">
  <img src="https://user-images.githubusercontent.com/83305684/120082286-56f4bc00-c0c2-11eb-863b-0830d2ccfd89.png" width="400"/>
</p>
<p align="center">
  <em>Example of postprocessing</em>
</p>

## Convergence evaluation
Numerical solutions are iterative. A simulation can be assumed complete after a convergence criteria is met. One of them might be a relative change of chosen variable lower than a threshold. This convergence can be visualize on a plot: iterations vs computed value.

<p align="center">
  <img src="https://user-images.githubusercontent.com/83305684/120083120-e2704c00-c0c6-11eb-91d7-86887fd6315a.png" width="400"/> 
</p>
<p align="center">
  <em>Convergence plot of a cars overall downforce</em>
</p>

A converged simulation could be represented by a curve straightening by the end. Ideal situation would be a straight horizontal line representing no change of variable.

In graphical mode ANSYS Fluent creates such convergence plots itself. In case of batch mode it is impossible to export these plots. Matlab scripts *** *** and *** *** were made to parse output files and create plots for cars overall downforce as well as for every major car part.

<p align="center">
  <img src="https://user-images.githubusercontent.com/83305684/120083127-f0be6800-c0c6-11eb-92a4-41457b2a5dca.png" width="400"/> 
</p>
<p align="center">
  <em>Convergence plot of a third rear wing element</em>
</p>

Plots are useful in judging simulation convergence (if simulations have not converged additional iterations are required) but also in finding errors and anomalies in solution/mesh. In above example we can see a decent overall simulation convergence, but rear wing experienced some sudden value changes near the end of the simulation. This may indicate some bad quality cells in computational mesh, results near wing should be studied closely in near rear wing region.

Besides plots scripts also compute metrics helpful in judging convergence: mean, standard deviation and custom convergence metric: 
<p align="center">
<img src="http://www.sciweavers.org/tex2img.php?eq=%20%5Cfrac%7BStandard%20Deviation%7D%7BFinal%20Iteration%20Value%2A100%7D%20&bc=Black&fc=White&im=jpg&fs=12&ff=arev&edit=0" align="center" border="0" alt=" \frac{Standard Deviation}{Final Iteration Value*100} " width="160" height="30" />
</p>

## Report generator
Initially solution data was stored in an Excel sheet which had many downsides:
* data must have been manually pasted to spreadsheet
* it was easy to delete something by an accident
* data was really hard to read

<p align="center">
  <img src="https://user-images.githubusercontent.com/83305684/120084933-9e844380-c0d4-11eb-88aa-573d0aa2ad05.png" width="800"/> 
</p>
<p align="center">
  <em>Data kept in Excel</em>
</p>

To improve reporting process and data readability automatic report generator in Matlab was created. The script would run automatically after simulation has finished, reading output data and some additional input files from user to create a more complete report.

A sample report can be found in a repository: ***[sample_report_CU_21.pdf](https://github.com/PWiercioch/AGH-Racing/blob/763afaf1b6b86c9a94073e4f4ab6e4f245f181e2/Prometheus-HPC_Cluster-autoamtion/sample_report_C_U_21.pdf)***.

A report contains:
* table of contents allowing quick navigation
* forces summary for every major part of the car
* information about mass flow through different places around the car with simple visualization

Data in reports is organized much clearer and is easy to read. Report also contains a picture of simulated aerodynamic device along with quick description of simulation: what changes were made and they were meant to accomplish. 

## Scripts setup and use
Files ***data.txt*** and ****components.out**** are sample output data from ANSYS Fluent.
File ***sample_report_CU_21.pdf*** and directory ***sample_plots*** are sample reports generated by Matlab sripts.

Files ***fluent3.sh*** as well as generic ***.case*** file mentioned in [here](#fluent-script) are kept in a shared directory:
```
/net/archive/groups/plggfsracing
```
User needs to upload all the files frm repository into his working directory ***$SCRATCH*** except for ***symu.slurm*** which should be kept inside home directory ***$HOME***.

For every simulation user must upload a computational mesh into his working directory. A files with endings***_model.JPG*** and ***_tekst.txt*** files needs to be uploaded inside ***report_generator*** folder, they should contain description and picture for a report. File names should start with a simulation name and be the same as mesh names.

After all the files are uploaded few lines inside ***symu.slurm*** should be changed:
````
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
````
Specifies number of computational nodes and processors per node. Required RAM should be taken into consideration here - every processor has 5 GB of RAM. The more processors are selected the shorter simulation time will be. 2 nodes and 48 processors total are default for most of simulations.

```
#SBATCH --time=2-0
```
Specifies maximal runtime in format days-hours. Maximum possible runtime is 72 hours.

```
#SBATCH --mail-user=mail@mail.com
```
Specifies users e-mail to which notificatons would be sent.

```
declare -a cases=(case_1) # cases to run
```
Specify which meshes should be run.

After saving the changes the script can be run by:
```
$ sbatch symu.slurm
```

Job status can be seen by typing:
```
$ squeue
```

When the simulation is running user can view output files in real time - to check for progress and errors.
