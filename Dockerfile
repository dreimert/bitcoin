FROM debian:jessie

MAINTAINER Damien Reimert<damien@reimert.fr>

RUN apt-get -y update
RUN apt-get install -y git

WORKDIR /root/

RUN git clone https://github.com/bitcoin/bitcoin

RUN apt-get install -y autoconf
RUN apt-get install -y wget

RUN wget http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
RUN tar -zxvf libtool-2.4.6.tar.gz

WORKDIR /root/libtool-2.4.6

RUN apt-get install -y gcc make
RUN ./configure --prefix=/root/libtool && make && make install

#WORKDIR /root/

#RUN wget http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz
#RUN tar -zxvf db-6.2.23.tar.gz

#WORKDIR /root/db-6.2.23/build_unix

RUN apt-get install -y g++ pkg-config

#RUN ../dist/configure --prefix=/root/bbd --enable-cxx --disable-shared --with-pic
#RUN make && make install

WORKDIR /root/

RUN wget 'http://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.gz/download'
RUN mv download boost_1_61_0.tar.gz
RUN tar zxvf boost_1_61_0.tar.gz

WORKDIR /root/boost_1_61_0

RUN ./bootstrap.sh --prefix=/root/boost
RUN ./b2; exit 0

WORKDIR /root/

RUN wget https://www.openssl.org/source/openssl-1.1.0.tar.gz
RUN tar zxvf openssl-1.1.0.tar.gz

WORKDIR /root/openssl-1.1.0

RUN ./config --prefix=/root/openssl
RUN make
RUN make install

WORKDIR /root/

RUN wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
RUN tar zxvf libevent-2.0.22-stable.tar.gz

WORKDIR /root/libevent-2.0.22-stable

RUN ./configure --prefix=/root/libevent
RUN make
RUN make install

WORKDIR /root/bitcoin

RUN apt-get install -y bsdmainutils

ENV ACLOCAL_PATH=/root/libtool/share/aclocal/
ENV PATH=$PATH:/root/libtool/bin
ENV BOOST_ROOT=/root/boost_1_61_0
ENV PKG_CONFIG_PATH=/root/openssl/lib/pkgconfig/:/root/libevent/lib/pkgconfig/
ENV LD_LIBRARY_PATH=/root/boost_1_61_0/stage/lib/:/root/openssl/lib/:/root/libevent/lib

RUN ./autogen.sh

RUN ./configure --disable-wallet
RUN make
