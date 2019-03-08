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
LD_FLAGS = -T $(LD_SCRIPT)

SOURCES_S = f103_startup.s
SOURCES_C =

OBJECTS_S = $(SOURCES_S:.s=.o)
OBJECTS_C = $(SOURCES_C:.c=.o)

all: makedir build
	@echo "Build completed"

build: $(PROJ_NAME).bin $(PROJ_NAME).hex $(PROJ_NAME).lss

$(OBJECTS_S):
	@echo Building asm file $< to $@
	$(ECHO)$(AS) -o ./$(BUILD_DIR)/obj/$(OBJECTS_S) ./source/$(SOURCES_S)

$(OBJECTS_C):
	@echo Building C file $< to $@
	$(ECHO)$(GCC) -o ./$(BUILD_DIR)/obj/$(OBJECTS_C) ./source/$(SOURCES_C)

$(PROJ_NAME).elf: $(OBJECTS_S) $(OBJECTS_C)
	@echo Linking output $@
	$(ECHO)$(LD) -o ./$(BUILD_DIR)/$(PROJ_NAME).elf -T ./source/$(LD_SCRIPT) ./$(BUILD_DIR)/obj/$(OBJECTS_S)

$(PROJ_NAME).bin: $(PROJ_NAME).elf
	@echo Generating output binary $@
	$(ECHO)$(OBJ_COPY) ./$(BUILD_DIR)/$(PROJ_NAME).elf ./$(BUILD_DIR)/$(PROJ_NAME).bin -O binary

$(PROJ_NAME).hex: $(PROJ_NAME).elf
	@echo Generating output hex $@
	$(ECHO)$(OBJ_COPY) ./$(BUILD_DIR)/$(PROJ_NAME).elf ./$(BUILD_DIR)/$(PROJ_NAME).bin -O ihex

$(PROJ_NAME).lss: $(PROJ_NAME).elf
	@echo Generating listing $@
	$(ECHO)$(OBJ_DUMP) -S ./$(BUILD_DIR)/$(PROJ_NAME).elf > ./$(BUILD_DIR)/$(PROJ_NAME).lss

makedir:
	@mkdir -p ./build
	@mkdir -p ./build/obj
	@echo Build folders created

clean:
	@rm -f -r ./build
	@echo Project cleaned
