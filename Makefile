ifeq ('$(OS)', 'Windows_NT')
PWSH=powershell -noprofile -command
endif

IMAGE_ORG=tmcphillips
IMAGE_NAME=all-harvest-rippo
IMAGE_TAG=latest
TAGGED_IMAGE=${IMAGE_ORG}/${IMAGE_NAME}:${IMAGE_TAG}

ADD_CAPS=SYS_PTRACE
REPO_DIR=/mnt/all-harvest-rippo
RUN_IMAGE=docker run -it -p 8787:8787                \
                     --volume $(CURDIR):$(REPO_DIR)  \
                     --cap-add=$(ADD_CAPS)           \
                     $(TAGGED_IMAGE)

ifdef IN_RUNNING_RIPPO
RUN_IN_IMAGE=bash -ic
else
RUN_IN_IMAGE=$(RUN_IMAGE) bash -ic
endif

## 
## *** Make targets that work either INSIDE or OUTSIDE a running RIPPO ***
## 

help:                   ## Show this help.
ifdef PWSH
	@${PWSH} "Select-String -Path $(MAKEFILE_LIST) -Pattern '#\# ' | % {$$_.Line.replace('##','')}"
else
	@sed -ne '/@sed/!s/#\# //p' $(MAKEFILE_LIST)
endif

# run:                  ## Run the entire workflow.
# 	$(RUN_IN_IMAGE) 'make -C $(REPO_DIR)/examples all'

# clean:                ## Delete all products of the workflow.
# 	$(RUN_IN_IMAGE) 'make -C $(REPO_DIR)/examples clean'

start-rstudio:          ## Start the RStudio server
ifdef IN_RUNNING_RIPPO
	sudo rstudio-server start
else
	$(RUN_IN_IMAGE) 'make start-rstudio; bash -il'
endif

## 
## *** Make targets that work only OUTSIDE a running RIPPO ***
## 

ifndef IN_RUNNING_RIPPO

start:
	$(RUN_IMAGE)

image:
	docker build -t ${TAGGED_IMAGE} .

push-image:
	docker push ${TAGGED_IMAGE}

pull-image:
	docker pull ${TAGGED_IMAGE}

stop-all-containers:    ## Gently stop all Docker containers running on this computer.
ifdef PWSH
	${PWSH} 'docker ps -q | % { docker stop $$_ }'
else
	for c in $$(docker ps -q); do docker stop $$c; done
endif

kill-all-containers:    ## Forcibly stop all Docker containers running on this computer.
ifdef PWSH
	${PWSH} 'docker ps -q | % { docker kill $$_ }'
else
	for c in $$(docker ps -q); do docker kill $$c; done
endif

remove-all-containers:  ## Delete all stopped Docker containers on this computer.
ifdef PWSH
	${PWSH} 'docker ps -aq | % { docker rm $$_ }'
else
	for c in $$(docker ps -aq); do docker rm $$c; done
endif

remove-all-images:      ## Delete all Docker images stored on this computer.
ifdef PWSH
	${PWSH} 'docker images -aq | % { docker rmi $$_ }'
else
	for i in $$(docker images -aq); do docker rmi $$i; done
endif

purge-docker:           ## Delete all Docker containers and images on this computer.
purge-docker: stop-all-containers kill-all-containers remove-all-containers remove-all-images

endif

## 
