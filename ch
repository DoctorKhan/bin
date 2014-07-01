#!/bin/bash

#######################################################
### Created by khan on Sat Jun 25 14:27:50 CDT 2011 ###
#######################################################

###################### Help Text ######################
# Usage: ch
#######################################################
if isHelp 0 $0 "$@"; then exit 0; fi

while read file; do
	case $1 in
		ext)
			sNewExt="`echo $2 | tr -d '.'`"
			echo $file | sed "s/\.[^\.]*$/.$sNewExt/"
		;;
	esac
done
