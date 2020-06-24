FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

USER root

RUN yum -y update
# install protobuf-compiler required for onnx install
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum -y upgrade

#RUN yum config-manager repos --enable=epel-testing --disable=epel
#RUN yum config-manager repos --disable = 
#RUN yum repolist all
#RUN yum update
RUN yum list installed
sudo yum --enablerepo=epel-testing install snapd
RUN systemctl enable --now snapd.socket
RUN ln -s /var/lib/snapd/snap /snap
RUN snap install protobuf --classic

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


