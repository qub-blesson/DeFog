#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: enter.sh
#
# Purpose: This script invokes a docker exec/run command. Volumes are mounted to allow access to external folders:
#			configuration folder, assets, results and aws credentials. The image keyword binds the image name to the
#			current run process. This process is run in interactive mode, allowing manual interaction with the 
#			terminal. When finished with the current process, the container will be exited. The net host set allows access
#			from the external network into the docker container.
#
#########################################################################################################################
docker run --net=host -it -v /root/.aws:/root/.aws --name ipokemon ipokemon bash

