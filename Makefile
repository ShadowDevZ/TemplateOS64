include cfg/config.mk
.PHONY: all kernel clean run bootstrap distclean

override _C_SOURCES := $(abspath $(shell find -P src -type f -name '*.c'))
override _AS_SOURCES := $(abspath $(shell find -P src -type f -name '*.asm'))


C_SOURCES := $(filter $(addprefix %/,$(SOURCES_BUILD)),$(_C_SOURCES))
AS_SOURCES := $(filter $(addprefix %/,$(SOURCES_BUILD)),$(_AS_SOURCES))

OBJ := $(addprefix $(OBJ_DIR), $(notdir $(C_SOURCES:.c=.c.o)))
OBJASM := $(addprefix $(OBJ_DIR), $(notdir $(AS_SOURCES:.asm=.asm.o)))

dirs := $(dir $(C_SOURCES))
dirs += $(dir $(AS_SOURCES))
VPATH := $(dirs)






all: iso
	@echo $(BUILD_DIR)
	@echo $(C_SOURCES)
	


limine:	

	git clone https://github.com/limine-bootloader/limine.git --branch=v5.x-branch-binary --depth=1 $(LIMINE_DIR)
#	$(MAKE) -C limine CC=gcc CFLAGS="-Wall -Wextra"
	mkdir -p $(SRC_DIR)/limine/include
	$(MAKE) -C $(LIMINE_DIR) CC="${HOST_CC}"
	cp -v $(LIMINE_DIR)/limine.h $(abspath src/limine/include)
	@echo Successfully built Limine bootloader dependency

	git clone https://github.com/mintsuki/flanterm.git --depth=1 $(abspath src/limine/flanterm)

	



kernel: $(OBJ) $(OBJASM) $(CFG_DIR)/linker.ld
	$(TARGET_CC) -T $(CFG_DIR)/linker.ld -o $(BUILD_DIR)/$(KERNEL_FILE) $(TARGET_LDFLAGS) $(OBJ) $(OBJASM)
	
	@echo LD ' ' $(KERNEL_FILE)


$(OBJ): $(OBJ_DIR)%.c.o: %.c
	
	@$(TARGET_CC) -MD -c $< -o $@ $(TARGET_CFLAGS)
	@echo CC ' ' $@


$(OBJASM): $(OBJ_DIR)%.asm.o: %.asm

	
	@$(TARGET_AS) $(TARGET_ASFLAGS) -o $@ $<
	@echo AS ' ' $@


iso: $(KERNEL_NAME).iso

$(KERNEL_NAME).iso: kernel
	rm -rf $(BUILD_DIR)/iso
	mkdir -p $(BUILD_DIR)/iso
	
	
	cp $(BUILD_DIR)/$(KERNEL_FILE) $(CFG_DIR)/limine.cfg $(LIMINE_DIR)/limine-bios-cd.bin \
	$(LIMINE_DIR)/limine-bios.sys $(BUILD_DIR)/iso/

	
	xorriso -as mkisofs -b limine-bios-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
	--protective-msdos-label $(BUILD_DIR)/iso -o $(BUILD_DIR)/iso/$(KERNEL_NAME).iso

	@$(LIMINE_DIR)/limine bios-install $(BUILD_DIR)/iso/$(KERNEL_NAME).iso
	@cp $(BUILD_DIR)/iso/$(KERNEL_NAME).iso $(BUILD_DIR)
	@rm -rf $(BUILD_DIR)/iso/*


run: iso
	@qemu-system-$(HOST_ARCH) -M q35 -m $(EMULATOR_MEM) -cdrom $(BUILD_DIR)/$(KERNEL_NAME).iso -boot d -debugcon stdio

bootstrap: limine

clean:
	rm -f $(OBJ_DIR)/*.o $(OBJ_DIR)/*.d $(BUILD_DIR)/*.elf $(SYM_DIR)/*.map $(BUILD_DIR)/*.iso


distclean: clean
	rm -rf $(LIMINE_DIR)
	rm -rf $(SRC_DIR)/limine/flanterm
	rm -rf $(SRC_DIR)/limine