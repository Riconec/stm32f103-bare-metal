GCC = arm-none-eabi-gcc
OBJ_COPY = arm-none-eabi-objcopy
OBJ_DUMP = arm-none-eabi-objdump
LD = arm-none-eabi-ld
AS = arm-none-eabi-as

ifeq ($(DEBUG), 3)
	ECHO =
else
	ECHO = @
endif

CFLAGS =

PROJ_NAME = test
BUILD_DIR = build

# Add linker script
LD_SCRIPT = f103_64k.ld
LD_FLAGS = -T source/$(LD_SCRIPT)

SOURCES = f103_startup.s

OBJECTS  = $(patsubst %.s, $(BUILD_DIR)/obj/%.o, $(filter %.s, $(SOURCES)))
OBJECTS += $(patsubst %.c, $(BUILD_DIR)/obj/%.o, $(filter %.c, $(SOURCES)))

.PHONY: all build makedir clean

all: makedir build
	@echo "Build completed"

build: $(BUILD_DIR)/$(PROJ_NAME).bin $(BUILD_DIR)/$(PROJ_NAME).hex $(BUILD_DIR)/$(PROJ_NAME).lss

$(BUILD_DIR)/obj/%.o: source/%.s
	@echo Building asm file $< to $@
	$(ECHO)$(AS) $< -o $@

$(BUILD_DIR)/$(PROJ_NAME).elf: $(OBJECTS)
	@echo Linking output $< into $@
	$(ECHO)$(LD) -o $@ $(LD_FLAGS) $<

$(BUILD_DIR)/$(PROJ_NAME).bin: $(BUILD_DIR)/$(PROJ_NAME).elf
	@echo Generating output binary $@
	$(ECHO)$(OBJ_COPY) $< $@ -O binary

$(BUILD_DIR)/$(PROJ_NAME).hex: $(BUILD_DIR)/$(PROJ_NAME).elf
	@echo Generating output hex $@
	$(ECHO)$(OBJ_COPY) $< $@ -O ihex

$(BUILD_DIR)/$(PROJ_NAME).lss: $(BUILD_DIR)/$(PROJ_NAME).elf
	@echo Generating listing $@
	$(ECHO)$(OBJ_DUMP) -S $< > $@

makedir:
	@mkdir -p ./build
	@mkdir -p ./build/obj
	@echo Build folders created

clean:
	@rm -f -r ./build
	@echo Project cleaned
