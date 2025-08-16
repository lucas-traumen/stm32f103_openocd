# =========================
# Makefile cho STM32F103C8
# =========================

# Đường dẫn toolchain
TOOLCHAIN := "C:/Program Files (x86)/GNU Arm Embedded Toolchain/10 2021.10/bin"

# Trình biên dịch ARM
CC      := $(TOOLCHAIN)/arm-none-eabi-gcc.exe
OBJCOPY := $(TOOLCHAIN)/arm-none-eabi-objcopy.exe
SIZE    := $(TOOLCHAIN)/arm-none-eabi-size.exe

# Cờ biên dịch/chống liên kết
CFLAGS  := -mcpu=cortex-m3 -mthumb -O0 -g -Wall -ffreestanding -nostdlib
LDFLAGS := -T stm32f103.ld -Wl,--gc-sections

# Nguồn C/ASM
SRCS_C  := main.c
SRCS_S  := startup_stm32f103xb.s

# Danh sách object
OBJS    := $(SRCS_C:.c=.o) $(SRCS_S:.s=.o)

# Mặc định build file .bin
all: $(TARGET).bin

# Biên dịch file C -> .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Biên dịch file ASM -> .o
%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

# Link ra ELF
$(TARGET).elf: $(OBJS) stm32f103.ld
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) -A -d $@

# Tạo .bin từ .elf
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Flash vào Blue Pill (ST-Link + OpenOCD)
flash: $(TARGET).bin
	"D:\\xpack-openocd-0.12.0-6\\bin\\openocd.exe" -f interface/stlink.cfg -f target/stm32f1x.cfg \
		-c "program $(TARGET).bin 0x08000000 verify reset exit"

# Xóa file tạm
clean:
	rm -f *.o *.elf *.bin

.PHONY: all clean flash
