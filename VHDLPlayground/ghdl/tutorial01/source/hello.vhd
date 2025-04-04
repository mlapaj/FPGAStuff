-- deklarujemy uzycie wymaganych bibliotek
library ieee;
use ieee.std_logic_1164.all;

entity hello is
    port 
	 (
	      A: in std_logic;
	      B: in std_logic;
		  C: out std_logic
	 );
end hello;

-- logika
architecture basic of hello is

begin
    C <= A and B;
end basic;
