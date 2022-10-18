FROM alpine:3.9
LABEL maintainer="Timo Lindenblatt <timo.lindenblatt@tmt.de>"
WORKDIR /app
RUN apk update && apk add --no-cache \
cmake \
libxml2-dev \
g++ \
git \
make \
expat-dev \
bzip2-dev \
boost-dev \
postgresql \
postgresql-dev \
py2-pip \
python-dev \
php7 \
php7-pear \
php7-openssl \
php7-pdo \
php7-pdo_pgsql \
expat \
libbz2 \
libstdc++ && \
apk add --no-cache --repository "http://dl-4.alpinelinux.org/alpine/edge/testing" proj4 proj4-dev && \
pip install osmium && \
pear channel-update pear.php.net && \
pear install DB && \
git clone --recursive https://github.com/openstreetmap/Nominatim src && \
cd src && \
git -c advice.detachedHead=false checkout tags/v3.3.0 && \
git submodule update --recursive --init && \
mkdir build && \
cd build && \
cmake .. && \
make && \
wget -O /app/src/data/country_osm_grid.sql.gz https://www.nominatim.org/data/country_grid.sql.gz && \
rm -rf /var/cache/apk/*
