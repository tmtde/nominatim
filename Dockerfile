FROM alpine:3.16

ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_URL
ARG VCS_REF
ARG VCS_BRANCH
# See http://label-schema.org/rc1/ and https://microbadger.com/labels
LABEL maintainer="Timo Lindenblatt <timo.lindenblatt@tmt.de>" \
    org.label-schema.name="Nominatim build environment" \
    org.label-schema.description="Nominatim build environment" \
    org.label-schema.vendor="TMT GmbH & Co. KG" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date="${BUILD_DATE:-unknown}" \
    org.label-schema.version="${BUILD_VERSION:-unknown}" \
    org.label-schema.vcs-url="${VCS_URL:-unknown}" \
    org.label-schema.vcs-ref="${VCS_REF:-unknown}" \
    org.label-schema.vcs-branch="${VCS_BRANCH:-unknown}"

ENV NOMINATIM_VER 3.5.2
ENV OSNIUM_VER 2.15.4
WORKDIR /app
# hadolint ignore=DL3003,DL3018
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
proj \
proj-dev \
py3-pip \
python3-dev \
php8 \
php8-pear \
php8-openssl \
php8-pdo \
php8-pdo_pgsql \
expat \
libbz2 \
icu-data-full \
libstdc++ && \
pip install --no-cache-dir osmium==$OSNIUM_VER && \
pear channel-update pear.php.net && \
pear install MDB2 && \
wget http://www.nominatim.org/release/Nominatim-$NOMINATIM_VER.tar.bz2 && \
tar xf Nominatim-$NOMINATIM_VER.tar.bz2 && \
cd Nominatim-$NOMINATIM_VER && \
mkdir build && \
cd build && \
cmake .. && \
make -j`nproc` && \
mkdir -p /app/src/data/ && \
wget -q https://www.nominatim.org/data/country_grid.sql.gz -O /app/src/data/country_osm_grid.sql.gz && \
rm -rf /var/cache/apk/*
