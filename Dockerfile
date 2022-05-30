FROM ubuntu:focal

# Update Ubuntu
RUN apt-get update --fix-missing && apt-get -y upgrade

#  Install supervisor
RUN apt-get -y install software-properties-common supervisor
RUN apt-get -y update

RUN  apt update &&  apt upgrade
RUN apt install wget


#install mongo
RUN apt-get install gnupg
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc |  apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" |  tee /etc/apt/sources.list.d/mongodb-org-4.2.list
RUN apt-get update
RUN  apt-get install -y mongodb-org
RUN  echo "mongodb-org hold" |  dpkg --set-selections \
RUN  echo "mongodb-org-server hold" |  dpkg --set-selections \
RUN  echo "mongodb-org-shell hold" |  dpkg --set-selections
RUN  echo "mongodb-org-mongos hold" |  dpkg --set-selections
RUN  echo "mongodb-org-tools hold" |  dpkg --set-selections




COPY mongod.conf /etc/mongod.conf

# Define mountable directories.
VOLUME ["/data/db"]

RUN mkdir /usr/api
WORKDIR /usr/api

#install jdk
RUN apt-get update && apt-get upgrade
RUN apt-get -y install openjdk-17-jdk-headless

ADD Annonces-MS /usr/api
ADD Auth-MS /usr/api
ADD Cloud-Gateway /usr/api
ADD Registry /usr/api

RUN chmod +x /usr/api/*.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9191 8761 27017 8081 8095



#CMD /bin/bash
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]