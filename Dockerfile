FROM debian:bookworm

RUN apt update && apt install -y git make build-essential libssl-dev wget

RUN mkdir -p /home/alas

COPY . /home/alas

CMD ["janet"]
