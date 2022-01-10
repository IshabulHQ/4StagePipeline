-------------------------------------------------------------------------------
--
-- Title       : Instruction Buffer
-- Design      : instBuff
-- Author      : Ishabul Haque 
-- Company     : 
-------------------------------------------------------------------------------
-- Description : The instruction buffer can store 64 25-bit instructions. On each cycle, 
-- the instruction specified by the Program Counter (PC) is fetched, and the 
-- value of PC is incremented by 1.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstBuffer is
port(
    clk : in std_logic;
    
    wr_en : in std_logic;
    inst_in : in std_logic_vector(24 downto 0);
    
    addr : in std_logic_vector(5 downto 0);
    inst_out : out std_logic_vector(24 downto 0)
);
end InstBuffer;

architecture behavioral of InstBuffer is
type arr is array (0 to 63) of bit_vector(24 downto 0);
signal buff : arr;
signal PC : integer := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
        if(wr_en = '1') then
            buff(PC) <= to_bitvector(inst_in);
            
            if(PC = 63) then
                PC <= 0;
            else
                PC <= PC + 1;
            end if;
        end if;        
    end if;
    end process;
    
    inst_out <= to_stdlogicvector(buff(to_integer(unsigned(addr))));
end behavioral;