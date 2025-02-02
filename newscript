#!/bin/bash

#######################################################
### Created by khan on Sat Jul 16 13:38:20 CDT 2011 ###
#######################################################

###################### Help Text ######################
# Create a script sFile in dir.
# Usage: escript <sFile> [dir]
#######################################################
if (( $# < 1 )) || [[ "$1" == -*h* ]]; then echo
	grep -A 99999 "# Help.*#*" $0 |\
	grep -E -m 2 -B 99999 "#{10,}"
echo; exit 0; fi
#######################################################

## Initialize
sFile="$1"
pFile="${2:-$HOME/bin}/$sFile"

## Validation
if [ -f "$pFile" ] || isInstalled "$pFile" ; then
	echo "$sFile already exists."
	exit 1
fi

## Functions
function CompleteText()
{
	HelpText "$pFile"
	echo -e "## Initialize\\n\\n## Functions\\n\\n## Main\\n"
}

## Main
CompleteText >> "$pFile"
chmod u+x "$pFile"
es "$sFile"
