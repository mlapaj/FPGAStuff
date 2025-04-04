library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.fifo_data.all;
entity fifo_uart_tb is
end entity;

architecture basic of fifo_uart_tb is
    constant my_msg : String(1 to 4) := "test";
    constant f_clock_c      : natural := 20000000; -- main clock in Hz
    constant t_clock_c      : time := (1 sec) / f_clock_c;
    signal clk_gen, rst_n_gen : std_ulogic := '0';

    component fifo_uart is
    port (
             clock_i:    in  std_logic;
             reset_n_i:  in  std_logic;
             empty_o:    out std_logic;
             data_in:    in  byte_array_type;
             data_valid: in  std_logic;
             out_val:    out std_logic_vector(7 downto 0);
             out_valid:  out std_logic;
             out_ready:  in  std_logic
         );
    end component ;

begin
    --data <= (others => "00000000");
    fifo: fifo_uart port map
    (
        clock_i   => clk_gen,
        reset_n_i => rst_n_gen,
        data_in => to_array("Test"),
        data_valid => '1',
        out_ready => '1'
    );
    clk_gen <= not clk_gen after (t_clock_c/2);
    rst_n_gen <= '0', '1' after 60*(t_clock_c/2);
end architecture;
