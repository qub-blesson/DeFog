#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: remove.sh
#
# Purpose: This script stops all containers, removes all containers and then removes all images.
#
#########################################################################################################################
docker stop $(docker ps -aq) &&
docker rm $(docker ps -aq) &&
docker rmi $(docker images -q)
