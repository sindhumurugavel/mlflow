FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

USER root


RUN yum -y update
# install protobuf-compiler required for onnx install

# Build Protobuf
RUN wget -q https://raw.githubusercontent.com/linux-on-ibm-z/scripts/master/Protobuf/3.11.4/build_protobuf.sh
RUN bash build_protobuf.sh 
RUN protoc --version

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


