FROM quay.io/fedora/fedora:latest

RUN dnf install -y nginx cargo openssl-devel

# https://github.com/vi/websocat
RUN cargo install --features=ssl websocat
ENV PATH="${PATH}:/root/.cargo/bin"

RUN dnf install -y openssh-server openssh-clients
ADD contrib/nginx.conf /etc/nginx/nginx.conf
ADD contrib/server.sh /
ADD contrib/client.sh /
