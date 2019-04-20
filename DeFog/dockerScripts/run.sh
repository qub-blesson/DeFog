#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: run.sh
#
# Purpose: This script invokes a docker exec/run command. Volumes are mounted to allow access to external folders:
#			configuration folder, assets, results and aws credentials. The image keyword binds the image name to the
#			current run process. This process is run in non-interactive mode (detached), allowing for automation of 
#			the execute.sh. When finished with the current process, the container will be exit. The execute.sh script
#			is passed in as a CMD asset script.
#
#########################################################################################################################
docker run --rm -v /home/ubuntu/defog/configs:/mnt/configs -v /home/ubuntu/defog/assets:/mnt/assets -v /home/ubuntu/defog/results:/mnt/results -v /root/.aws:/root/.aws --name image image ../scripts/execute.sh
