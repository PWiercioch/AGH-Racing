#!/usr/bin/env bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
#SBATCH --time=2-0
#SBATCH --mail-user=mail@mail.com
#SBATCH --mail-type=BEGIN,END,FAIL

declare -a cases=(case_1) # cases to run

counter=0

bash /net/archive/groups/plggfsracing/fluent3.sh # set up license

while (( $counter < ${#cases[@]} )) # iterate over all entries in cases
do
	cd $SCRATCH # enter working directory

	echo ${cases[counter]} # output current case name
  
  sed -i "s|plgscratch|$SCRATCH|g" base.jou	# change working directory in generic script

	sed "s/@/${cases[counter]}/g" base.jou > "${cases[counter]}.jou" # copy generic script modified for current case

	/net/software/local/ansys/v195/fluent/bin/fluent 3d -g -t 48 -cnf=hosts.list -rsh -mpi=intel -pinfiniband -i "${cases[counter]}.jou" > "${cases[counter]}.txt" # run calculations and create output .txt file

	rm "${cases[counter]}.jou" # delete script for current case

	cp "${cases[counter]}.txt" data.txt # create copy of output data with name compatible with matlab script

	echo Matlab ${cases[counter]} # prompt start of calculations with matlab

	srun -N 1 -n 1 /net/software/local/matlab/R2019b/bin/matlab < wykres_df.m > ${cases[counter]}_m.out # run first matlab script

	# organize files: delete temps, move and rename ouputs to directory with results
	mv "${cases[counter]}_m.out" $SCRATCH/Out

	mv plot.jpg "$SCRATCH/Out/${cases[counter]}plot.jpg"

	rm data.txt

	mkdir $SCRATCH/Out/plot
	
	cp "$SCRATCH/Out/${cases[counter]}_components.out" $SCRATCH/Out/plot/components.out

	cp $SCRATCH/components.m $SCRATCH/Out/plot
	
	cd $SCRATCH/Out/plot

	srun -N 1 -n 1 /net/software/local/matlab/R2019b/bin/matlab < components.m > ${cases[counter]}_m.out # run second matlab scripts

	rm components.out

	rm components.m

	mv $SCRATCH/Out/plot "$SCRATCH/Out/${cases[counter]}_plot"
 
	# start of report generation
  cd $SCRATCH/report_generator
  
  # copy simulation output files
  cp "$SCRATCH/Out/${cases[counter]}_components.out" .
  
  cp "$SCRATCH/Out/${cases[counter]}_massflow.out" .
  
  # prepare script for current case
  sed -i "s|directory|$SCRATCH|g" generuj.m

  sed "s/@/${cases[counter]}/g" generuj.m > "${cases[counter]}_generuj.m"

  sed "s/@/${cases[counter]}/g" raport.m > "${cases[counter]}.m"

  srun -N 1 -n 1 /net/software/local/matlab/R2019b/bin/matlab < ${cases[counter]}_generuj.m # run report generator
  
  # clean temp files, move report to shared folder, change acces 
  rm "${cases[counter]}_generuj.m" "${cases[counter]}.m" "${cases[counter]}_components.out" "${cases[counter]}_massflow.out"
  
  cp -r "$SCRATCH/Cases/${cases[counter]}" /net/archive/groups/plggfsracing/Cases
  
  chmod -R 770 "/net/archive/groups/plggfsracing/Cases/${cases[counter]}"
 
	((counter++))
done
