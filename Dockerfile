FROM continuumio/miniconda3

RUN git clone https://github.com/google/protobuf.git
RUN cd protobuf
#RUN git submodule update --init --recursive
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make check
RUN make install
RUN ldconfig
RUN protoc --version

WORKDIR /app

ADD . /app

USER root

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


