# AmyOS Debian Live

Minimal Debian live-build setup to produce an ISO.

## Quick start (macOS-friendly)

- Build in Docker to avoid host quirks and get required privileges.

```sh
# one-time: build the build environment
make docker-env
# inside the container shell:
make config
make build
# resulting ISO will be at project root, e.g. live-image-amd64.hybrid.iso
```

## Host build (Debian/Ubuntu)

If building directly on Debian/Ubuntu with privileges:

```sh
sudo apt-get update && sudo apt-get install -y \
  live-build cpio xorriso squashfs-tools syslinux isolinux dosfstools

make config
sudo make build
```

## Layout

- `auto/` – helper scripts for config/build/clean
- `config/` – live-build configuration (package lists, hooks, includes)
- `Dockerfile` – containerized build environment
- `Makefile` – convenience targets

## Customize

- Packages: edit `config/package-lists/base.list.chroot`
- Files in live system: put under `config/includes.chroot` (e.g., `/etc/` files)
- Hooks: scripts under `config/hooks/normal/*.hook.chroot` run during build

## Clean

```sh
make clean
```

## Notes

- Run the container with `--privileged` (Makefile does this) since live-build needs loop devices.
- Default release: trixie (Debian 13), arch: amd64. Tweak in `auto/config` or `config/bootstrap`.