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

ENV TZ=Europe/London
ARG DEBIAN_FRONTEND=noninteractive


RUN \
        apt-get update && apt-get install -y \
        autoconf \
        build-essential \
        libtool \
        bc \
        automake \
        avahi-daemon \
        cmake \
        g++ \
        make \
        sqlite3 \
        libsqlite3-dev \
        libboost-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libpq-dev \
        libssl-dev \
        uuid-dev \
        python-dev \
        python3-pip \
        python-pip \
        python-dbus \
        curl \
        postgresql \
        bluez \
        jq \
        libz-dev \
        inetutils-ping \
        git

RUN \
        pip install boto3

RUN \
	git init && \
	git remote add -f origin https://github.com/qub-blesson/DeFog.git && \
	git config core.sparsecheckout true && \
	echo Scripts >> .git/info/sparse-checkout && \
	git pull https://github.com/qub-blesson/DeFog.git master		

RUN \
        git clone https://github.com/foglamp/FogLAMP.git

RUN \
        cd FogLAMP && \
        pwd && \
        make && \
        export FOGLAMP_ROOT=/root/FogLAMP && \
		cp ~/Scripts/* .

# defaults command
CMD ["scripts/execute.sh"]