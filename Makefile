GCC = arm-none-eabi-gcc
OBJ_COPY = arm-none-eabi-objcopy
LD = arm-none-eabi-ld
AS = arm-none-eabi-as

#CFLAGS =

PROJ_NAME = test
BUILD_DIR = build
LD_SCRIPT = f103_64k.ld

SOURCES_S = f103_startup.s
SOURCES_C =

OBJECTS_S = $(SOURCES_S:.s=.o)
OBJECTS_C = $(SOURCES_C:.c=.o)

all: makedir build

build: $(PROJ_NAME).bin $(PROJ_NAME).lss

$(OBJECTS_S):
	$(AS) -o ./$(BUILD_DIR)/obj/$(OBJECTS_S) ./source/$(SOURCES_S)

$(PROJ_NAME).elf: $(OBJECTS_S) $(OBJECTS_C)
	$(LD) -o ./$(BUILD_DIR)/$(PROJ_NAME).elf -T ./source/$(LD_SCRIPT) ./$(BUILD_DIR)/obj/$(OBJECTS_S)

$(PROJ_NAME).bin: $(PROJ_NAME).elf
	$(OBJ_COPY) ./$(BUILD_DIR)/$(PROJ_NAME).elf ./$(BUILD_DIR)/$(PROJ_NAME).bin -O binary

$(PROJ_NAME).lss: $(PROJ_NAME).elf
	$(OBJ_COPY) -S ./$(BUILD_DIR)/$(PROJ_NAME).elf > ./$(BUILD_DIR)/$(PROJ_NAME).lss

makedir:
	mkdir -p ./build
	mkdir -p ./build/obj

clean:
	rm -f -r ./build
