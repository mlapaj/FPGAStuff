library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    --use work.hello.all;
entity hello_tb is
end entity;

architecture basic of hello_tb is
    signal tb_A,tb_B,tb_C: bit;

    component hello is
	    port (
			 A: in bit;
			 B: in bit;
			 C: out bit
		 );
    end component ;

begin
    fifo: hello port map
    (
        A  => tb_A,
        B  => tb_B,
        C  => tb_C
    );
process begin
    tb_A <= '0';
    tb_B <= '0';
    wait for 10 us;
    tb_A <= '1';
    wait for 10 us;
    tb_B <= '1';
    wait for 10 us;
end process;

end architecture;
