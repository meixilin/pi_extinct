#!/bin/bash
#
#SBATCH --output=/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/logs/MAR_extinction.out.txt
#SBATCH --error=/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/logs/MAR_extinction.err.txt
#SBATCH --time=23:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G

set -eo pipefail

HOMEDIR="/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/pi_extinct/"
COMMITID=$(git --git-dir="${HOMEDIR}/.git" --work-tree="${HOMEDIR}/" rev-parse master)

# get the commit id for mar too
MARDIR="/Carnegie/DPB/Data/Shared/Labs/Moi/Everyone/meixilin/mar/"
MARCOMMITID=$(git --git-dir="${MARDIR}/.git" --work-tree="${MARDIR}/" rev-parse master)

RSCRIPT="${HOMEDIR}/scripts/MAR_extinction.R"
SPECIES=${1}

cd ${HOMEDIR}
LOG="logs/MAR_extinction_${SPECIES}.log"

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}; GIT commit id ${COMMITID}; MAR commit id ${MARCOMMITID}; Running MAR_extinction.R ${SPECIES}..."
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}; GIT commit id ${COMMITID}; MAR commit id ${MARCOMMITID}; Running MAR_extinction.R ${SPECIES}..." > ${LOG}
Rscript --vanilla ${RSCRIPT} ${SPECIES} &>> ${LOG}

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID} Done"
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID} Done" >> ${LOG}
