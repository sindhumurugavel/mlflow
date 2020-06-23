FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

USER root

RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum upgrade
RUN yum install snapd
RUN systemctl enable --now snapd.socket
RUN ln -s /var/lib/snapd/snap /snap
RUN snap install protobuf --classic
#RUN yum -y update

# cmake and protobuf-compiler required for onnx install
#RUN yum --enablerepo=rhel8-AppStream install python3-protobuf
RUN yum config-manager --set-enabled PowerTools
RUN yum install -y protobuf-devel protobuf-compiler


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
