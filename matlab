#!/bin/bash

#######################################################
### Created by khan on Tue Sep 10 00:09:57 CDT 2013 ###
#######################################################

###################### Help Text ######################
# Usage: matlab

#######################################################
if (( $# < 0 )) || [[ "$1" == --help ]]; then echo
sed -n "/^# Usa/,/^##*$/p" $0 | tr -d "#"; exit 0; fi
#######################################################

## Initialize

## Functions

## Main
cd $HOME
if (($#==0)); then
	/usr/local/MATLAB/R2013a/bin/matlab -desktop
else
	/usr/local/MATLAB/R2013a/bin/matlab $@
fi
