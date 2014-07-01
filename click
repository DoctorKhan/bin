#!/bin/bash
if [ "$1" == "right" ]; then
	button=3
	shift
else
	button=1
fi

if [ $# == 0 ]; then
	xdotool click $button
	echo "Clicking mouse button at `xdotool getmouselocation | tr ':' '=' | tr ' ' ','`"
else
	moveMouse $@
	xdotool click $button
fi
