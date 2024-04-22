#!/bin/bash
#
#SBATCH --output=/global/scratch/projects/fc_moilab/meixilin/slurmlogs/%j.out.txt
#SBATCH --error=/global/scratch/projects/fc_moilab/meixilin/slurmlogs/%j.err.txt
#SBATCH --account=fc_moilab
#SBATCH --partition=savio3_htc
#SBATCH --time=23:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G

set -eo pipefail

HOMEDIR="/global/scratch/projects/fc_moilab/meixilin/pi_extinct"
COMMITID=$(git --git-dir="${HOMEDIR}/.git" --work-tree="${HOMEDIR}/" rev-parse master)

RSCRIPT="${HOMEDIR}/scripts/MAR_extinction.R"
SPECIES=${1}

cd ${HOMEDIR}
LOG="data/extinctionsim/logs/MAR_extinction_${SPECIES}.log"

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}; GIT commit id ${COMMITID}; Running MAR_extinction.R ${SPECIES}..."
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}; GIT commit id ${COMMITID}; Running MAR_extinction.R ${SPECIES}..." > ${LOG}

Rscript --vanilla ${RSCRIPT} ${SPECIES} &>> ${LOG}

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID} Done"
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID} Done" >> ${LOG}
