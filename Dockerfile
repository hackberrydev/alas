FROM debian:bookworm

RUN apt update && apt install -y git make build-essential libssl-dev wget

RUN mkdir -p /home/janet

RUN cd /home/janet && wget https://github.com/janet-lang/janet/archive/refs/tags/v1.29.1.tar.gz

RUN cd /home/janet && tar xvf v1.29.1.tar.gz

RUN cd /home/janet/janet-1.29.1 && make && make test && make install

RUN cd /home && git clone https://github.com/janet-lang/jpm.git

RUN cd /home/jpm && janet bootstrap.janet

RUN cd /home/alas && jpm deps

CMD ["janet"]
