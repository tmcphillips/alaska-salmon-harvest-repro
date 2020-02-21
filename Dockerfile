FROM rocker/rstudio:3.6.2

RUN echo '***** Install R packages needed to run the analysis *****'        \
    && R -e "install.packages(c('dplyr', 'ggplot2', 'RColorBrewer'))"       \
    && R -e "install.packages(c('tidyr', 'jsonlite', 'base64enc'))"         \
    && R -e "install.packages(c('htmltools', 'knitr', 'rmarkdown'))"

RUN echo '***** Update OS packages needed to build and run this image*****' \
    && apt -y update                                                        \
    && apt -y install apt-utils wget curl makepasswd make git               \
    && apt -y install sudo man less file tree procps

RUN echo '***** Replace the rstudio user with the wt user *****'            \
    && userdel rstudio                                                      \
    && groupadd wt --gid 1000                                               \
    && useradd wt --uid 1000 --gid 1000 --shell /bin/bash --create-home     \
       -p `echo wt | makepasswd --crypt-md5 --clearfrom - | cut -b5-`       \
    && echo "wt ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wt                \
    && chmod 0440 /etc/sudoers.d/wt

ENV HOME /home/wt
USER  wt
WORKDIR $HOME

COPY --chown=1000:1000 ./docker/.rstudio ${HOME}/.rstudio
RUN echo 'setwd("/mnt/all-harvest-rippo/analysis")' >> .Rprofile
RUN echo 'export IN_RUNNING_RIPPO=wt-prov-model' >> .bashrc
RUN echo 'cd /mnt/all-harvest-rippo' >> .bashrc

CMD  /bin/bash -il
