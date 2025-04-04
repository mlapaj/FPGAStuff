library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ula is
  port (
    -- Reset --
    rstn_i: in std_logic;
    -- Input clock --
    clk_i: in std_logic;

    -- Output Z80 clock --
    clk_cpu_o: out std_logic;

	-- access to ram
	mem_mreqn_o: out std_logic;
	mem_rd_o:    out std_logic;
	mem_wr_o:    out std_logic;
	mem_addr_o:  out std_logic_vector(15 downto 0);
	mem_data_o:  out std_logic_vector(7 downto 0);
	mem_data_i:  in std_logic_vector(7 downto 0);

    -- cpu to ram
    cpu_mreqn_i: in std_logic;
    cpu_rd_i:    in std_logic;
    cpu_wr_i:    in std_logic;
    cpu_addr_i:  in std_logic_vector(15 downto 0);
    cpu_data_i:  in std_logic_vector(7 downto 0);
    cpu_data_o:  out std_logic_vector(7 downto 0);

    -- cpu to video
    vid_rd_i:    in std_logic;
    vid_addr_i:  in std_logic_vector(15 downto 0);
    vid_data_o:  out std_logic_vector(7 downto 0)

  );
end entity;

architecture basic of ula is
		signal video_process : std_logic := '0';
begin

	video_process <= '1'         when vid_rd_i = '0' else '0';
    -- video has no mreqn, use vid_rd_i instead
	mem_mreqn_o   <= vid_rd_i when video_process='1' else cpu_mreqn_i;
	mem_rd_o      <= vid_rd_i    when video_process='1' else cpu_rd_i;
    -- write not used for video set to active high
    mem_wr_o      <= '1'    when video_process='1' else cpu_wr_i;
	mem_addr_o    <= vid_addr_i  when video_process='1' else cpu_addr_i;
    mem_data_o    <=  cpu_data_i; -- vide is just for reading, write is not used
	vid_data_o    <= mem_data_i  when video_process='1' else "00000000";
	cpu_data_o    <= mem_data_i  when video_process='0' else "00000000";
	process (clk_i)
		variable cnt : integer range  0 to 3;
	begin
		-- rising or falling
		if (rstn_i = '0') then
			cnt := 0;
			clk_cpu_o <= '0';
		else
			if ((rising_edge(clk_i)) and (video_process = '0')) then
				if (cnt < 3) then
					cnt := cnt + 1;
				else
					cnt := 0;
					clk_cpu_o <= not clk_cpu_o;
				end if;
			end if;
		end if;
	end process;
end;
