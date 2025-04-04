entity nand_gate is
port (
   A: in bit;
   B: in bit;
   C: out bit
     );
end nand_gate;

architecture basic of nand_gate is
begin
    C <= not (A and B);
end basic;