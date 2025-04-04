// *********** Includes *********** //
#include "Driver_GPIO.h"
#include "platform.h"
#include "uart.h"
#include <stdio.h>

extern AE350_DRIVER_GPIO Driver_GPIO;

void gpio_callback(uint32_t event)
{
}

// this depends on loop cycle count
// only for test
void delay_ms(uint32_t milliseconds) {
    uint32_t iterations = ( CPUFREQ / 1000) / 12; // Adjust 4 for approximate loop cycle count
    for (uint32_t ms = 0; ms < milliseconds; ms++) {
        for (volatile uint32_t i = 0; i < iterations; i++) {
        }
    }
}


// Main function entry
int main(void)
{
    AE350_DRIVER_GPIO *GPIO_Dri = &Driver_GPIO;
    uart_init(9600);
    printf("Hello World\n");
    GPIO_Dri->Initialize(gpio_callback);
    GPIO_Dri->SetDir(0b11,AE350_GPIO_DIR_OUTPUT);
    GPIO_Dri->SetDir(0b1100,AE350_GPIO_DIR_INPUT);
    int val = 0;
    int val1 = 0;
    int val2 = 0;
    while (1)
    {
        for (int i=0;i<2;i++){
            GPIO_Dri->PinWrite(i,val);
        }
        delay_ms(1000);
        if (val) val = 0; else val = 1;
        // instead of mask we provide pin num
        // what a inconsistency
        val1 = GPIO_Dri->PinRead(2);
        val2 = GPIO_Dri->PinRead(3);
        printf("Button1 %d Button2 %d\n", val1, val2);

    }
    printf("Done");
	return 0;
}

