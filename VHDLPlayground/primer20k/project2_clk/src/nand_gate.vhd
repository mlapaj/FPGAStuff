library IEEE;
use ieee.std_logic_1164.all;

entity nand_gate is
port (
   CLK: in std_logic;
   CLKOUT: out std_logic
     );
end nand_gate;

architecture basic of nand_gate is
component ML_PLL
    port (
        clkout: out std_logic;
        clkin: in std_logic
    );
end component;

begin

    PLL0: ML_PLL
        port map (
            clkout => CLKOUT,
            clkin => CLK
        );

end basic;