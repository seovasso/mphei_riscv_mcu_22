################################################################################
# Пример автоматизированного универсального make-файла
# Реализована автоматическая работа на основе ручного списка исходников
################################################################################

TOOLCHAIN_PREFIX := riscv-none-embed
TOOLCHAIN_COMPILER := gcc
TOOLCHAIN_OBJCOPY := objcopy
TOOLCHAIN_OBJDUMP := objdump
TOOLCHAIN_SIZE := size

################################################################################
# Инициализация
################################################################################

-include ../makefile.init

RM := rm -rf
MD := mkdir -p
LIBS := -lgcc -lc

################################################################################
# Начало настроечной секции (меняется вручную, редко)
################################################################################

S_OBJS_DIR := ./s_objs/

C_OBJS_DIR := ./objs/

################################################################################
# Начало изменяемой вручную секции
################################################################################

# Вводим имя файлов прошивки (без расширения!)
PROJ_NAME := scr1_test_project

# Определяем списки исходников .c и .S
C_SRCS := \
../src/core_scr1/startup_scr1.c \
../src/core_scr1/syscalls.c \
../../../lib/hardware/apbuart/uart.c \
../../../lib/hardware/spictrl/spi.c \
../../../lib/hardware/grgpio/gpio.c \
../../../lib/hardware/gptimer/timer.c \
../../../lib/hardware/i2cmst/i2c.c \
../src/main.c 

S_UPPER_SRCS := \
../src/core_scr1/startup_asm_scr1.S

# Определяем списки дополнительных (готовых) объектных файлов
USER_OBJS :=

################################################################################
# Начало скриптовой (неизменной) секции
################################################################################

# Генерируем пути поиска исходных файлов, убираем дубли
VPATH := $(dir $(C_SRCS)) $(dir $(S_UPPER_SRCS))
VPATH := $(sort $(VPATH))

# Выводим VPATH для контроля
$(info VPATH=$(VPATH))

# Генерируем список выходных путей для команды mkdir
OPATH := '$(C_OBJS_DIR)' '$(S_OBJS_DIR)'

# Генерируем списки объектных файлов
OBJS := $(foreach SRC,$(C_SRCS),$(C_OBJS_DIR)$(notdir $(SRC:.c=.o)))
S_OBJS := $(foreach SRC,$(S_UPPER_SRCS),$(S_OBJS_DIR)$(notdir $(SRC:.S=.o)))

# Выводим списки объектных файлов для контроля
$(info $(OBJS))
$(info $(S_OBJS))

# Генерируем цели
TARGETS_S := $(S_OBJS_DIR)%.o
TARGETS_C := $(C_OBJS_DIR)%.o

# Выводим цели для контроля
$(info $(TARGETS_C))
$(info $(TARGETS_S))

# Генерируем списки d-файлов (пока непонятно, нужно ли)
S_UPPER_DEPS := $(S_OBJS:.o=.d)
C_DEPS := $(OBJS:.o=.d)

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_FLASH += \
$(PROJ_NAME).bin \

SECONDARY_LIST += \
$(PROJ_NAME).lst \

SECONDARY_SIZE += \
$(PROJ_NAME).siz \

# All Target
all: dirs $(PROJ_NAME).elf secondary-outputs

# Tool invocations
$(PROJ_NAME).elf: $(OBJS) $(S_OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GNU RISC-V Cross C Linker'
	$(TOOLCHAIN_PREFIX)-$(TOOLCHAIN_COMPILER) -march=rv32im -mabi=ilp32 -mcmodel=medany -msmall-data-limit=0 -mdiv -O1 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-builtin -msmall-data-limit=0 -fshort-enums -mstrict-align -ffast-math -Wall -Wextra  -g3 -T ../linker/sram.ld -nostartfiles -Xlinker --gc-sections -Wl,-Map,"$(PROJ_NAME).map" -o "$(PROJ_NAME).elf" $(OBJS) $(S_OBJS) $(USER_OBJS)
	$(TOOLCHAIN_PREFIX)-$(TOOLCHAIN_OBJDUMP) -p $(PROJ_NAME).elf
	@echo 'Finished building target: $@'
	@echo ' '

$(TARGETS_S): %.S
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross Assembler'
	$(TOOLCHAIN_PREFIX)-$(TOOLCHAIN_COMPILER) -march=rv32im -mabi=ilp32 -mcmodel=medany -msmall-data-limit=0 -mdiv -O1 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-builtin -msmall-data-limit=0 -fshort-enums -mstrict-align -ffast-math -Wall -Wextra  -g3 -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(TARGETS_C): %.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	$(TOOLCHAIN_PREFIX)-$(TOOLCHAIN_COMPILER) -march=rv32im -mabi=ilp32 -mcmodel=medany -msmall-data-limit=0 -mdiv -O1 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-builtin -msmall-data-limit=0 -fshort-enums -mstrict-align -ffast-math -Wall -Wextra  -g3 -I"..\..\..\lib" -I"..\..\..\lib\hardware" -I"..\src" -std=gnu11 -mstrict-align -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(PROJ_NAME).bin: $(PROJ_NAME).elf
	@echo 'Invoking: GNU RISC-V Cross Create Flash Image'
	$(TOOLCHAIN_PREFIX)-$(TOOLCHAIN_OBJCOPY) -O binary "$(PROJ_NAME).elf"  "$(PROJ_NAME).bin"
	@echo 'Finished building: $@'
	@echo ' '

$(PROJ_NAME).lst: $(PROJ_NAME).elf
	@echo 'Invoking: GNU RISC-V Cross Create Listing'
	$(TOOLCHAIN_PREFIX)-$(TOOLCHAIN_OBJDUMP) --source --all-headers --demangle --line-numbers --wide "$(PROJ_NAME).elf" > "$(PROJ_NAME).lst"
	@echo 'Finished building: $@'
	@echo ' '

$(PROJ_NAME).siz: $(PROJ_NAME).elf
	@echo 'Invoking: GNU RISC-V Cross Print Size'
	$(TOOLCHAIN_PREFIX)-$(TOOLCHAIN_SIZE) --format=berkeley "$(PROJ_NAME).elf"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(CC_DEPS) $(C++_DEPS) $(OBJS) $(S_OBJS) $(C_UPPER_DEPS) $(CXX_DEPS) $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE) $(ASM_DEPS) $(S_UPPER_DEPS) $(C_DEPS) $(CPP_DEPS) $(PROJ_NAME).elf $(PROJ_NAME).bin $(PROJ_NAME).lst $(PROJ_NAME).siz $(PROJ_NAME).map
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE)

dirs:
	@echo 'Creating folders...'
	-$(MD) $(OPATH)
	@echo 'Done'
	
	
.PHONY: all clean dependents dirs

-include ../makefile.targets
