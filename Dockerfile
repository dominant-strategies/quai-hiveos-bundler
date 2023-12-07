FROM ubuntu:18.04
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive 
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN apt install -y git 
RUN apt install -y cmake 
RUN apt install -y build-essential 
RUN apt install -y mesa-common-dev 
RUN apt install -y nvidia-driver-530
RUN apt install -y wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb
RUN apt-get update
RUN apt-get -y install cuda
RUN mkdir /miner
WORKDIR /miner
RUN git clone https://github.com/dominant-strategies/quai-gpu-miner.git
RUN cd quai-gpu-miner/
ARG miner_tag=v0.1.0-rc.1
RUN cd quai-gpu-miner && git fetch --all && git checkout $miner_tag
RUN cd quai-gpu-miner && git submodule update --init --recursive
RUN cd quai-gpu-miner && mkdir build
RUN cd quai-gpu-miner/build && cmake .. -DETHASHCUDA=ON  && cmake --build .
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
