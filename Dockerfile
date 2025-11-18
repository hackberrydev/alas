FROM debian:trixie-slim

ARG JANET_VERSION
ARG JPM_VERSION

RUN apt update && apt install -y git make build-essential libssl-dev wget

RUN mkdir -p /home/janet

RUN cd /home/janet && wget https://github.com/janet-lang/janet/archive/refs/tags/v${JANET_VERSION}.tar.gz

RUN cd /home/janet && tar xvf v${JANET_VERSION}.tar.gz

RUN cd /home/janet/janet-$JANET_VERSION && make && make test && make install

RUN cd /home && git clone --depth 1 --branch $JPM_VERSION https://github.com/janet-lang/jpm.git

RUN cd /home/jpm && janet bootstrap.janet

WORKDIR /home/alas

CMD ["/usr/bin/bash"]
