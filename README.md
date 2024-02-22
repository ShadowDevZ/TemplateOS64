# TEMPLATE OS

Template for x64 based operating system utilizing [limine](https://github.com/limine-bootloader/limine) bootloader
This template adds the [flanterm](https://github.com/mintsuki/flanterm)
for printing strings without the need of
writing you own driver

To use this template you need xorriso, git and optionally qemu

# Building

Edit `cfg/config.mk` and edit the toolchain path and compiler if needed
For building you can use my script [tc-bootstrapper](https://github.com/ShadowDevZ/tc-bootstrapper)
Run `make bootstrap` or `make limine` if you ran this for the first time
to download the dependencies.
After that just run make to build the iso. The iso is located inside the build
directory alongside the ELF file.

# Run in qemu
`make run`

# Cleanup the objects
`make clean`

# Return the source tree to the original state
`make distclean`