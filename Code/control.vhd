-------------------------------------------------------------------------------
--
-- Title       : Control
-- Design      : control
-- Author      : Ishabul Haque 
-- Company     : 
-------------------------------------------------------------------------------
-- Description : Helps with instruction control in each stage of the pipeline 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ControlUnit is
port(
    inst : in std_logic_vector(24 downto 0);
    
    control : out std_logic_vector(4 downto 0);
    write_en : out std_logic;
    immediate : out std_logic_vector(15 downto 0);
    loadIndex : out std_logic_vector(3 downto 0)
);
end ControlUnit;

architecture behavioral of ControlUnit is
signal instType : std_logic_vector(1 downto 0);
signal three_bitOP : std_logic_vector(2 downto 0);
signal four_bitOP : std_logic_vector(3 downto 0);

begin

instType <= inst(24 downto 23);
three_bitOP <= inst(22 downto 20);
four_bitOP <= inst(18 downto 15);

process(inst, instType, three_bitOP, four_bitOP)
begin    
    immediate <= inst(20 downto 5);
    loadIndex <= "1000";
    if (inst = "0000000000000000000000000") then    
        control <= "00000";
        write_en <= '0';
    elsif instType(1) = '0' then
        control <= "00000";        
        loadIndex <= '0' & inst(23 downto 21);
        write_en <= '1';    
    elsif instType = "10" then
        write_en <= '1';
        case three_bitOP is
        when "000" => control <= "00001";
        when "001" => control <= "00010";
        when "010" => control <= "00011";
        when "011" => control <= "00100";
        when "100" => control <= "00101";
        when "101" => control <= "00110";
        when "110" => control <= "00111";
        when "111" => control <= "01000";
        when others => null;
        end case;
    
    elsif instType = "11" then
        write_en <= '1';
        case four_bitOP is
        when "0000" =>			  --NOP
            control <= "01001";
            write_en <= '0';
        when "0001" => control <= "01010";
        when "0010" => control <= "01011";
        when "0011" => control <= "01100";
        when "0100" => control <= "01101";
        when "0101" => control <= "01110";
        when "0110" => control <= "01111";
        when "0111" => control <= "10000";
        when "1000" => control <= "10001";
        when "1001" => control <= "10010";
        when "1010" => control <= "10011";
        when "1011" => control <= "10100";
        when "1100" => control <= "10101";
        when "1101" => control <= "10110";
        when "1110" => control <= "10111";
        when "1111" => control <= "11000";
        when others => null;
        end case;
    end if;
end process;
end behavioral;