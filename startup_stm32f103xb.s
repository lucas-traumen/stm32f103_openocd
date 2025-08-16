    /* startup_stm32f103.s
       Template startup file cho STM32F1 (Cortex-M3) - GNU Assembler (GAS)
       - Vector table ở .isr_vector (sẽ được map vào 0x08000000 qua linker script)
       - Reset_Handler copy .data, clear .bss, gọi SystemInit rồi main
       - Handlers mặc định trỏ về Default_Handler (vòng lặp vô hạn)
    */

    .syntax unified
    .cpu cortex-m3
    .thumb

/* ------------------ Vector table section ------------------ */
    .section .isr_vector,"a",%progbits
    .align  2
    .type   g_pfnVectors, %object
g_pfnVectors:
    .word   _estack                 /* 0x00: Initial Stack Pointer */
    .word   Reset_Handler           /* 0x04: Reset Handler */
    .word   NMI_Handler             /* 0x08: NMI Handler */
    .word   HardFault_Handler       /* 0x0C: HardFault Handler */
    .word   MemManage_Handler       /* 0x10: MemManage Handler */
    .word   BusFault_Handler        /* 0x14: BusFault Handler */
    .word   UsageFault_Handler      /* 0x18: UsageFault Handler */
    .word   0                       /* 0x1C: Reserved */
    .word   0                       /* 0x20: Reserved */
    .word   0                       /* 0x24: Reserved */
    .word   0                       /* 0x28: Reserved */
    .word   SVC_Handler             /* 0x2C: SVCall */
    .word   DebugMon_Handler        /* 0x30: Debug Monitor */
    .word   0                       /* 0x34: Reserved */
    .word   PendSV_Handler          /* 0x38: PendSV */
    .word   SysTick_Handler         /* 0x3C: SysTick */

    /* External Interrupts (IRQ) - thứ tự theo device STM32F1 series */
    .word   WWDG_IRQHandler             /* Window Watchdog */
    .word   PVD_IRQHandler              /* PVD through EXTI line detection */
    .word   TAMPER_IRQHandler           /* Tamper */
    .word   RTC_IRQHandler              /* RTC */
    .word   FLASH_IRQHandler            /* Flash */
    .word   RCC_IRQHandler              /* RCC */
    .word   EXTI0_IRQHandler            /* EXTI Line0 */
    .word   EXTI1_IRQHandler            /* EXTI Line1 */
    .word   EXTI2_IRQHandler            /* EXTI Line2 */
    .word   EXTI3_IRQHandler            /* EXTI Line3 */
    .word   EXTI4_IRQHandler            /* EXTI Line4 */
    .word   DMA1_Channel1_IRQHandler
    .word   DMA1_Channel2_IRQHandler
    .word   DMA1_Channel3_IRQHandler
    .word   DMA1_Channel4_IRQHandler
    .word   DMA1_Channel5_IRQHandler
    .word   DMA1_Channel6_IRQHandler
    .word   DMA1_Channel7_IRQHandler
    .word   ADC1_2_IRQHandler
    .word   USB_HP_CAN_TX_IRQHandler
    .word   USB_LP_CAN_RX0_IRQHandler
    .word   CAN_RX1_IRQHandler
    .word   CAN_SCE_IRQHandler
    .word   EXTI9_5_IRQHandler
    .word   TIM1_BRK_IRQHandler
    .word   TIM1_UP_IRQHandler
    .word   TIM1_TRG_COM_IRQHandler
    .word   TIM1_CC_IRQHandler
    .word   TIM2_IRQHandler
    .word   TIM3_IRQHandler
    .word   TIM4_IRQHandler
    .word   I2C1_EV_IRQHandler
    .word   I2C1_ER_IRQHandler
    .word   I2C2_EV_IRQHandler
    .word   I2C2_ER_IRQHandler
    .word   SPI1_IRQHandler
    .word   SPI2_IRQHandler
    .word   USART1_IRQHandler
    .word   USART2_IRQHandler
    .word   USART3_IRQHandler
    .word   EXTI15_10_IRQHandler
    .word   RTC_Alarm_IRQHandler
    .word   USBWakeUp_IRQHandler
    /* Nếu device có thêm IRQ khác thì tiếp tục ở đây... */

    .size g_pfnVectors, .-g_pfnVectors

/* ------------------ Weak aliases cho tất cả handlers ------------------ */
/* Khai báo các handler là weak và map mặc định về Default_Handler */
    .section .text.handlers,"ax",%progbits
    .align 2

    /* Core exceptions */
    .weak   NMI_Handler
    .weak   HardFault_Handler
    .weak   MemManage_Handler
    .weak   BusFault_Handler
    .weak   UsageFault_Handler
    .weak   SVC_Handler
    .weak   DebugMon_Handler
    .weak   PendSV_Handler
    .weak   SysTick_Handler

    /* External IRQs (weak declarations) */
    .weak   WWDG_IRQHandler
    .weak   PVD_IRQHandler
    .weak   TAMPER_IRQHandler
    .weak   RTC_IRQHandler
    .weak   FLASH_IRQHandler
    .weak   RCC_IRQHandler
    .weak   EXTI0_IRQHandler
    .weak   EXTI1_IRQHandler
    .weak   EXTI2_IRQHandler
    .weak   EXTI3_IRQHandler
    .weak   EXTI4_IRQHandler
    .weak   DMA1_Channel1_IRQHandler
    .weak   DMA1_Channel2_IRQHandler
    .weak   DMA1_Channel3_IRQHandler
    .weak   DMA1_Channel4_IRQHandler
    .weak   DMA1_Channel5_IRQHandler
    .weak   DMA1_Channel6_IRQHandler
    .weak   DMA1_Channel7_IRQHandler
    .weak   ADC1_2_IRQHandler
    .weak   USB_HP_CAN_TX_IRQHandler
    .weak   USB_LP_CAN_RX0_IRQHandler
    .weak   CAN_RX1_IRQHandler
    .weak   CAN_SCE_IRQHandler
    .weak   EXTI9_5_IRQHandler
    .weak   TIM1_BRK_IRQHandler
    .weak   TIM1_UP_IRQHandler
    .weak   TIM1_TRG_COM_IRQHandler
    .weak   TIM1_CC_IRQHandler
    .weak   TIM2_IRQHandler
    .weak   TIM3_IRQHandler
    .weak   TIM4_IRQHandler
    .weak   I2C1_EV_IRQHandler
    .weak   I2C1_ER_IRQHandler
    .weak   I2C2_EV_IRQHandler
    .weak   I2C2_ER_IRQHandler
    .weak   SPI1_IRQHandler
    .weak   SPI2_IRQHandler
    .weak   USART1_IRQHandler
    .weak   USART2_IRQHandler
    .weak   USART3_IRQHandler
    .weak   EXTI15_10_IRQHandler
    .weak   RTC_Alarm_IRQHandler
    .weak   USBWakeUp_IRQHandler

    /* Map tất cả các weak handlers về Default_Handler (nếu assembler hỗ trợ thumb_set) */
    .thumb_set NMI_Handler, Default_Handler
    .thumb_set HardFault_Handler, Default_Handler
    .thumb_set MemManage_Handler, Default_Handler
    .thumb_set BusFault_Handler, Default_Handler
    .thumb_set UsageFault_Handler, Default_Handler
    .thumb_set SVC_Handler, Default_Handler
    .thumb_set DebugMon_Handler, Default_Handler
    .thumb_set PendSV_Handler, Default_Handler
    .thumb_set SysTick_Handler, Default_Handler

    .thumb_set WWDG_IRQHandler, Default_Handler
    .thumb_set PVD_IRQHandler, Default_Handler
    .thumb_set TAMPER_IRQHandler, Default_Handler
    .thumb_set RTC_IRQHandler, Default_Handler
    .thumb_set FLASH_IRQHandler, Default_Handler
    .thumb_set RCC_IRQHandler, Default_Handler
    .thumb_set EXTI0_IRQHandler, Default_Handler
    .thumb_set EXTI1_IRQHandler, Default_Handler
    .thumb_set EXTI2_IRQHandler, Default_Handler
    .thumb_set EXTI3_IRQHandler, Default_Handler
    .thumb_set EXTI4_IRQHandler, Default_Handler
    .thumb_set DMA1_Channel1_IRQHandler, Default_Handler
    .thumb_set DMA1_Channel2_IRQHandler, Default_Handler
    .thumb_set DMA1_Channel3_IRQHandler, Default_Handler
    .thumb_set DMA1_Channel4_IRQHandler, Default_Handler
    .thumb_set DMA1_Channel5_IRQHandler, Default_Handler
    .thumb_set DMA1_Channel6_IRQHandler, Default_Handler
    .thumb_set DMA1_Channel7_IRQHandler, Default_Handler
    .thumb_set ADC1_2_IRQHandler, Default_Handler
    .thumb_set USB_HP_CAN_TX_IRQHandler, Default_Handler
    .thumb_set USB_LP_CAN_RX0_IRQHandler, Default_Handler
    .thumb_set CAN_RX1_IRQHandler, Default_Handler
    .thumb_set CAN_SCE_IRQHandler, Default_Handler
    .thumb_set EXTI9_5_IRQHandler, Default_Handler
    .thumb_set TIM1_BRK_IRQHandler, Default_Handler
    .thumb_set TIM1_UP_IRQHandler, Default_Handler
    .thumb_set TIM1_TRG_COM_IRQHandler, Default_Handler
    .thumb_set TIM1_CC_IRQHandler, Default_Handler
    .thumb_set TIM2_IRQHandler, Default_Handler
    .thumb_set TIM3_IRQHandler, Default_Handler
    .thumb_set TIM4_IRQHandler, Default_Handler
    .thumb_set I2C1_EV_IRQHandler, Default_Handler
    .thumb_set I2C1_ER_IRQHandler, Default_Handler
    .thumb_set I2C2_EV_IRQHandler, Default_Handler
    .thumb_set I2C2_ER_IRQHandler, Default_Handler
    .thumb_set SPI1_IRQHandler, Default_Handler
    .thumb_set SPI2_IRQHandler, Default_Handler
    .thumb_set USART1_IRQHandler, Default_Handler
    .thumb_set USART2_IRQHandler, Default_Handler
    .thumb_set USART3_IRQHandler, Default_Handler
    .thumb_set EXTI15_10_IRQHandler, Default_Handler
    .thumb_set RTC_Alarm_IRQHandler, Default_Handler
    .thumb_set USBWakeUp_IRQHandler, Default_Handler

/* ------------------ Reset handler: copy .data, clear .bss, gọi SystemInit & main ------------------ */
    .extern  _sidata    /* start address for the initialization values of the .data section (in flash) */
    .extern  _sdata
    .extern  _edata
    .extern  _sbss
    .extern  _ebss
    .extern  _estack    /* stack top, defined in linker script */

    .extern  SystemInit
    .extern  main

    .global Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
    /* Copy .data từ flash (_sidata) sang RAM ([_sdata .. _edata]) */
    ldr     r0, =_sidata
    ldr     r1, =_sdata
    ldr     r2, =_edata
1:  cmp     r1, r2
    bcs     2f               /* if r1 >= r2 -> done copy */
    ldr     r3, [r0], #4
    str     r3, [r1], #4
    b       1b
2:
    /* Zero .bss (_sbss .. _ebss) */
    ldr     r0, =_sbss
    ldr     r1, =_ebss
    movs    r2, #0
3:  cmp     r0, r1
    bcs     4f               /* if r0 >= r1 -> done zeroing */
    str     r2, [r0], #4
    b       3b
4:
    /* Optionally configure the FPU or other CPU features here (not needed for Cortex-M3) */

    /* Gọi SystemInit (thường khởi tạo clock) nếu có */
   /* bl      SystemInit

    /* Gọi hàm main() */
    bl      main

    /* Nếu main() trả về, loop vô hạn */
hang:
    b       hang

/* ------------------ Default / weak handler: vòng lặp vô hạn ------------------ */
    .global Default_Handler
    .type   Default_Handler, %function
Default_Handler:
    b       Default_Handler

/* End file */
