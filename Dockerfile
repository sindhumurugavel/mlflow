FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

USER root

RUN yum -y update

# install prequired modules to support install of mlflow and related components
#RUN yum install -y curl
#RUN yum install -y mariadb-connector-c-devel-3.0.7-1.el8.x86_64

# cmake and protobuf-compiler required for onnx install
#RUN cmake protobuf-compiler &&
#RUN yum install -y cmake protobuf-compiler

# install required python packages
RUN pip install --upgrade pip
RUN pip install -r dev-requirements.txt
RUN pwd
RUN ls
#RUN pip install -r test-requirements.txt
RUN pip install -r travis/small-requirements.txt
RUN pip install -r travis/large-requirements.txt
RUN pip install -r travis/lint-requirements.txt

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
