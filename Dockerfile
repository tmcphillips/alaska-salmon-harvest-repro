FROM rocker/rstudio:3.6.2

RUN R -e "install.packages(c('dplyr', 'ggplot2', 'knitr', 'RColorBrewer', 'tidyr'), repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages(c('htmltools', 'jsonlite', 'base64enc', 'rmarkdown'), repos = 'http://cran.us.r-project.org')"

RUN echo '***** Update packages *****'                                      \
    && apt -y update                                                        \
                                                                            \
    && echo '***** Install packages required for creating this image *****' \
    && apt -y install apt-utils wget curl makepasswd make git               \
                                                                            \
    && echo '***** Install command-line utility packages *****'             \
    && apt -y install sudo man less file tree procps

RUN sudo userdel rstudio

RUN echo '***** Create the wt group and user *****'                         \
    && groupadd wt --gid 1000                                               \
    && useradd wt --uid 1000                                                \
                  --gid 1000                                                \
                  --shell /bin/bash                                         \
                  --create-home                                             \
                  --password `echo wt | makepasswd --crypt-md5 --clearfrom - | cut -b5-`     \
    && echo "wt ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wt                \
    && chmod 0440 /etc/sudoers.d/wt

ENV HOME /home/wt
USER  wt
WORKDIR $HOME

COPY --chown=1000:1000 docker/.rstudio .rstudio

RUN echo 'setwd("/mnt/all-harvest-rippo/analysis")' >> .Rprofile
RUN echo 'export IN_RUNNING_RIPPO=wt-prov-model' >> .bashrc
RUN echo 'cd /mnt/all-harvest-rippo' >> .bashrc

CMD  /bin/bash -il
