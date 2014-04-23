#!/bin/bash
#set -x

if [ "$#" -lt 4 ]; then
    echo "requires taskgen.py"
    echo "usage: $0 NUM_CPUS NUM_TASKSETS PCPU_MAX_TASKS SETS_DIR"
    echo 
    exit 0
fi


PROGS_DIR=./

NUM_CPUS=$1
TASK_SETS=$2
MIN_TASKS=$(($NUM_CPUS*2))
MAX_TASKS=$(($NUM_CPUS*$3))
BASE_PATH=$4
GEN="${PROGS_DIR}taskgen.py"

PERIOD_MIN=10000
PERIOD_MAX=100000
GRAN=1000
U="0.7 0.8 0.9"

rm ?TS* 2> /dev/null
rm -rf ${BASE_PATH} 2> /dev/null
mkdir -p ${BASE_PATH}

printf "generating task sets...\n"
for i in `seq $MIN_TASKS $NUM_CPUS $MAX_TASKS`;do
	for j in $U;do
		printf "${i}tsk_$j "
		DEST_DIR=${BASE_PATH}/${i}tsk/${j}
		GLOB_UTIL=`echo ${j}*${NUM_CPUS} | bc`
		printf "${GLOB_UTIL}\t"
		mkdir -p ${DEST_DIR}
		${GEN} -p ${PERIOD_MIN} -q ${PERIOD_MAX} -g ${GRAN} -u ${GLOB_UTIL} -n ${i} -s ${TASK_SETS}
		mv ?TS* ${DEST_DIR}
	done
	printf "\n"
done
printf "\n"

# vim: set ts=4 expandtab:
