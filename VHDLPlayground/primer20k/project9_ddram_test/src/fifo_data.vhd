library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fifo_data is
    type byte_array_type is array (integer range 64 downto 0) of std_logic_vector (7 downto 0);
    function to_array( s : string ) return byte_array_type;
    function my_to_hex_string(s: in std_logic_vector) return string;
end package;

package body fifo_data is

    function to_array( s : string )
	return byte_array_type
	is
		variable r : byte_array_type;
	begin
        r := (others => (others => '0'));
		for i in 1 to s'length loop
			r(i-1) := std_logic_vector(to_unsigned(character'pos(s(i)),8)); -- s(i);
		end loop ;
		return r ;
	end function ;

    function my_to_hex_string(s: in std_logic_vector)
    return string
    is
        --- Locals to make the indexing easier
        constant s_norm: std_logic_vector(4 to s'length-3) := s;
        variable result: string (1 to s'length/4);
        --- A subtype to keep the VHDL compiler happy
        --- (the rules about data types in a CASE are quite strict)
        subtype slv4 is std_logic_vector(1 to 4);
    begin
        assert (s'length mod 4) = 0
        report "SLV must be a multiple of 4 bits"
        severity FAILURE;
        for i in result'range loop
            case slv4'(s_norm(i*4 to i*4+3)) is
                when "0000" => result(i) := '0';
                when "0001" => result(i) := '1';
                when "0010" => result(i) := '2';
                when "0011" => result(i) := '3';
                when "0100" => result(i) := '4';
                when "0101" => result(i) := '5';
                when "0110" => result(i) := '6';
                when "0111" => result(i) := '7';
                when "1000" => result(i) := '8';
                when "1001" => result(i) := '9';
                when "1010" => result(i) := 'A';
                when "1011" => result(i) := 'B';
                when "1100" => result(i) := 'C';
                when "1101" => result(i) := 'D';
                when "1110" => result(i) := 'E';
                when "1111" => result(i) := 'F';
                when others => result(i) := 'x';
            end case;
        end loop;
        return result;
    end function;


end package body fifo_data;
