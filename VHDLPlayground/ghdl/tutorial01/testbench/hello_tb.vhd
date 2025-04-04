library ieee;
use ieee.std_logic_1164.all;
entity hello_tb is
end hello_tb;

architecture test of hello_tb is
    component hello is
        port (
        A: in std_logic;
        B: in std_logic;
        C: out std_logic);
    end component;

    signal TB_A: std_logic;
    signal TB_B: std_logic;
    signal TB_C: std_logic;

begin
    dut: hello port map (TB_A, TB_B, TB_C);
    process
    begin
        TB_A <= '1';
        TB_B <= '1';
        wait for 5 ns;
        assert TB_C = '1' report "1 and 1 should give 1" severity warning;
        TB_B <= '0';
        wait for 5 ns;
        assert TB_C = '0' report "1 and 0 should give 0" severity warning;
        TB_A <= '0';
        wait for 5 ns;
        assert TB_C = '0' report "0 and 0 should give 0" severity warning;
        TB_A <= '1';
        TB_B <= '1';
        wait for 5 ns;
        assert TB_C = '1' report "1 and 1 should give 1" severity warning;
        wait;
    end process;
end;
