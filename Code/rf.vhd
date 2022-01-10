-------------------------------------------------------------------------------
--
-- Title       : Register File
-- Design      : rf
-- Author      : Ishabul Haque 
-- Company     : 
-------------------------------------------------------------------------------
-- Description : The register file has 32 128-bit registers. On any cycle, 
-- there can be 3 reads and 1 write. When executing instructions, each cycle 
-- two/three 128-bit register values are read, and one
-- 128-bit result can be written if a write signal is valid.
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity RF is
port(
    clk : in std_logic;
    rst : in std_logic;
    index : in std_logic_vector(3 downto 0);
    write_En : in std_logic;
    data : in std_logic_vector(127 downto 0);
    wr_reg : std_logic_vector(4 downto 0);
    rd_reg1: std_logic_vector(4 downto 0);
    rd_reg2: std_logic_vector(4 downto 0);
    rd_reg3: std_logic_vector(4 downto 0);
    rs1 : out std_logic_vector(127 downto 0);
    rs2 : out std_logic_vector(127 downto 0);
    rs3 : out std_logic_vector(127 downto 0)
);
end RF;

architecture behavioral of RF is

type arr is array (0 to 31) of std_logic_vector(127 downto 0);
signal registers : arr := (others => std_logic_vector(to_unsigned(0, 128)));   

begin

rs3 <= data when write_En = '1' and wr_reg = rd_reg3 else registers(to_integer(unsigned(rd_reg3)));
rs2 <= data when write_En = '1' and wr_reg = rd_reg2 else registers(to_integer(unsigned(rd_reg2)));
rs1 <= data when write_En = '1' and wr_reg = rd_reg1 else registers(to_integer(unsigned(rd_reg1)));

process (clk)
	begin
	    if (rising_edge(clk)) then
            if write_En = '1' then                
                case index is
                    when "0111" => --7
                        registers(to_integer(unsigned(wr_reg)))(127 downto 112) <= data(127 downto 112);
                    when "0110" => --6
                        registers(to_integer(unsigned(wr_reg)))(111 downto 96) <= data(111 downto 96);
                    when "0101" => --5
                        registers(to_integer(unsigned(wr_reg)))(79 downto 64) <= data(79 downto 64);
                    when "0100" => --4
                        registers(to_integer(unsigned(wr_reg)))(79 downto 64) <= data(79 downto 64);
                    when "0011" => --3
                        registers(to_integer(unsigned(wr_reg)))(47 downto 32) <= data(47 downto 32);
                    when "0010" => --2
                        registers(to_integer(unsigned(wr_reg)))(47 downto 32) <= data(47 downto 32);
                    when "0001" => --1
                        registers(to_integer(unsigned(wr_reg)))(31 downto 16) <= data(31 downto 16);
                    when "0000" => --0
                        registers(to_integer(unsigned(wr_reg)))(15 downto 0) <= data(15 downto 0);
                    when others => --full 
                        registers(to_integer(unsigned(wr_reg))) <= data;
                end case;
            end if;
		end if;
end process;
end behavioral;