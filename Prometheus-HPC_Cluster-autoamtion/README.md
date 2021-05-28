# Prometheus-HPC_Cluster-automation

This reporsitory contains script used to automate the computation process of numerical simulations. 

CFD simulations require large computational resources. Not mamy PCs have the ability to simulate air flowing over a race car. In our case one simulation required over 100 GB of RAM and lasted about 6 hours on 48 processes. Such somputations were made on a HPC Cluster Prometheus a part of PL-Grid infrastructure. Last season we were able to complete over 600 simulations which is equal of 150 hours of non stop computing. 

Initially we used grafic mode to handle all of the necessary tasks. It had some advantages but many more issues:
* we do not have a on demand and unlimited acces to a cluster. We couldn't afford to waste computation time given to us, which often lead to setting up new simulations at 3 or 4 AM.
* Simulations must have been constantly watched over: if an error occured simulation stopped and precious computation time was running out.
* Setting up a simulation required some experience and couldn't be done by anyone in the team.
* After finished simulations output data was manually pasted to our database.

A lot of time was wasted to repetitive tasks. Also burden of keeping all the simulations running was placed on only one person.

The aim of scripts contained in this repository was to autamte the repetitive tasks which would save much time but also make computational process simple enough that every team member could run simulations by him or herself. Most of the team members being mechanical engineers a little or none programming or linux knowledge was assumed. Secondary goal was to make scripts easy to modify for following simulations after initiall setup.

## Table of contents
- [Workflow](#workflow)
- [Fluent scripts](#fluent-scripts)
- [Convergence evaluation](#convergence-evaluation)
- [Report generator](#report-generator)
- [Scripts setup and use](#script-setup-and-use)

## Workflow
Prometheus uses workload manager Slurm. The main file in this repository therefore is ***symu.slurm***.

It begins with setting up jobs parameters: number of computational nodes and processes, ammount of maximal running time and users email addres to which notifications would be sent.

The remaining of the scripts are linux commands to perform basic file operations and run calculations. 

Outline of subsequent operations:
* modify generic scripts for specific simualtion using sed command.
* run calculations on ANSYS Fluent (99% of the computation time happens here)
* perform simple file operations to make Fluent otput files compatible with matlab scripts
* process output data in Matlab - create plots and compute metrics helpfull in judging solvers convergence
* organize files - delete temp scripts and move plots to specific directory
* prepare input data and scripts using sed command
* run report generator written in Matlab
* organize files

## Fluent scripts

## Convergence evaluation

## Report generator

## Scripts setup and use
