export HOST_ARCH=x86_64
export KERNEL_NAME=kernel64
export TARGET_AR=$(PWD)/toolchain/$(HOST)/bin/$(HOST)-ar

export TARGET_AS=/bin/nasm 
export TARGET_CC=$(PWD)/toolchain/$(HOST)/bin/$(HOST)-gcc
export TARGET_LD=$(PWD)/toolchain/$(HOST)/bin/$(HOST)-ld
export TARGET_GAS=$(PWD)/toolchain/$(HOST)/bin/$(HOST)-as



export TARGET_LDFLAGS=-nostdlib -static -lgcc -z max-page-size=0x1000 -Wl,-Map,$(SYM_DIR)/$(KERNEL_NAME).map



###DEFINE HERE
SOURCES_BUILD := boot.c flanterm.c fb.c test.asm
###DEFINE HERE


export C_VERSION=gnu11

export INCDIRS=-Isrc/kernel/ -Isrc/limine/flanterm -Isrc/limine/flanterm/backends

export TARGET_CFLAGS=-g -ffreestanding -O -Wno-unused-local-typedefs -Wall \
 -Wextra -std=$(C_VERSION) -Wno-unused-variable -Wno-unused-label -Wno-unused-parameter \
 $(INCDIRS) -fno-stack-protector -fno-stack-check -fno-lto -fno-PIE -fno-PIC -m64 \
 -march=x86-64 -mabi=sysv -mno-80387  -mno-red-zone -mcmodel=kernel \
 -Wunknown-pragmas -Wno-attributes 
#-mno-mmx -mno-sse -mno-sse2

export HOST_CC=gcc

export TARGET_ASFLAGS=-Wall -felf64 -g -isrc/kernel/
export HOST=$(HOST_ARCH)-elf

export SRC_DIR=$(abspath src)
export BUILD_DIR=$(abspath build)

export OBJ_DIR=$(BUILD_DIR)/objs/

export CFG_DIR=$(abspath cfg)
export SYM_DIR=$(BUILD_DIR)/sym

export LIMINE_DIR=$(abspath ./limine)




export KERNEL_FILE=$(KERNEL_NAME).elf



export EMULATOR_MEM=128M