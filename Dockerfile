FROM continuumio/miniconda3

USER root

WORKDIR /app

ADD . /app

RUN export HTTP_PROXY=http://internet.ford.com:83
RUN export HTTPS_PROXY=https://internet.ford.com:83
RUN curl -sL --output protoc-3.12.3-linux-x86_64.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.12.3/protoc-3.12.3-linux-x86_64.zip
RUN yum install zip
RUN unzip protoc-3.12.3-linux-x86_64.zip
RUN ls
RUN echo $PATH
RUN cp protoc-3.12.3-linux-x86_64/bin/protoc /usr/local/bin/
RUN protoc --version

RUN yum -y update

# install required python packages
RUN pip install --upgrade pip
RUN ls -lrt
RUN pip install -r dev-requirements.txt
RUN pip install -r test-requirements.txt

# install mlflow in editable form
RUN pip install -e .

# mkdir required to support install openjdk-11-jre-headless
RUN mkdir -p /usr/share/man/man1 && yum install -y openjdk-11-jre-headless

# install npm for node.js support
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

#RUN apt-get update && apt-get install -y nodejs
RUN yum -y update && yum install -y nodejs
RUN cd mlflow/server/js
RUN npm install
RUN npm run build


