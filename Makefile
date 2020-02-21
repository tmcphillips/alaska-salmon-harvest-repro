ifeq ('$(OS)', 'Windows_NT')
PWSH=powershell -noprofile -command
endif

IMAGE_ORG=tmcphillips
IMAGE_NAME=all-harvest-rippo
IMAGE_TAG=latest
TAGGED_IMAGE=${IMAGE_ORG}/${IMAGE_NAME}:${IMAGE_TAG}

REPO_DIR=/mnt/all-harvest-rippo
RUN_IMAGE=docker run -it --rm -p 8787:8787           \
                     --volume $(CURDIR):$(REPO_DIR)  \
                     $(TAGGED_IMAGE)

ifdef IN_RUNNING_RIPPO
RUN_IN_IMAGE=bash -ic
else
RUN_IN_IMAGE=$(RUN_IMAGE) bash -ic
endif

## 
## ------------------------------------------------------------------------------
##        Make targets available both INSIDE and OUTSIDE a running RIPPO
## 

help:                   ## Show this help.
ifdef PWSH
	@${PWSH} "Select-String -Path $(MAKEFILE_LIST) -Pattern '#\# ' | % {$$_.Line.replace('##','')}"
else
	@sed -ne '/@sed/!s/#\# //p' $(MAKEFILE_LIST)
endif

clean:                  ## Delete all products of the analysis.
	$(RUN_IN_IMAGE) 'make -C $(REPO_DIR)/analysis clean'


rstudio:                ## Start RStudio Server and load the All_Harvest project.
ifdef IN_RUNNING_RIPPO
	@sudo rstudio-server start
	@echo "\n--------------------------------------------------------------------------"
	@echo   " Open a web browser to http://localhost:8787 (Username: wt, Password: wt)"
	@echo   "--------------------------------------------------------------------------\n"
else
	@$(RUN_IN_IMAGE) 'make rstudio; bash -il'
endif

## ------------------------------------------------------------------------------
##            Make targets available only OUTSIDE a running RIPPO
## 


ifndef IN_RUNNING_RIPPO

start:                  ## Start a bash session in a new Docker container.
	$(RUN_IMAGE)

image:                  ## Build the Docker image.
	docker build -t ${TAGGED_IMAGE} .

pull-image:             ## Pull the Docker image from Docker Hub.
	docker pull ${TAGGED_IMAGE}

push-image:             ## Push the Docker image to Docker Hub.
	docker push ${TAGGED_IMAGE}

## 

stop-all-containers:    ## Gently stop all running Docker containers.
ifdef PWSH
	${PWSH} 'docker ps -q | % { docker stop $$_ }'
else
	for c in $$(docker ps -q); do docker stop $$c; done
endif

kill-all-containers:    ## Forcibly stop all running Docker containers.
ifdef PWSH
	${PWSH} 'docker ps -q | % { docker kill $$_ }'
else
	for c in $$(docker ps -q); do docker kill $$c; done
endif

remove-all-containers:  ## Delete all stopped Docker containers.
ifdef PWSH
	${PWSH} 'docker ps -aq | % { docker rm $$_ }'
else
	for c in $$(docker ps -aq); do docker rm $$c; done
endif

remove-all-images:      ## Delete all Docker images on this computer.
ifdef PWSH
	${PWSH} 'docker images -aq | % { docker rmi $$_ }'
else
	for i in $$(docker images -aq); do docker rmi $$i; done
endif

purge-docker:           ## Purge all Docker containers and images from computer.
purge-docker: stop-all-containers kill-all-containers remove-all-containers remove-all-images

endif

## ------------------------------------------------------------------------------
## 
