--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.11
--Part Number: GW5AST-LV138PG484AC1/I0
--Device: GW5AST-138
--Device Version: B
--Created Time: Mon Jan 13 09:18:31 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component Gowin_PLL
    port (
        clkout0: out std_logic;
        clkout1: out std_logic;
        clkout2: out std_logic;
        clkout3: out std_logic;
        clkout4: out std_logic;
        clkin: in std_logic;
        enclk0: in std_logic;
        enclk1: in std_logic;
        enclk2: in std_logic;
        enclk3: in std_logic;
        enclk4: in std_logic
    );
end component;

your_instance_name: Gowin_PLL
    port map (
        clkout0 => clkout0,
        clkout1 => clkout1,
        clkout2 => clkout2,
        clkout3 => clkout3,
        clkout4 => clkout4,
        clkin => clkin,
        enclk0 => enclk0,
        enclk1 => enclk1,
        enclk2 => enclk2,
        enclk3 => enclk3,
        enclk4 => enclk4
    );

----------Copy end-------------------
