SHELL := /bin/bash

.PHONY: all config build clean docker-env docker-shell docker-build doctor docker-doctor

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

doctor: ## Check local environment tools
	@echo "Host info:"
	uname -a || true
	@echo
	@echo "Tooling:"
	which lb || true
	lb --version || true
	docker --version || true
	@echo
	@echo "User: $$(id -u):$$(id -g)"

docker-shell: ## Start an interactive shell in the build container
	@echo "Starting interactive shell inside Docker (Debian) for macOS compatibility..."
	docker build -t amyos-livebuild -f Dockerfile .
	docker run --rm -it \
	  -v $(PWD):/workspace \
	  -w /workspace \
	  --privileged \
	  amyos-livebuild bash

docker-env: docker-shell ## Back-compat alias for docker-shell

docker-build: ## Run config+build inside the container non-interactively
	@echo "Building ISO inside Docker container..."
	docker build -t amyos-livebuild -f Dockerfile .
	docker run --rm \
	  -e LOCAL_UID=$(shell id -u) -e LOCAL_GID=$(shell id -g) \
	  -v $(PWD):/workspace \
	  -w /workspace \
	  --privileged \
	  amyos-livebuild bash -lc "make config && make build && chown -R $$LOCAL_UID:$$LOCAL_GID /workspace"

docker-doctor: ## Validate live-build inside container
	@echo "Checking live-build environment inside Docker..."
	docker build -t amyos-livebuild -f Dockerfile .
	docker run --rm -it \
	  -v $(PWD):/workspace \
	  -w /workspace \
	  --privileged \
	  amyos-livebuild bash -lc 'set -e; lb --version; echo; echo "Loop device support:"; losetup -f || true; echo; echo "xorriso:"; xorriso -version || true'
