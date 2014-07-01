#!/bin/bash

#######################################################
### Created by khan on Sun Jun 12 14:53:18 CDT 2011 ###
#######################################################

###################### Help Text ######################
# Usage: es <pFile>
#######################################################

## Initialize
pFile=
sPrefix=
bVi=false
sArgs=`echo $@ | sed 's/\<-[^ ]*\>//g'`

if ParseOpt vi $@ >/dev/null; then
	sEditor="vi"
	bVi=true
elif isMac; then
	sEditor="open -a Xcode"
else
	sEditor="gedit"
fi

## Functions
function EditVi()
{
	$sPrefix BeautifyBash "$pFile"
	source cdm "$pFile"
	find `pwd` -maxdepth 1 -name `fileparts 6 $pFile` -exec vim {} +
	$sPrefix BeautifyBash "$pFile"
}

function EditFile()
{
	$sPrefix BeautifyBash "$pFile"
	$sPrefix $sEditor "$pFile" 2>/dev/null
	$sPrefix BeautifyBash "$pFile"
}

## Main
for sFile in "$@"; do
	pFile=`fex "$sFile"`
	cat $pFile > /tmp/LastScript
	
	if [ ! -e "$pFile" ]; then
		escript "$pFile"
	elif [ -d "$pFile" ]; then
		exit 1
	fi
		if [ ! -w "$pFile" ]; then
			echo "File is write-protected. Override with sudo:"
			sudo -v
			sPrefix="sudo"
		fi
		
		if $bVi; then
			EditVi
		else
			EditFile 2>/dev/null &
		fi
done
