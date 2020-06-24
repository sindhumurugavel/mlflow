FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

USER root

RUN yum -y update
# install protobuf-compiler required for onnx install
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum -y upgrade

RUN yum repolist

