FROM ubuntu
MAINTAINER Martin Klepsch

# Install dependencies
RUN apt-get update
RUN apt-get install -y curl default-jre-headless

# Download the latest .deb and install
RUN curl http://aphyr.com/riemann/riemann_0.2.5_all.deb > /tmp/riemann_0.2.5_all.deb
RUN dpkg -i /tmp/riemann_0.2.5_all.deb

# Expose the ports for inbound events and websockets
EXPOSE 5555
EXPOSE 5555/udp
EXPOSE 5556

VOLUME ["/data"]
WORKDIR /data

# Set the hostname in /etc/hosts so that Riemann doesn't die due to unknownHostException
CMD echo 127.0.0.1 $(hostname) > /etc/hosts; /usr/bin/riemann riemann.config
