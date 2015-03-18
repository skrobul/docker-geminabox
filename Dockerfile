FROM ubuntu:latest
MAINTAINER  Marek Skrobacki <marek.skrobacki@rackspace.co.uk>

RUN apt-key update &&\
    apt-get update &&\
    apt-get install -y ruby1.9.1 &&\
    gem install --no-ri --no-rdoc geminabox &&\
    mkdir -p /opt/geminabox/
ADD files/config.ru /opt/geminabox/config.ru
VOLUME  ["/opt/geminabox/data"]
EXPOSE  9292
WORKDIR /opt/geminabox
CMD ["/usr/local/bin/rackup", "-o", "0.0.0.0"]
