FROM ubuntu:20.04

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
RUN python3 -m pip install --upgrade pip

# install gdal
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
    apt-get update && \
    apt-get -y upgrade

RUN apt-get install -y \
    python3-gdal \
    python3-numpy \
    gdal-bin \
    libgdal-dev

RUN python3 -m pip install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-L/Library/Frameworks/GDAL.framework/Versions/2.2/GDAL -I/Library/Frameworks/GDAL.framework/Versions/2.2/GDAL -lgdal"

# install orfeo toolbox
ENV ORFEO_TOOLBOX_VERSION=7.2.0
ENV ORFEO_TOOLBOX_PATH=/home/OTB-${ORFEO_TOOLBOX_VERSION}-Linux64

WORKDIR /home/
RUN curl -o "OTB-${ORFEO_TOOLBOX_VERSION}-Linux64.run" "https://www.orfeo-toolbox.org/packages/OTB-${ORFEO_TOOLBOX_VERSION}-Linux64.run" && \
    chmod 777 OTB-${ORFEO_TOOLBOX_VERSION}-Linux64.run && \
    ./OTB-${ORFEO_TOOLBOX_VERSION}-Linux64.run && \
    ./OTB-${ORFEO_TOOLBOX_VERSION}-Linux64/otbenv.profile && \
    mkdir /usr/lib/python3/dist-packages/osgeo/scripts && \
    cp /usr/bin/gdal* /usr/lib/python3/dist-packages/osgeo/scripts && \
    rm "OTB-${ORFEO_TOOLBOX_VERSION}-Linux64.run"

WORKDIR /