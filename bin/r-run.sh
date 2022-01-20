#!/bin/bash

DKNAME=dsr-note
DKUSER=jovyan
DKHOME=/home/${DKUSER}
PWD=`pwd`
WD="${PWD}"
IMAGE=jnishii/r-notebook-plus

DKOPT="--rm \
	-e TZ=Asia/Tokyo \
	-h ${DKNAME} \
	--name ${DKNAME} \
	-v "${WD}":/${DKHOME} \
	-p 8888:8888" \

# docker run: 
# --hostname , -h : Container host name
# --detach, -d : Run container in background and print container ID
# -it  :  Allocate pseudo-TTY;  creating an interactive bash shell
# --name : Assign name
# --rm : Automatically remove the container when it exits
#
# https://docs.docker.com/engine/reference/commandline/run/#examples

Usage(){
	echo "dsr-run.sh [option]"
	echo "  -h    : show this usage"
	echo "  -bg   : start jupyter notebook in background mode"
	echo "  -fg (default) : start jupyter notebook in foreground mode"
}

runJupyterBG(){
	echo "running docker in background mode..."
	echo 
	echo "$ docker logs ${DKNAME}  # confirm docker token"
	echo "$ docker stop ${DKNAME}  # stop docker" 
	echo "$ docker start ${DKNAME} # start docker" 

	docker run -d ${DKOPT} ${IMAGE}
}

runJupyterFG(){
    echo "starting Jupyter ..."
    if [ -d "/Applications/Google\ Chrome.app" ]; then
        open -a /Applications/Google\ Chrome.app "http://127.0.0.1:8888/" 
    fi

	docker run -it ${DKOPT} ${IMAGE} \
		start-notebook.sh \
		--NotebookApp.token=${1}
}

PASS='opensesami'


case ${1} in
	-h)  Usage ;;
    -bg) runJupyterBG ;;
    *) runJupyterFG ${PASS};;
esac
