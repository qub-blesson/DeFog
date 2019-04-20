#!/bin/sh

#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: execute.sh
#
# Purpose: This script is passed into the Dockerfile during the build process initialised by the build.sh script.
#			This component automously runs the ./runCloud.sh script.
#
#########################################################################################################################

cd ~/iPokeMon/ipokemon/Application/iPokeMon-CloudServer/

echo "Starting CloudServer..."
	chmod 777 runCloud.sh
	. ./runCloud.sh	
echo "Done"
