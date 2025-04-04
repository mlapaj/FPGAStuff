--Copyright (C)2014-2022 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--GOWIN Version: V1.9.8.09 Education
--Part Number: GW2A-LV18PG256C8/I7
--Device: GW2A-18C
--Created Time: Thu Apr 13 12:07:51 2023

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component ML_PLL
    port (
        clkout: out std_logic;
        clkin: in std_logic
    );
end component;

your_instance_name: ML_PLL
    port map (
        clkout => clkout_o,
        clkin => clkin_i
    );

----------Copy end-------------------
