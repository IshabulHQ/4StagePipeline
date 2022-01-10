-------------------------------------------------------------------------------
--
-- Title       : Multimedia ALU
-- Design      : ALU
-- Author      : Ishabul Haque 
-- Company     : 
-------------------------------------------------------------------------------
-- Description : Takes up to three inputs from the Register File, and calculates 
-- the result based on the current instruction to be performed.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;	   	  
use IEEE.numeric_std.all;
                                              
entity ALU is
	 port(
		 rs1 : in std_logic_vector(127 downto 0);
		 rs2 : in std_logic_vector(127 downto 0);
		 rs3 : in std_logic_vector(127 downto 0); 
		 loadIndex : in std_logic_vector(2 downto 0);
		 immediate : in std_logic_vector(15 downto 0);
		 alu_out : out std_logic_vector(127 downto 0);
		 control : in std_logic_vector(4 downto 0)
	     );
end ALU;

architecture behavioral of ALU is	 
begin
	process(rs1, rs2, rs3, control, loadIndex, immediate)
	variable offset : integer;
	variable counter : integer := 0; 
		
	variable var8_1 : std_logic_vector(7 downto 0);
	variable var8_2 : std_logic_vector(7 downto 0);
		
	variable var16_1: std_logic_vector(15 downto 0);
	variable var16_2 : std_logic_vector(15 downto 0); 
	variable var16_3 : std_logic_vector(15 downto 0);
    variable var16_4 : std_logic_vector(16 downto 0);
		
	variable var32_1 : std_logic_vector(31 downto 0);	
	variable var32_2 : std_logic_vector(31 downto 0);
	variable var32_3 : std_logic_vector(31 downto 0);
	variable var32_4 : std_logic_vector(31 downto 0);
	variable var32_5 : std_logic_vector(31 downto 0);
	variable var32_6 : std_logic_vector(31 downto 0);	
	variable var32_7 : std_logic_vector(31 downto 0);
	variable var32_8 : std_logic_vector(31 downto 0);
		
	variable temp_64_1 : std_logic_vector(63 downto 0);
	variable temp_64_2 : std_logic_vector(63 downto 0);
	variable temp_64_3 : std_logic_vector(63 downto 0);
	begin  
			case std_logic_vector(control) is

	-- Instructions to be performed

			 --Load Immediate 
			when "00000" =>
			    alu_out <= x"00000000000000000000000000000000";
                case loadIndex is
                    when "111" => --7
                    alu_out(127 downto 112) <= immediate;
                    when "110" => --6
                    alu_out(111 downto 96) <= immediate;
                    when "101" => --5
                    alu_out(95 downto 80) <= immediate;
                    when "100" => --4
                    alu_out(79 downto 64) <= immediate;
                    when "011" => --3
                    alu_out(63 downto 48) <= immediate;
                    when "010" => --2
                    alu_out(47 downto 32) <= immediate;
                    when "001" => --1
                    alu_out(31 downto 16) <= immediate;
                    when others => --0
                    alu_out(15 downto 0) <= immediate;
                end case;
			
			--Signed Integer Multiply-Add Low with Saturation 		
			when "00001" =>	
				for i in 0 to 3 loop			    
					offset := 32*i;	
			   		var16_1:= rs3((15 + offset) downto (0 + offset)); 
			   		var16_2 := rs2((15 + offset) downto (0 + offset));
					var32_1 := rs1((31 + offset) downto (0 + offset));
					var32_2 := std_logic_vector((signed(var16_1) * signed(var16_2)));
					var32_3 := std_logic_vector(signed(var32_1) + signed(var32_2));
					
					if ((var32_1(31) = '0') and (var32_2(31) = '0') and (var32_3(31) /= '0')) then 	
						alu_out((31 + offset) downto (0 + offset)) <= X"7FFFFFFF";
					elsif ((var32_1(31) = '1') and (var32_2(31) = '1') and (var32_3(31) /= '1')) then 		
						alu_out((31 + offset) downto (0 + offset)) <= X"80000000";  
					else 
						alu_out((31 + offset) downto (0 + offset)) <= var32_3; 
					end if;
				end loop;	
				
			---Signed Integer Multiply-Add High with Saturation 
			when "00010" =>	
				for i in 0 to 3 loop			    
					offset := 32*i;	
			   		var16_1:= rs3((31 + offset) downto (16 + offset)); 
			   		var16_2 := rs2((31 + offset) downto (16 + offset));
					var32_1 := rs1((31 + offset) downto (0 + offset));
					var32_2 := std_logic_vector((signed(var16_1) * signed(var16_2)));
					var32_3 := std_logic_vector(signed(var32_1) + signed(var32_2)); 	   
					if ((var32_1(31) = '0') and (var32_2(31) = '0') and (var32_3(31) /= '0')) then 	
						alu_out((31 + offset) downto (0 + offset)) <= X"7FFFFFFF";
					elsif ((var32_1(31) = '1') and (var32_2(31) = '1') and (var32_3(31) /= '1')) then 		
						alu_out((31 + offset) downto (0 + offset)) <= X"80000000";  
					else 
						alu_out((31 + offset) downto (0 + offset)) <= var32_3; 
					end if;
				end loop;
									
				---Signed Integer Multiply-Subtract Low with Saturation
			 when "00011" =>	
				for i in 0 to 3 loop			    
					offset := 32*i;	
			   		var16_1:= rs3((15 + offset) downto (0 + offset)); 
			   		var16_2 := rs2((15 + offset) downto (0 + offset));
					var32_1 := rs1((31 + offset) downto (0 + offset));
					var32_2 := std_logic_vector((signed(var16_1) * signed(var16_2)));
					var32_3 := std_logic_vector(signed(var32_1) - signed(var32_2)); 	   
					if ((var32_1(31) = '0') and (var32_2(31) = '1') and (var32_3(31) /= '0')) then 	
						alu_out((31 + offset) downto (0 + offset)) <= X"7FFFFFFF";
					elsif ((var32_1(31) = '1') and (var32_2(31) = '0') and (var32_3(31) /= '1')) then 		
						alu_out((31 + offset) downto (0 + offset)) <= X"80000000";  
					else 
						alu_out((31 + offset) downto (0 + offset)) <= var32_3; 
					end if;
				end loop;
				
			---Signed Integer Multiply-Subtract High with Saturation
			when "00100" =>
				for i in 0 to 3 loop			    
					offset := 32*i;	
			   		var16_1:= rs3((31 + offset) downto (16 + offset)); 
			   		var16_2 := rs2((31 + offset) downto (16 + offset));
					var32_1 := rs1((31 + offset) downto (0 + offset));
					var32_2 := std_logic_vector((signed(var16_1) * signed(var16_2)));
					var32_3 := std_logic_vector(signed(var32_1) - signed(var32_2)); 	   
					if ((var32_1(31) = '0') and (var32_2(31) = '1') and (var32_3(31) /= '0')) then 	
						alu_out((31 + offset) downto (0 + offset)) <= X"7FFFFFFF";
					elsif ((var32_1(31) = '1') and (var32_2(31) = '0') and (var32_3(31) /= '1')) then 		
						alu_out((31 + offset) downto (0 + offset)) <= X"80000000";  
					else 
						alu_out((31 + offset) downto (0 + offset)) <= var32_3; 
					end if;
				end loop;
							
			--Signed Long Integer Multiply-Add Low with Saturation
			when "00101" =>
				for i in 0 to 1 loop			    
					offset := 64*i;	
			   		var32_1 := rs3((31 + offset) downto (0 + offset)); 
			   		var32_2 := rs2((31 + offset) downto (0 + offset));
					temp_64_1 := rs1((63 + offset) downto (0 + offset));
					temp_64_2 := std_logic_vector((signed(var32_1) * signed(var32_2)));
					temp_64_3 := std_logic_vector(signed(temp_64_1) + signed(temp_64_2)); 	   
					if ((temp_64_1(63) = '0') and (temp_64_2(63) = '0') and (temp_64_3(63) /= '0')) then 	
						alu_out((63 + offset) downto (0 + offset)) <= X"7FFFFFFFFFFFFFFF";
					elsif ((temp_64_1(63) = '1') and (temp_64_2(63) = '1') and (temp_64_3(63) /= '1')) then 		
						alu_out((63 + offset) downto (0 + offset)) <= X"8000000000000000";  
					else 
						alu_out((63 + offset) downto (0 + offset)) <= temp_64_3; 
					end if;
				end loop; 
			--Signed Long Integer Multiply-Add High with Saturation	  
			when "00110" =>	 
				for i in 0 to 1 loop			    
					offset := 64*i;	
			   		var32_1 := rs3((63 + offset) downto (32 + offset)); 
			   		var32_2 := rs2((63 + offset) downto (32 + offset));
					temp_64_1 := rs1((63 + offset) downto (0 + offset));
					temp_64_2 := std_logic_vector((signed(var32_1) * signed(var32_2)));
					temp_64_3 := std_logic_vector(signed(temp_64_1) + signed(temp_64_2)); 	   
					if ((temp_64_1(63) = '0') and (temp_64_2(63) = '0') and (temp_64_3(63) /= '0')) then 	
						alu_out((63 + offset) downto (0 + offset)) <= X"7FFFFFFFFFFFFFFF";
					elsif ((temp_64_1(63) = '1') and (temp_64_2(63) = '1') and (temp_64_3(63) /= '1')) then 		
						alu_out((63 + offset) downto (0 + offset)) <= X"8000000000000000";  
					else 
						alu_out((63 + offset) downto (0 + offset)) <= temp_64_3; 
					end if;
				end loop; 
						
			--Signed Long Integer Multiply-Subtract Low with Saturation	
			when "00111" =>
				for i in 0 to 1 loop			    
					offset := 64*i;	
			   		var32_1 := rs3((31 + offset) downto (0 + offset)); 
			   		var32_2 := rs2((31 + offset) downto (0 + offset));
					temp_64_1 := rs1((63 + offset) downto (0 + offset));
					temp_64_2 := std_logic_vector((signed(var32_1) * signed(var32_2)));
					temp_64_3 := std_logic_vector(signed(temp_64_1) - signed(temp_64_2)); 	   
					if ((temp_64_1(63) = '0') and (temp_64_2(63) = '1') and (temp_64_3(63) /= '0')) then 	
						alu_out((63 + offset) downto (0 + offset)) <= X"7FFFFFFFFFFFFFFF";
					elsif ((temp_64_1(63) = '1') and (temp_64_2(63) = '0') and (temp_64_3(63) /= '1')) then 		
						alu_out((63 + offset) downto (0 + offset)) <= X"8000000000000000";  
					else 
						alu_out((63 + offset) downto (0 + offset)) <= temp_64_3; 
					end if;
				end loop;
			
			--Signed Long Integer Multiply-Subtract High with Saturation	
			when "01000" =>
				for i in 0 to 1 loop			    
					offset := 64*i;	
			   		var32_1 := rs3((63 + offset) downto (32 + offset)); 
			   		var32_2 := rs2((63 + offset) downto (32 + offset));
					temp_64_1 := rs1((63 + offset) downto (0 + offset));
					temp_64_2 := std_logic_vector((signed(var32_1) * signed(var32_2)));
					temp_64_3 := std_logic_vector(signed(temp_64_1) - signed(temp_64_2)); 	   
					if ((temp_64_1(63) = '0') and (temp_64_2(63) = '1') and (temp_64_3(63) /= '0')) then 
						alu_out((63 + offset) downto (0 + offset)) <= X"7FFFFFFFFFFFFFFF";
					elsif ((temp_64_1(63) = '1') and (temp_64_2(63) = '0') and (temp_64_3(63) /= '1')) then 	
						alu_out((63 + offset) downto (0 + offset)) <= X"8000000000000000";  
					else 
						alu_out((63 + offset) downto (0 + offset)) <= temp_64_3; 
					end if;
				end loop;  			
				
			--NOP
			when "01001" =>	
                for i in 0 to 3 loop         
                    offset := 32 * i;           
                    alu_out((31 + offset) downto (0 + offset)) <= x"00000000"; 
                end loop; 

            --AH Add Halfword 
            when "01010" =>    
                for i in 0 to 7 loop
                    offset := 16 * i;
                    var16_1:= rs1((15 + offset) downto (0 + offset));
                    var16_2 := rs2((15 + offset) downto (0 + offset));
                    var16_3 := std_logic_vector(unsigned(var16_1) + unsigned(var16_2));
                    alu_out((15 + offset) downto (0 + offset)) <= var16_3;
                end loop;		


			--AHS Add Halfword signed with Saturation
			when "01011" =>
				for i in 0 to 7 loop
					offset := 16 * i;
					var16_1:= rs1((15 + offset) downto (0 + offset));
					var16_2 := rs2((15 + offset) downto (0 + offset));
					var16_3 := std_logic_vector(signed(var16_1) + signed(var16_2));
					if((var16_1(15) = '0') and (var16_2(15) = '0') and (var16_3(15) /= '0')) then 
						alu_out((15 + offset) downto (0 + offset)) <= "0111111111111111";
					elsif((var16_1(15) = '1') and (var16_2(15) = '1') and (var16_3(15) /= '1')) then 
						alu_out((15 + offset) downto (0 + offset)) <= "1000000000000000";
					else
						alu_out((15 + offset) downto (0 + offset)) <= var16_3;
					end if;
				end loop;


			--BCW	BroadCast Words from 1 word to 4 words
			when "01100" =>	
                var32_1 := rs1(31 downto 0);
                alu_out(31 downto 0) <= var32_1;
                alu_out(63 downto 32) <= var32_1;
                alu_out(95 downto 64) <= var32_1;
                alu_out(127 downto 96) <= var32_1;
                		
            --CGH Carry Generate Halfwords
            when "01101" =>        
                for i in 0 to 7 loop
                    offset := 16 * i;
                    var16_1:= rs1((15 + offset) downto (0 + offset));
                    var16_2 := rs2((15 + offset) downto (0 + offset));
                    var16_4 := std_logic_vector(unsigned("0" & var16_1) + unsigned("0" & var16_2));                        
                    alu_out((15 + offset) downto (0 + offset)) <= "000000000000000" & var16_4(16);
                end loop; 
                    
			--CLZ Count leading zeros in Words
            when "01110" =>        
                for i in 0 to 3 loop
                    offset := 32 * i;
                    counter := 0;
                    for j in 0 to 31 loop
                        if rs1(j + offset) = '0' then 
                            counter := counter + 1;
                        else 
                            exit;
                        end if;
                    end loop;
                    alu_out((31 + offset) downto (0 + offset)) <= std_logic_vector(to_unsigned(counter,32));
                end loop; 
                
            --MAXWS Max Signed word
            when "01111" =>
                var32_1 := rs1(31 downto 0);
                var32_2 := rs1(63 downto 32);
                var32_3 := rs1(95 downto 64);
                var32_4 := rs1(127 downto 96);
                
                var32_5 := rs2(31 downto 0); 
                var32_6 := rs2(63 downto 32);
                var32_7 := rs2(95 downto 64);
                var32_8 := rs2(127 downto 96);
            
                if signed(var32_1) > signed(var32_5) then
                    alu_out(31 downto 0) <= var32_1;
                else alu_out(31 downto 0) <= var32_5;
                end if;
                if signed(var32_2) > signed(var32_6) then
                    alu_out(63 downto 32) <= var32_2;
                else alu_out(63 downto 32) <= var32_6;
                end if;
                if signed(var32_3) > signed(var32_7) then
                    alu_out(95 downto 64) <= var32_3;
                else alu_out(95 downto 64) <= var32_7;
                end if;
                if signed(var32_4) > signed(var32_8) then
                    alu_out(127 downto 96) <= var32_4;
                else alu_out(127 downto 96) <= var32_8;
                end if;                       
    
            --MINWS Min Signed Word
            when "10000" =>
                var32_1 := rs1(31 downto 0);
                var32_2 := rs1(63 downto 32);
                var32_3 := rs1(95 downto 64);
                var32_4 := rs1(127 downto 96);
                
                var32_5 := rs2(31 downto 0); 
                var32_6 := rs2(63 downto 32);
                var32_7 := rs2(95 downto 64);
                var32_8 := rs2(127 downto 96);
                
                if signed(var32_1) < signed(var32_5) then
                    alu_out(31 downto 0) <= var32_1;
                else alu_out(31 downto 0) <= var32_5;
                end if;
                if signed(var32_2) < signed(var32_6) then
                    alu_out(63 downto 32) <= var32_2;
                else alu_out(63 downto 32) <= var32_6;
                end if;
                if signed(var32_3) < signed(var32_7) then
                    alu_out(95 downto 64) <= var32_3;
                else alu_out(95 downto 64) <= var32_7;
                end if;
                if signed(var32_4) < signed(var32_8) then
                    alu_out(127 downto 96) <= var32_4;
                else alu_out(127 downto 96) <= var32_8;
                end if;			
			
			--MSGN  -- Multiply sign
			when "10001" =>
				for i in 0 to 3 loop
					offset := 32 * i;
					temp_64_1 := std_logic_vector(signed(rs1((31 + offset) downto (0 + offset))) * signed(rs2((31 + offset) downto (0 + offset)))); 
					if (temp_64_1(63) = '1' and temp_64_1(63 downto 32) /= x"ffffffff") then
                        alu_out((31 + offset) downto (0 + offset)) <= x"80000000";
                    elsif (temp_64_1(63) = '0' and temp_64_1(63 downto 32) /= x"00000000") then
                        alu_out((31 + offset) downto (0 + offset)) <= x"7FFFFFFF";
                    else
					   alu_out((31 + offset) downto (0 + offset)) <= temp_64_1(31 downto 0);
					end if;
				end loop; 

			--POPCNTH Count Ones in Words
			when "10010" =>		
				for i in 0 to 7 loop
					offset := 16 * i;
					counter := 0;
					for j in 0 to 15 loop
						if rs1(j + offset) = '1' then 
							counter := counter + 1;
						else 
							null;
						end if;
					end loop;
					alu_out((15 + offset) downto (0 + offset)) <= std_logic_vector(to_unsigned(counter,16));
				end loop; 

            --ROT      Rotate Bits 
            when "10011" =>                                                
                alu_out <= std_logic_vector(rotate_right(unsigned(rs1),to_integer(unsigned(rs2(6 downto 0)))));
                 
			--ROTW	  Rotate Bits in Word 
			when "10100" =>	   
				for i in 0 to 3 loop
					offset := 32 * i; 										 
					var32_2 := std_logic_vector(rotate_right(signed(rs1((31 + offset) downto (0 + offset))),to_integer(unsigned(rs2((4 + offset) downto (0 + offset))))));
					alu_out((31 + offset) downto (0 + offset)) <= std_logic_vector(var32_2);
				 end loop;
				 
            --SHLHI      Shift left Halfword Immediate 
            when "10101" =>       
                for i in 0 to 7 loop
                    offset := 16 * i;                                          
                    var16_2 := std_logic_vector(shift_left(unsigned(rs1((15 + offset) downto (0 + offset))),to_integer(unsigned(rs2((3 + offset) downto (0 + offset))))));
                    alu_out((15 + offset) downto (0 + offset)) <= std_logic_vector(var16_2);
                 end loop;

			--SFH	 Subtract from Halford Unsigned
			when "10110"=> 
				for i in 0 to 3 loop
					offset := 32 * i;
					var32_1 := rs1((31 + offset) downto (0 + offset));
					var32_2 := rs2((31 + offset) downto (0 + offset));
					var32_3 := std_logic_vector(unsigned(var32_2) - unsigned(var32_1)); 
					alu_out((31 + offset) downto (0 + offset)) <= var32_3;
				end loop;
				
            --SFHS     Subtract from Halfword Saturated
            when "10111" =>
                for i in 0 to 7 loop
                    offset := 16 * i;
                    var16_1:= rs1((15 + offset) downto (0 + offset));
                    var16_2 := rs2((15 + offset) downto (0 + offset));
                    var16_3 := std_logic_vector(signed(var16_2) - signed(var16_1));
                    if((var16_2(15) = '1') and (var16_1(15) = '0') and var16_3(15) /= '1') then  
                        alu_out((15 + offset) downto (0 + offset)) <= "1000000000000000";
                    elsif((var16_2(15) = '0') and (var16_1(15) = '1') and var16_3(15) /= '0') then      
                        alu_out((15 + offset) downto (0 + offset)) <= "0111111111111111";
                    else 
                        alu_out((15 + offset) downto (0 + offset)) <= var16_3;        
                    end if;
                end loop;    
				
            --XOR Bit Logical "xor"
            when "11000" =>    
                alu_out <= rs1 xor rs2;
			when others =>
		end case;	
	end process;
end behavioral;