FROM alpine:latest

RUN apk add qt5-qtbase qt5-qtbase-dev qt5-qtwebengine-dev \
    qt5-qtwebsockets-dev git make g++ font-noto && \
    mkdir -p /home/gp-openconnect && \
    adduser -D gp-openconnect

WORKDIR /home/gp-openconnect/app
COPY . .

# Git Submodules not currently locked so it pulls each time
RUN git submodule update --init
RUN qmake-qt5 CONFIG+=release && \
    make && \
    make install

# RUN apk del qt5-qtbase-dev qt5-qtwebengine-dev qt5-qtwebsockets-dev make g++
USER gp-openconnect

CMD [ "gpclient" ]
