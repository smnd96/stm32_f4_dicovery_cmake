cmake_minimum_required(VERSION 3.15.3)

project(STM32F407VG-DISC0)

enable_language(C ASM)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(STM32CUBEMX_GENERATED_FILES

        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_hcd.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_ll_usb.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_i2c.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_i2c_ex.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_i2s.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_i2s_ex.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_spi.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c
        Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c

        Middlewares/ST/STM32_USB_Host_Library/Core/Src/usbh_core.c
        Middlewares/ST/STM32_USB_Host_Library/Core/Src/usbh_ctlreq.c
        Middlewares/ST/STM32_USB_Host_Library/Core/Src/usbh_ioreq.c
        Middlewares/ST/STM32_USB_Host_Library/Core/Src/usbh_pipes.c
        Middlewares/ST/STM32_USB_Host_Library/Class/CDC/Src/usbh_cdc.c

        Inc/main.h
        Inc/stm32f4xx_hal_conf.h
        Inc/stm32f4xx_it.h
        Inc/usb_host.h
        Inc/usbh_conf.h
        Inc/usbh_platform.h

        Middlewares/ST/STM32_USB_Host_Library/Core/Inc/usbh_core.h
        Middlewares/ST/STM32_USB_Host_Library/Core/Inc/usbh_ctlreq.h
        Middlewares/ST/STM32_USB_Host_Library/Core/Inc/usbh_ioreq.h
        Middlewares/ST/STM32_USB_Host_Library/Core/Inc/usbh_pipes.h
        Middlewares/ST/STM32_USB_Host_Library/Class/CDC/Inc/usbh_cdc.h

        Src/main.c
        Src/usb_host.c
        Src/usbh_conf.c
        Src/usbh_platform.c
        Src/stm32f4xx_it.c
        Src/stm32f4xx_hal_msp.c
        Src/system_stm32f4xx.c

        startup_stm32f407xx.s)

set(EXECUTABLE ${PROJECT_NAME}.out)

add_executable(${EXECUTABLE} ${STM32CUBEMX_GENERATED_FILES})

target_compile_definitions(${EXECUTABLE} PRIVATE
        -DUSE_HAL_DRIVER
        -DSTM32F407xx
        )

target_include_directories(${EXECUTABLE} PRIVATE
        Inc
        Drivers/STM32F4xx_HAL_Driver/Inc
        Drivers/CMSIS/Device/ST/STM32F4xx/Include
        Drivers/CMSIS/Include
        Middlewares/ST/STM32_USB_Host_Library/Core/Inc
        Middlewares/ST/STM32_USB_Host_Library/Class/CDC/Inc/
        )

target_compile_options(${EXECUTABLE} PRIVATE
        -mcpu=cortex-m4
        -mthumb
        -mfpu=fpv4-sp-d16
        -mfloat-abi=hard

        -fdata-sections
        -ffunction-sections

        -Wall

        $<$<CONFIG:Debug>:-Og>
        )

target_link_options(${EXECUTABLE} PRIVATE
        -T${CMAKE_SOURCE_DIR}/STM32F407VGTx_FLASH.ld
        -mcpu=cortex-m4
        -mthumb
        -mfpu=fpv4-sp-d16
        -mfloat-abi=hard
        -specs=nano.specs
        -specs=nosys.specs
        -lc
        -lm
        -lnosys
        -Wl,-Map=${PROJECT_NAME}.map,--cref
        -Wl,--gc-sections
        )

# Print executable size
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-size ${EXECUTABLE})

# Create hex file
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${EXECUTABLE} ${PROJECT_NAME}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${EXECUTABLE} ${PROJECT_NAME}.bin)
