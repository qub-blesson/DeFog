#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: Dockerfile
#
# Purpose: This Dockerfile determines the linux server (ubuntu:18.04) and declarse the execute.sh script as a CMD Compose,
#			file - instantiating an entrypoint for the script using the /scripts folder. The relevant dependencies are installed
#			and the ubuntu service is updated etc. Wget and git are installed to allow for repository management and pulling
#			the relevant urls. Boto3 is installed to allow for integration with an S3 instance. The git repository is initialised,
#			added and configured to pull only the relevant application sub folder. This allows a specific version of the application
#			to be pulled and built consistently. Depending on the applications bespoke requirements the debian environment arguement
#			is set to remove interactivity during the build the process, this is to ensure automated deployment.
#
#########################################################################################################################

FROM ubuntu:18.04
COPY execute.sh scripts/execute.sh

WORKDIR /root

RUN \
	apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	libtool \
	git

RUN \
	apt-get install -y \
	wget 

RUN \
	git init && \
	git remote add -f origin https://github.com/qub-blesson/DeFog.git && \
	git config core.sparsecheckout true && \
	echo Aeneas/bothcloudaeneas/ >> .git/info/sparse-checkout && \
	git pull https://github.com/qub-blesson/DeFog.git master
	
# defaults command
CMD ["scripts/execute.sh"]
