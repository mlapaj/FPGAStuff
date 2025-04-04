library ieee;
use ieee.std_logic_1164.all;

package image is
    type mem8_t  is array (natural range <>) of std_logic_vector(07 downto 0);
    constant rom_image : mem8_t;
end package;

package body image is


constant rom_image : mem8_t := (
x"ff",
x"00",
x"00",
x"00",
x"00",
x"00",
x"00",
x"00",
x"00"
);

end image;
