--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.11
--Part Number: GW5AST-LV138PG484AC1/I0
--Device: GW5AST-138
--Device Version: B
--Created Time: Mon Jan 13 10:08:03 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component Gowin_PLL_DDR3
    port (
        lock: out std_logic;
        clkout0: out std_logic;
        clkout2: out std_logic;
        clkin: in std_logic;
        reset: in std_logic;
        enclk0: in std_logic;
        enclk2: in std_logic
    );
end component;

your_instance_name: Gowin_PLL_DDR3
    port map (
        lock => lock,
        clkout0 => clkout0,
        clkout2 => clkout2,
        clkin => clkin,
        reset => reset,
        enclk0 => enclk0,
        enclk2 => enclk2
    );

----------Copy end-------------------
