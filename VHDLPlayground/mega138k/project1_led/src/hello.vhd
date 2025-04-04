entity hello is
port (
   A: in bit;
   B: in bit;
   C: out bit
     );
end hello;

architecture basic of hello is
begin
	C <= not (A or B);
end basic;
