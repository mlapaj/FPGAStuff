library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

use work.fifo_data.all;
-- this is not real fifo :-) actually there is a array which will be
-- serialized, maybe in future i`ll improve it
entity fifo_uart is
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
    signal is_buffer_written : std_logic;
    signal tmp_data : byte_array_type;
    signal i : integer range 0 to 63;
end fifo_uart;

architecture basic of fifo_uart is
begin
    process (clock_i)
    begin
        if rising_edge(clock_i) then
            if (reset_n_i = '0') then
                out_valid <= '0';
                is_buffer_written <= '0';
                out_val <= (others => '0');
                i <= 0;
            elsif data_valid = '1' and is_buffer_written = '0' then
                -- copy data
                tmp_data <= data_in;
                out_valid <= '0';
                is_buffer_written <= '1';
                empty_o <= '0';
                i <= 0;
            else
                if is_buffer_written = '1' then
                    if out_ready = '1' or (out_ready = '0' and i = 0) then
                        -- improvement: null terminated string from now
                        if i = 63 or tmp_data(i) = "00000000" then
                            is_buffer_written <= '0';
                            out_valid <= '0';
                            out_val <= (others => '0');
                            empty_o <= '1';
                            i <= 0;
                        else
                            out_val <= tmp_data(i);
                            out_valid <= '1';
                            i <= i + 1;
                        end if;
                    else
                        -- i do not know why it is working without it
                        -- most probably it reads one cycle after another 
                        -- data from out_val and we do not need to wait for
                        -- confirmation from UART to send next byte
                        -- enough is to monitor out_ready from uart
                        --out_valid <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture;
