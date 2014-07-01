#!/bin/bash

#######################################################
### Created by khan on Mon Mar 12 14:39:18 CDT 2012 ###
#######################################################

###################### Help Text ######################
# Usage: ml

#######################################################
if (( $# < 0 )) || [[ "$1" == --help ]]; then echo
sed -n "/^# Usa/,/^##*$/p" $0 | tr -d "#"; exit 0; fi
#######################################################

## Initialize

## Functions

## Main
if isExt raw $1; then
	pObj=`raw2obj $1`
	vglrun meshlab $pObj &
	obj2raw $pObj
	rm $pObj
else
	vglrun meshlab $1 &
fi

