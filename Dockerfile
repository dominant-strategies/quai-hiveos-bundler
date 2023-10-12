FROM ubuntu:18.04
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive 
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN apt install -y git 
RUN apt install -y cmake 
RUN apt install -y build-essential 
RUN apt install -y mesa-common-dev 
RUN apt install -y nvidia-driver-530
RUN mkdir /miner
WORKDIR /miner
RUN git clone https://github.com/dominant-strategies/quai-gpu-miner.git
RUN cd quai-gpu-miner/
RUN cd quai-gpu-miner && git checkout v0.1.0-rc.1
RUN cd quai-gpu-miner && git submodule update --init --recursive
RUN cd quai-gpu-miner && mkdir build
RUN cd quai-gpu-miner/build && cmake .. && cmake --build .
RUN apt install -y awscli
COPY hiveos_packager /miner/quai_custom
ARG hive_version=0.0.10
RUN cp quai-gpu-miner/build/ethcoreminer/ethcoreminer /miner/quai_custom/ethcoreminer_bin
RUN chmod a+rwx /miner/quai_custom/*
RUN cd /miner/ && tar -zcvf quai_custom-$hive_version.tar.gz  quai_custom
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
RUN aws s3 cp /miner/quai_custom-$hive_version.tar.gz s3://quai-gpu-releases/
