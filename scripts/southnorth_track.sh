#!/bin/bash
#
#SBATCH --output=/global/scratch/projects/fc_moilab/meixilin/slurmlogs/%A_%a.out.txt
#SBATCH --error=/global/scratch/projects/fc_moilab/meixilin/slurmlogs/%A_%a.err.txt
#SBATCH --account=fc_moilab
#SBATCH --partition=savio3_htc
#SBATCH --time=47:59:00
#SBATCH --ntasks=1
#SBATCH --array=1-20
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G

set -eo pipefail

HOMEDIR="/global/scratch/projects/fc_moilab/meixilin/pi_extinct"
COMMITID=$(git --git-dir="${HOMEDIR}/.git" --work-tree="${HOMEDIR}/" rev-parse master)

# get the commit id for mar too
MARDIR="/global/scratch/projects/fc_moilab/meixilin/mar"
MARCOMMITID=$(git --git-dir="${MARDIR}/.git" --work-tree="${MARDIR}/" rev-parse master)

RSCRIPT="${HOMEDIR}/scripts/southnorth_track.R"
SPECIES=${1}
REPID=${SLURM_ARRAY_TASK_ID}

cd ${HOMEDIR}
LOG="data/southnorth_track/logs/southnorth_track_${SPECIES}_${REPID}.log"

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}_${REPID}; GIT commit id ${COMMITID}; MAR commit id ${MARCOMMITID}; Running southnorth_track.R ${SPECIES} ${REPID}..."
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}_${REPID}; GIT commit id ${COMMITID}; MAR commit id ${MARCOMMITID}; Running southnorth_track.R ${SPECIES} ${REPID}..." > ${LOG}

Rscript --vanilla ${RSCRIPT} ${SPECIES} ${REPID} &>> ${LOG}

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}_${REPID} Done"
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${SLURM_JOBID}_${REPID} Done" >> ${LOG}
