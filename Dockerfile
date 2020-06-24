FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

USER root

RUN yum repolist

