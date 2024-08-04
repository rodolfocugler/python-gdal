FROM ubuntu:24.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# update packages
# upgrade packages
RUN apt-get update && \
    apt-get -y upgrade

# set zoneinfo
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime
ARG DEBIAN_FRONTEND=noninteractive

# install zip
# install wget
# install curl
# install python
# install git
# install software-properties-common
RUN apt-get install -y \
    zip \
    wget \
    curl \
    python3-pip \
    git-all \
    software-properties-common

# update pip
RUN python3 -m pip install --upgrade pip --break-system-packages

# install gdal
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
    apt-get update && \
    apt-get -y upgrade

RUN apt-get install -y \
    python3-gdal \
    python3-numpy \
    gdal-bin \
    libgdal-dev

ENV GDAL_VERSION=3.9
RUN python3 -m pip install GDAL==$(gdal-config --version) --global-option=build_ext \
    --global-option="-L/Library/Frameworks/GDAL.framework/Versions/${GDAL_VERSION}/GDAL -I/Library/Frameworks/GDAL.framework/Versions/${GDAL_VERSION}/GDAL -lgdal" \
    --break-system-packages

# install orfeo toolbox
ENV ORFEO_TOOLBOX_VERSION=9.0.0
ENV ORFEO_TOOLBOX_PATH=/home/OTB-${ORFEO_TOOLBOX_VERSION}-Linux64

WORKDIR /home/
RUN curl -o "OTB-${ORFEO_TOOLBOX_VERSION}-Linux.tar.gz" "https://www.orfeo-toolbox.org/packages/archives/OTB/OTB-${ORFEO_TOOLBOX_VERSION}-Linux.tar.gz" && \
    chmod 777 OTB-${ORFEO_TOOLBOX_VERSION}-Linux.tar.gz && \
    tar xf OTB-${ORFEO_TOOLBOX_VERSION}-Linux.tar.gz --one-top-level=${ORFEO_TOOLBOX_PATH} && \
    chmod 777 -R OTB-9.0.0-Linux64/ && \
    source ${ORFEO_TOOLBOX_PATH}/otbenv.profile && \
    mkdir /usr/lib/python3/dist-packages/osgeo/scripts && \
    cp /usr/bin/gdal* /usr/lib/python3/dist-packages/osgeo/scripts && \
    rm "OTB-${ORFEO_TOOLBOX_VERSION}-Linux64.run"

WORKDIR /
