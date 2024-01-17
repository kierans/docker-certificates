ifndef VERSION
$(error VERSION is not set)
endif

NAME="kierans777/docker-certificates"

all: build

build:
	docker build -t $(NAME):$(VERSION) .

push:
	docker push $(NAME):$(VERSION)
