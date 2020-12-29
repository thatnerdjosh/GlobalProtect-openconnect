FROM debian:latest

RUN set -ex \
    && apt-get -y update \
    && apt-get -y install qt5-default libqt5websockets5-dev qtwebengine5-dev \
        qttools5-dev openconnect git make g++ fakeroot debhelper \
        python-pip \
    && mkdir -p /home/gp-openconnect \
    && useradd gp-openconnect

ENV QMLSCENE_DEVICE=softwarecontext

WORKDIR /home/gp-openconnect/app
COPY . .

RUN pip install git-archive-all \
    && git-archive-all --force-submodules --prefix=globalprotect-openconnect-1.3.0/ \
    ../globalprotect-openconnect_1.3.0.orig.tar.gz \
    && cd .. && tar -xzvf globalprotect-openconnect_1.3.0.orig.tar.gz \
    && cd globalprotect-openconnect-1.3.0 \
    && fakeroot dpkg-buildpackage -uc -us -sa 2>&1 | tee ../build.log

# RUN apk del qt5-qtbase-dev qt5-qtwebengine-dev qt5-qtwebsockets-dev make g++
USER gp-openconnect

CMD [ "gpclient" ]
