FROM alpine:3.9.5 as builder

WORKDIR /build
RUN apk add --update alpine-sdk build-base ncurses-dev autoconf automake curl unzip
RUN curl -L https://github.com/hishamhm/htop/archive/master.zip --output htop.zip
RUN unzip htop.zip
RUN cd htop-master

WORKDIR /build/htop-master
RUN sh autogen.sh
RUN sh configure --prefix=/build/htop-master/dist --with-proc=/proc_host
RUN make
RUN make install


# Main Container
FROM alpine:3.9.5

MAINTAINER Radoslaw Frackiewicz <frodoslaw@gmail.com>

RUN apk add --no-cache \
        bash \
        bind-tools \
        curl \
        iptraf-ng \
        iotop \
        jq \
        nano \
        netcat-openbsd \
        net-tools \
        openssh-client \
        python \
        sysstat \
        tcpdump \
        tshark \
        vim

COPY --from=builder /build/htop-master/dist/bin/htop /usr/local/bin/
