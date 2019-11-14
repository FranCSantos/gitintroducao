#!/bin/bash
#script que apaga todos os arquivos de uma arvore de diretorios, mantendo a arvore
set -e
set -u

if [ $# -lt 1 ]; then
	echo "usage: defoliate.sh dir [dir..]"
	exit 1
fi

base=$(pwd)
while [ $# -ge 1 ]; do
	IFS=$'\n' candidates=(`ls -1 -R "$1"`)
	shift
	for c in ${candidates[@]}; do
		if [[ ! "$c" =~ ^.*:$ ]]; then
			if [ -f "$c" ]; then
				echo "removing:$PWD/$c"
				rm -f "$c"
			fi
		else
			cd $base
			cd "${c%:}"
		fi
	done
done

exit 0

