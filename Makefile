SHELL := /bin/bash

.PHONY: all config build clean docker-env

all: build

config:
	chmod +x auto/config
	./auto/config

build:
	chmod +x auto/build
	./auto/build

clean:
	chmod +x auto/clean
	./auto/clean

docker-env:
	@echo "Building inside Docker (Debian) for macOS compatibility..."
	docker build -t amyos-livebuild -f Dockerfile .
	docker run --rm -it \
	  -v $(PWD):/workspace \
	  -w /workspace \
	  --privileged \
	  amyos-livebuild bash
