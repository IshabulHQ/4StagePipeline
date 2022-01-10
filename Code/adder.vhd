

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity adder is
    generic( DWIDTH : integer := 16 );
    port( A : in std_logic_vector( DWIDTH-1 downto 0 );
          B : in std_logic_vector( DWIDTH-1 downto 0 );
          D : out std_logic_vector( DWIDTH-1 downto 0 )
    );
end adder;

-- adder Architecture Description
architecture behavioral of adder is
begin
    
    D <= A + B;
    
end behavioral;
