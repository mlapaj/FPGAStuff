#include "Driver_GPIO.h"
#include "platform.h"
#include "uart.h"
#include "delay.h"


int printf(const char *format, ...)
{
    return 0;
}

int puts(const char *s)
{
    return 0;
}


int main(){
    char *a = (char *) 0xF0700028;
    uart_init(9600);       // Baudrate is 960

    while (1)
    {
        uart_puts("Hello World\n"); 
        simple_delay_ms(10000);
        *a = ~(*a);

    }


}
