#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: build.sh
#
# Purpose: This docker script builds an application Image. The keyword build uses the Dockerfile stored in the current
#			directory, i.e. $ ./Dockerfile . The keyword image corresponds to the application image name that is used
#			to instantiate containers using the .run.sh or .runEdge.sh scripts. 
#
#########################################################################################################################
docker build -t bothcloudaeneas .
