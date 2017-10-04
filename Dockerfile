FROM ubuntu:latest
MAINTAINER Umberto Rosini, rosini@agid.gov.it

# Update and install utilities
RUN apt-get update && \
    apt-get install curl && \
    apt-get install vi && \
    apt-get install netstat

# Create user to run is and the backoffice (not root for security reason!)
RUN useradd --user-group --create-home --shell /bin/false yoda

# Oracle Java 8
RUN apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get install oracle-java8-set-default && \
    rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME="/usr/lib/jvm/java-8-oracle"

# Identity Server
RUN apt-get install curl && \
    mkdir /spid-testenv && \
    curl -o /spid-testenvironment/spid-testenvironment-identityserver.tar.gz https://codeload.github.com/italia/spid-testenvironment-identityserver/tar.gz/v0.9-beta.1 && \
    mkdir /spid-testenvironment/is && \
    tar -zxvf /spid-testenvironment/spid-testenv-identityserver.tar.gz -C /spid-testenvironment/is --strip-components=1 && \
    rm -f /spid-testenvironment/spid-testenv-identityserver.tar.gz && \
    chmod +x /spid-testenvironment/is/identity-server/bin/wso2server.sh

# Set custom conf
RUN mv /spid-testenvironment/is/spid-conf/conf/* /spid-testenvironment/is/identity-server/repository/conf/ 
    
# Port exposed
EXPOSE 9443

RUN chown -R yoda:yoda /spid-testenvironment/*

USER yoda

# Start & Stop to bootstrap the Identity Server
# RUN /spid-testenvironment/is/identity-server/bin/wso2server.sh start > /dev/null &
# RUN /spid-testenvironment/is/identity-server/bin/wso2server.sh stop > /dev/null &

WORKDIR /spid-testenvironment/is/identity-server/bin

ENTRYPOINT ["wso2server.sh"]