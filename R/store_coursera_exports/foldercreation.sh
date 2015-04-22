#!/bin/sh
#
# Workflow: Sets up the folder directory for projects
# Adapted from: <author> "Data-driven security" & <author> "Doing Data Science"
#
# usage: sh workflow.sh DIRNAME
#
# Written by: Jasper Ginn
# Date: 17-03-2015

if [ "$#" == "0" ]; then
    echo "ERROR: Please specify a directory name"
    echo 
    echo "USAGE: prep DIRNAME"
    exit
fi
   
DIR=$1

if [ ! -d "${DIR}" ]; then
    # Add directories for the first stage
    mkdir ${DIR}
    mkdir ${DIR}/stage1/
    mkdir ${DIR}/stage1/Gradebook
    mkdir ${DIR}/stage1/User_ID         
    # Add directories for the second stage
    mkdir ${DIR}/stage2/
    mkdir ${DIR}/stage2/Peer_Review
    mkdir ${DIR}/stage2/Weekly_Quizzes 
    mkdir ${DIR}/stage2/Final_Exam
    mkdir ${DIR}/stage2/Summary_Stats
    mkdir ${DIR}/stage2/Surveys
    mkdir ${DIR}/stage2/Video_Quizzes  
    ls -lR ${DIR}
else
    echo "Directory "${DIR}" already exists"
fi

