FROM debian:10.2

RUN echo '***** Update packages *****'                                      \
    && apt-get -y update                                                    \
                                                                            \
    && echo '***** Install packages required for creating this image *****' \
    && apt-get -y install apt-utils wget curl makepasswd gcc make git       \
                                                                            \
    && echo '***** Install command-line utility packages *****'             \
    && apt -y install sudo man less file tree

RUN echo '***** Create the wt user *****'                                   \
    && useradd wt --gid sudo                                                \
                  --shell /bin/bash                                         \
                  --create-home                                             \
    && echo "wt ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wt                \
    && chmod 0440 /etc/sudoers.d/wt

ENV HOME /home/wt
USER  wt
WORKDIR $HOME

RUN echo 'PATH=/home/wt/bin:$PATH' >> .bashrc
RUN echo 'cd /mnt/all-harvest-rippo' >> .bashrc
RUN echo 'export IN_RUNNING_RIPPO=wt-prov-model' >> .bashrc

CMD  /bin/bash -il
