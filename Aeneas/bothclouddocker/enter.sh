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
#			terminal. When finished with the current process, the container will be exited.
#
#########################################################################################################################
docker run --rm -it -v /home/ubuntu/defog/configs:/mnt/configs -v /home/ubuntu/defog/assets:/mnt/assets -v /home/ubuntu/defog/results:/mnt/results -v /root/.aws:/root/.aws --name bothcloudaeneas bothcloudaeneas bash