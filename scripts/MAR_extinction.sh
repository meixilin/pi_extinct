#!/bin/bash
#
#SBATCH --output=/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/logs/run_extinction_20221201.out.txt
#SBATCH --error=/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/logs/run_extinction_20221201.out.txt
#SBATCH --time=23:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G

set -eo pipefail

HOMEDIR="/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/"
COMMITID=$(git --git-dir="${HOMEDIR}/.git" --work-tree="${HOMEDIR}/" rev-parse master)

RSCRIPT="${HOMEDIR}/MAR_extinction.R"
SPECIES=${1}

cd ${HOMEDIR}

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}; GIT commit id ${COMMITID}; Running MAR_extinction.R ${SPECIES}..."

Rscript --vanilla ${RSCRIPT} ${SPECIES} &> "logs/MAR_extinction_${SPECIES}.log"

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID} Done"

