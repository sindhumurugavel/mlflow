FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

#RUN whoami
USER root
#RUN whoami

#RUN apt-get update &&
RUN yum -y update
# install prequired modules to support install of mlflow and related components
#RUN apt-get install -y default-libmysqlclient-dev build-essential curl
RUN yum install -y curl
#RUN yum install gcc gcc-c++ kernel-devel make
RUN yum install -y mariadb-devel
# cmake and protobuf-compiler required for onnx install
#RUN cmake protobuf-compiler &&
RUN yum cmake protobuf-compiler &&
# install required python packages
RUN pip install -r dev-requirements.txt &&
RUN pip install -r test-requirements.txt &&
# install mlflow in editable form
RUN pip install -e . &&
# mkdir required to support install openjdk-11-jre-headless
RUN mkdir -p /usr/share/man/man1 && yum install -y openjdk-11-jre-headless &&
# install npm for node.js support
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - &&
#RUN apt-get update && apt-get install -y nodejs &&
RUN yum -y update && yum install -y nodejs &&
RUN cd mlflow/server/js &&
RUN npm install &&
RUN npm run build
