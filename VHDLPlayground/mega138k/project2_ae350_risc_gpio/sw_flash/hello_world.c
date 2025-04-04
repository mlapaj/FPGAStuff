#include "uart.h"
#include <stdio.h>

int main(){
    char *a = (char *) 0xF0700028;
    uart_init(9600);       // Baudrate is 960

    while (1)
    {
        uart_puts("Hello World\n"); 
        printf("To ja andrzej!\n");
        simple_delay_ms(10000);
        *a = ~(*a);

    }


}
