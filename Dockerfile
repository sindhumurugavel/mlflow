FROM continuumio/miniconda3

#RUN yum whatprovides *jre*

USER root

WORKDIR /app

ADD . /app

RUN pip install mlflow


