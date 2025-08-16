#define PERIPH_BASE        0x40000000UL
#define APB2PERIPH_BASE    (PERIPH_BASE + 0x10000)
#define AHBPERIPH_BASE     (PERIPH_BASE + 0x20000)

#define RCC_BASE           (AHBPERIPH_BASE + 0x1000)   // 0x40021000
#define GPIOC_BASE         (APB2PERIPH_BASE + 0x1000)  // 0x40011000

#define RCC_APB2ENR  (*(volatile unsigned int*)(RCC_BASE + 0x18))
#define GPIOC_CRH    (*(volatile unsigned int*)(GPIOC_BASE + 0x04))
#define GPIOC_ODR    (*(volatile unsigned int*)(GPIOC_BASE + 0x0C))

void delay(volatile int t) {
    while (t--) __asm__("nop");
}

int main(void) {
    // Bật clock cho GPIOC
    RCC_APB2ENR |= (1 << 4);

    // Cấu hình PC13 là output push-pull, max 2 MHz
    GPIOC_CRH &= ~(0xF << 20);   // clear CNF13[1:0] + MODE13[1:0]
    GPIOC_CRH |=  (0x2 << 20);   // MODE13 = 10 (Output 2MHz), CNF13 = 00 (Push-pull)

    while (1) {
        GPIOC_ODR &= ~(1 << 13); // LED ON (0 = sáng)
        delay(700000);

        GPIOC_ODR |=  (1 << 13); // LED OFF (1 = tắt)
        delay(100000);
    }
}
