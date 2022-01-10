-------------------------------------------------------------------------------
--
-- Title       : Forwading Unit
-- Design      : Data Forwarding
-- Author      : Ishabul Haque 
-- Company     : 
-------------------------------------------------------------------------------
-- Description : Every instruction must use the most recent value of a register, 
-- even if this value has not yet been written to the Register File. The most
-- recent value should be used, in the event of two consecutive writes to a register, 
-- followed by a read from that same register. Your processor should never stall in 
-- the event of hazards. Only valid data and source/destination registers should be 
-- considered for forwarding.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DataForwarding is
    port( 
        rf_we : in std_logic;
        rf_wr_reg : in std_logic_vector(4 downto 0);        
        
        rs1_reg : in std_logic_vector(4 downto 0);      
        rs2_reg : in std_logic_vector(4 downto 0);      
        rs3_reg : in std_logic_vector(4 downto 0);  
        
        fw1 : out std_logic;
        fw2 : out std_logic;
        fw3 : out std_logic    
    );
end DataForwarding;

architecture Behavioral of DataForwarding is
begin
process (rf_we, rf_wr_reg, rs1_reg, rs2_reg, rs3_reg)
begin
    if (rf_we = '1' and rf_wr_reg = rs1_reg) then
        fw1 <= '1';
    else
        fw1 <= '0';
    end if;
    
    if (rf_we = '1' and rf_wr_reg = rs2_reg) then
        fw2 <= '1';
    else
        fw2 <= '0';
    end if;
            
    if (rf_we = '1' and rf_wr_reg = rs3_reg) then
        fw3 <= '1';
    else
        fw3 <= '0';
    end if;
end process;

end Behavioral;
