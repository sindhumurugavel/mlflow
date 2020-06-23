FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

USER root

RUN cmake protobuf-compiler-2.5.0-8.el7.x86_64.rpm
