library ieee;
use ieee.std_logic_1164.all;

package palette is
    type colors is array (natural range <>) of std_logic_vector(23 downto 0);
    constant palette_0 : colors;
    constant palette_1 : colors;
end package;

package body palette is

-- https://www.retrotechy.co.uk/2020/09/lunchtime-coder-1-zx-spectrum-16k-or.html
constant palette_0 : colors := (
    x"000000",
    x"0000D7",
    x"D70000",
    x"D700D7",
    x"00D700",
    x"00D7D7",
    x"D7D700",
    x"D7D7D7"
);

constant palette_1 : colors := (
    x"000000",
    x"0000FF",
    x"FF0000",
    x"FF00FF",
    x"00FF00",
    x"00FFFF",
    x"FFFF00",
    x"FFFFFF"
);



end palette;