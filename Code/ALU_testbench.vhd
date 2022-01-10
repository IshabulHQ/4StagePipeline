library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity ALU_testbench is
end ALU_testbench;

architecture tb_architecture of ALU_testbench is	 

signal rs1_tb : std_logic_vector(127 downto 0);  
signal rs2_tb : std_logic_vector(127 downto 0); 
signal rs3_tb : std_logic_vector(127 downto 0); 
signal loadIndex_tb : std_logic_vector(2 downto 0);  
signal immediate_tb : std_logic_vector(15 downto 0); 
signal control_tb : std_logic_vector(4 downto 0); 		  
signal alu_out_tb :  std_logic_vector(127 downto 0); 	


component ALU is
	 port(
		 rs1 : in std_logic_vector(127 downto 0);
		 rs2 : in std_logic_vector(127 downto 0);
		 rs3 : in std_logic_vector(127 downto 0); 
		 loadIndex : in std_logic_vector(2 downto 0);
		 immediate : in std_logic_vector(15 downto 0);
		 alu_out : out std_logic_vector(127 downto 0);
		 control : in std_logic_vector(4 downto 0)
	     );
end component;

begin	  
	
	UUT: ALU port map(
		rs1=> rs1_tb,
		rs2=> rs2_tb,
		rs3=> rs3_tb,
		loadIndex=> loadIndex_tb,		
		immediate =>immediate_tb,
		alu_out => alu_out_tb,
		control => control_tb
    );
		
		write: process
		begin	   	
			
		-- Load Immediate 
		loadIndex_tb <= "111";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));		
		wait for 50ns;
		
		loadIndex_tb <= "110";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));	
		wait for 50ns;
		
		loadIndex_tb <= "101";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));	 
		wait for 50ns;
		
		loadIndex_tb <= "100";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));		
		wait for 50ns;
		
		loadIndex_tb <= "011";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));		
		wait for 50ns;
		
		loadIndex_tb <= "010";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));		
		wait for 50ns;
		
		loadIndex_tb <= "001";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));		
		wait for 50ns;		   
		
		loadIndex_tb <= "000";
		control_tb <= "00000";
		immediate_tb <= x"0003";
		rs3_tb <= std_logic_vector(to_unsigned(0,128));
		rs2_tb <= std_logic_vector(to_unsigned(0,128));
		rs1_tb <= std_logic_vector(to_unsigned(0,128));		
		wait for 50ns;
		
		--Signed Integer Multiply-Add Low with Saturation 		
		 
		loadIndex_tb <= "000";
		control_tb <= "00001";
		immediate_tb <= "1100000011001001";
		rs3_tb <= std_logic_vector(to_unsigned(8,128));
		rs2_tb <= std_logic_vector(to_unsigned(4,128));
		rs1_tb <= std_logic_vector(to_unsigned(3,128));	
		wait for 50ns;
		
		---Signed Integer Multiply-Add High with Saturation 
         
        loadIndex_tb <= "000";
        control_tb <= "00010";
        immediate_tb <= "1100000011001001";
        rs3_tb <= std_logic_vector(to_unsigned(8,128));
        rs2_tb <= std_logic_vector(to_unsigned(4,128));
        rs1_tb <= std_logic_vector(to_unsigned(3,128));
        wait for 50ns;
		
		---Signed Integer Multiply-Subtract Low with Saturation
         
        loadIndex_tb <= "000";
        control_tb <= "00011";
        immediate_tb <= "1100000011001001";
        rs3_tb <= std_logic_vector(to_unsigned(8,128));
        rs2_tb <= std_logic_vector(to_unsigned(4,128));
        rs1_tb <= std_logic_vector(to_unsigned(3,128));
        wait for 50ns;
		
		---Signed Integer Multiply-Subtract High with Saturation
        
        loadIndex_tb <= "000";
        control_tb <= "00100";
        immediate_tb <= "1100000011001001";
        rs3_tb <= std_logic_vector(to_unsigned(8,128));
        rs2_tb <= std_logic_vector(to_unsigned(4,128));
        rs1_tb <= std_logic_vector(to_unsigned(3,128));
        wait for 50ns;
		
		--Signed Long Integer Multiply-Add Low with Saturation
         
        loadIndex_tb <= "000";
        control_tb <= "00101";
        immediate_tb <= "1100000011001001";
        rs3_tb <= std_logic_vector(to_unsigned(8,128));
        rs2_tb <= std_logic_vector(to_unsigned(4,128));
        rs1_tb <= std_logic_vector(to_unsigned(3,128));
        wait for 50ns;
		
		--Signed Long Integer Multiply-Add High with Saturation	
        
        loadIndex_tb <= "000";
        control_tb <= "00110";
        immediate_tb <= "1100000011001001";
        rs3_tb <= std_logic_vector(to_unsigned(8,128));
        rs2_tb <= std_logic_vector(to_unsigned(4,128));
        rs1_tb <= std_logic_vector(to_unsigned(3,128));
        wait for 50ns;
		
		--Signed Long Integer Multiply-Subtract Low with Saturation	
         
        loadIndex_tb <= "000";
        control_tb <= "00111";
        immediate_tb <= "1100000011001001";
        rs3_tb <= std_logic_vector(to_unsigned(8,128));
        rs2_tb <= std_logic_vector(to_unsigned(4,128));
        rs1_tb <= std_logic_vector(to_unsigned(3,128));	 
		wait for 50ns;
        
		--Signed Long Integer Multiply-Subtract High with Saturation	
         
        loadIndex_tb <= "000";
        control_tb <= "01000";
        immediate_tb <= "1100000011001001";
        rs3_tb <= std_logic_vector(to_unsigned(8,128));
        rs2_tb <= std_logic_vector(to_unsigned(4,128));
        rs1_tb <= std_logic_vector(to_unsigned(3,128));	  
		wait for 50ns;
		
		--NOP
		
		loadIndex_tb <= "000";
		control_tb <= "01001";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	
		wait for 50ns;
		
		--AH Add Halfword 
		
		loadIndex_tb <= "000";
		control_tb <= "01010";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	   
		wait for 50ns;
		
		--AHS Add Halfword signed with Saturation
		
		loadIndex_tb <= "000";
		control_tb <= "01011";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	
		wait for 50ns;
		
		--BCW	BroadCast Words from 1 word to 4 words
		
		loadIndex_tb <= "000";
		control_tb <= "01100";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	
		wait for 50ns;
		
		--CGH Carry Generate Halfwords
		
		loadIndex_tb <= "000";
		control_tb <= "01101";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));				  
		wait for 50ns;
		
		--CLZ Count leading zeros in Words
	
		loadIndex_tb <= "000";
		control_tb <= "01110";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	 
		wait for 50ns;
		
		--MAXWS Max Signed word
		
		loadIndex_tb <= "000";
		control_tb <= "01111";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));
		wait for 50ns;
		
		--MINWS Min Signed Word
		
		loadIndex_tb <= "000";
		control_tb <= "10000";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));			 
		wait for 50ns;
		
		--MSGN  -- Multiply sign
		
		loadIndex_tb <= "000";
		control_tb <= "10001";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	  
		wait for 50ns;
		
		--POPCNTH Count Ones in Words
		
		loadIndex_tb <= "000";
		control_tb <= "10010";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	  
		wait for 50ns;
		
		--ROT      Rotate Bits
		
		loadIndex_tb <= "000";
		control_tb <= "10011";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));		   
		wait for 50ns;
		
		--ROTW	  Rotate Bits in Word 
		
		loadIndex_tb <= "000";
		control_tb <= "10100";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	
		wait for 50ns;
		
		--SHLHI      Shift left Halfword Immediate 
		
		loadIndex_tb <= "000";
		control_tb <= "10101";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));			
		wait for 50ns;
		
		--SFH	 Subtract from Halford Unsigned
		
		loadIndex_tb <= "000";
		control_tb <= "10110";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	 
		wait for 50ns;
		
		 --SFHS     Subtract from Halfword Saturated
		
		loadIndex_tb <= "000";
		control_tb <= "10111";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	 	 
		wait for 50ns;
		
		--XOR Bit Logical "xor"
		
		loadIndex_tb <= "000";
		control_tb <= "11000";
		immediate_tb <= "1000000011111100";
		rs3_tb <= std_logic_vector(to_unsigned(3,128));
		rs2_tb <= std_logic_vector(to_unsigned(2,128));
		rs1_tb <= std_logic_vector(to_unsigned(1,128));	
		wait for 50ns;
		
		wait for 20ns;
		wait;
	end process;
  

end tb_architecture;

