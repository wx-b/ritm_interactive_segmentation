FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

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



# Shell utilities
RUN git clone https://github.com/ohmybash/oh-my-bash.git /root/.oh-my-bash
COPY ./.devcontainer/user/.bashrc /root/.bashrc

# Terminal Emulator
RUN mkdir -p /root/.config/terminator
COPY ./.devcontainer/user/terminator_config /root/.config/terminator/config
RUN sed '1s.!/usr/bin/python.!/usr/bin/python2.' /usr/bin/terminator &>/dev/null

# CLI shortcuts
RUN curl -s https://raw.githubusercontent.com/DannyBen/alf/master/alf > /usr/local/bin/alf && \
    chmod a+x /usr/local/bin/alf
COPY ./.devcontainer/user/alf.conf /root/alf.conf
COPY ./.devcontainer/user/.alfrc /root/.alfrc
RUN alf save

# Create .ssh directory
RUN mkdir -p /root/.ssh

# Copy docker setup files into container
RUN mkdir -p /root/docker
COPY ./.devcontainer /root/docker

# Display message at runtime to let user know that the container is ready
RUN echo 'MSG_INFO="\033[0;32mSUCCESS\033[0m::\033[0;32m\e[2mINFO\033[0m\e[22m "; printf $MSG_INFO; echo " Running Docker container as $(whoami)"' > /etc/profile.d/welcome.sh
# ENTRYPOINT ["/bin/bash", "-l", "-c"]

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
