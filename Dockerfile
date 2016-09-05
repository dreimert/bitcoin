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

WORKDIR /root/

RUN wget http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz
RUN tar -zxvf db-6.2.23.tar.gz

WORKDIR /root/db-6.2.23/build_unix

RUN apt-get install -y g++ pkg-config

RUN ../dist/configure --prefix=/root/bbd --enable-cxx --disable-shared --with-pic
RUN make && make install

WORKDIR /root/

RUN wget -c 'http://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.bz2/download'

WORKDIR /root/bitcoin

ENV ACLOCAL_PATH=/root/libtool/share/aclocal/
ENV PATH=$PATH:/root/libtool/bin
RUN ./autogen.sh
#RUN ./configure LDFLAGS="-L/root/bbd/lib/" CPPFLAGS="-I/root/bbd/include/" --with-incompatible-bdb
