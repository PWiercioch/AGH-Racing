export ANSYSLI_SERVERS=2325@addres

export ANSYSLMD_LICENSE_FILE=1055@addres

scontrol show hostnames $SLURM_NODELIST > /net/scratch/people/$USER/hosts.list

module load test/ansys/2019R3
