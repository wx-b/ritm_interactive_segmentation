FROM nvidia/cuda:11.4.2-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
	    git \
	    curl \
        libglib2.0-0 \
        software-properties-common \
        python3.6-dev \
        python3-pip \
        python3-tk

WORKDIR /tmp

RUN pip3 install --upgrade pip
RUN pip3 install setuptools
RUN pip3 install matplotlib numpy pandas scipy tqdm pyyaml easydict scikit-image bridson Pillow ninja
RUN pip3 install imgaug mxboard graphviz
RUN pip3 install albumentations --no-deps
RUN pip3 install opencv-python-headless
RUN pip3 install Cython
RUN pip3 install torch
RUN pip3 install torchvision
RUN pip3 install scikit-learn
RUN pip3 install tensorboard

RUN mkdir /work
WORKDIR /work
RUN chmod -R 777 /work && chmod -R 777 /root

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

FROM base

COPY requirements.txt /requirements.txt
RUN pip3 install torch==1.10.1+cu113 torchvision==0.11.2+cu113 torchaudio==0.10.1+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html \
    && pip3 install -r /requirements.txt
COPY src /work
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
