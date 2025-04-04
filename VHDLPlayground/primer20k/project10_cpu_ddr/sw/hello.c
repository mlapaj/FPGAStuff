#include <neorv32.h>


/**********************************************************************//**
 * @name User configuration
 **************************************************************************/
/**@{*/
/** UART BAUD rate */
#define BAUD_RATE 19200
/**@}*/



/**********************************************************************//**
 * Main function; prints some fancy stuff via UART.
 *
 * @note This program requires the UART interface to be synthesized.
 *
 * @return 0 if execution was successful
 **************************************************************************/
int main() {

  // capture all exceptions and give debug info via UART
  // this is not required, but keeps us safe
  neorv32_rte_setup();

  // setup UART at default baud rate, no interrupts
  neorv32_uart0_setup(BAUD_RATE, 0);

  // check available hardware extensions and compare with compiler flags
  neorv32_rte_check_isa(0); // silent = 0 -> show message if isa mismatch

  // print project logo via UART
  neorv32_rte_print_logo();

  // say hello
  neorv32_uart0_puts("Hello world! :)\n");
  int j = 0;
  while (1){
      //neorv32_uart_getc(NEORV32_UART0);
      //neorv32_uart_puts(NEORV32_UART0,"Pressed a key! :)\n");
      neorv32_gpio_port_set(0x0);
      //neorv32_uart_getc(NEORV32_UART0);
      int i = 0;
      void *x  = (void *) 0xC000;
      //neorv32_uart_printf(NEORV32_UART0,"write:\n");
      for (i = 0; i < 20; i=i+1){ 

          int inv = (i % 2);
          if (inv){
              ((unsigned int *) x)[i] = i+j; 
              //neorv32_uart_printf(NEORV32_UART0,"%x ", i+j);
          }else
          {
              ((unsigned int *) x)[i] = ~(i+j); 
          //neorv32_uart_printf(NEORV32_UART0,"%x ", ~(i+j));
          }
      } 
      //neorv32_uart_printf(NEORV32_UART0,"\n");

      //neorv32_uart_printf(NEORV32_UART0,"dump:\n");
      for (i = 0; i < 20; i=i+1){
          //neorv32_uart_printf(NEORV32_UART0,"%x ", ((unsigned int *) x)[i]);
#if 1
          int test = 0;
          int inv = (i % 2);
          if (inv){
              test = ((unsigned int *) x)[i] != i+j;
          }
          else
          {
              test = ((unsigned int *) x)[i] != ~(i+j);
          }
          if (test)
          {
              neorv32_uart_printf(NEORV32_UART0,"err %x ", ((unsigned int *) x)[i]);
              while (1) ;
          }
#endif
      }
      //neorv32_uart_printf(NEORV32_UART0,"\n");
      neorv32_gpio_port_set(0xF);
      j=j+1;
      if (j > 1024) j = 0;
  }
  return 0;
}
