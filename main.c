    #include <stdio.h>
    #include <stdint.h>

    // #define RCC_APB2ENR    *((volatile unsigned int*)0x40021018)
    // #define GPIOC_CRH      *((volatile unsigned int*)0x40011004)
    // #define GPIOC_ODR      *((volatile unsigned int*)0x4001100C)

    #define RCC            ((volatile RCC_TypeDef*)0x40021000)
    #define GPIOC          ((volatile GPIO_TypeDef*)0x40011000)
    #define GPIOA          ((volatile GPIO_TypeDef*)0x40010800)

    typedef struct
    {
        volatile  unsigned int CRL;   // Port configuration register low (pin 0..7)
        volatile  unsigned int CRH;   // Port configuration register high (pin 8..15)
        volatile  unsigned int IDR;   // Input data register
        volatile  unsigned int ODR;   // Output data register
        volatile  unsigned int BSRR;  // Bit set/reset register
        volatile  unsigned int BRR;   // Bit reset register
        volatile  unsigned int LCKR;  // Port configuration lock register
    } GPIO_TypeDef;

    typedef struct
    {
    volatile unsigned int CR;        // Clock control register
    volatile unsigned int CFGR;      // Clock configuration register
    volatile unsigned int CIR;       // Clock interrupt register
    volatile unsigned int APB2RSTR;  // APB2 peripheral reset register
    volatile unsigned int APB1RSTR;  // APB1 peripheral reset register
    volatile unsigned int AHBENR;    // AHB peripheral clock enable register
    volatile unsigned int APB2ENR;   // APB2 peripheral clock enable register
    volatile unsigned int APB1ENR;   // APB1 peripheral clock enable register
    volatile unsigned int BDCR;      // Backup domain control register
    volatile unsigned int CSR;       // Control/status register
    } RCC_TypeDef;



    void delay( uint32_t timedelay )
    {
        for( uint32_t i =0;i<timedelay;i++);
    }
    void config()
    {
        RCC->APB2ENR |=((1<<4) |(1<<2));
            
        // PC13 (Output push-pull)
        GPIOC->CRH &= ~(0xF << 20);   // clear config for PC13
        GPIOC->CRH |=  (0x2 << 20);   // MODE13 = 10 (output 2MHz)
        GPIOC->CRH &= ~(0xC << 20);   // CNF13 = 00 (push-pull)
        
        //PA0
        GPIOA->CRL &= ~(0xF << 0);   // clear bits for PA0
        GPIOA->CRL |=  (0x8 << 0);   // CNF0 = 10, MODE0 = 00
        GPIOA->ODR |=(0x01<<0);

    }
    void Writepin(volatile GPIO_TypeDef *gpio, uint16_t pin,uint8_t mode)
    {
        if(mode ==0){
            gpio->ODR &=~(1<<pin);
        }else{
            gpio->ODR |=(1<<pin);
        }
        
    }
    int main( int argc, const char *argv)
    {
        config();

        while (1) {
            if ((GPIOA->IDR & (1<<0)) == 0) {  
                Writepin(GPIOC, 13, 0);  
                delay(50000);
                Writepin(GPIOC, 13, 1);  
                delay(50000);
            } else {
                Writepin(GPIOC, 13, 1);  
            }
        }
        return 0;
    }