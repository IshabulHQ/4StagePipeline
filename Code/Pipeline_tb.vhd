library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pipeline_tb is
end Pipeline_tb;


ARCHITECTURE testbench OF Pipeline_tb IS 
    
    -- Component Declaration for the Unit Under Test (UUT)
    component Pipeline is
    port(
        clk : in std_logic;
        reset : in std_logic;
        wr_en : in std_logic;
        inst_in : in std_logic_vector(24 downto 0);
        run : in std_logic
    );
    end component;
    
    --Inputs
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal wr_en : std_logic := '0';
    signal inst_in : std_logic_vector(24 downto 0);
    signal run : std_logic := '0';
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
    
    subtype data is bit_vector(24 downto 0);
    type arr is array (0 to 63) of data;
    signal inst_out : arr := ("0011000000000000000100010",
                                "0000000000000000001000100",
                                "0100000000000000010000101",
                                "1000000010001000010100110",
                                "1000100010001000010100110",
                                "1001000010001000010100110",
                                "1001100010001000010100110",
                                "1010000010001000010100110",
                                "1010100010001000010100110",
                                "1011000010001000010100110",
                                "1011100010001000010100110",
                                "1100000000001000010100110",
                                "1100000001001000010100110",
                                "1100000010001000010100110",
                                "1100000011001000010100110",
                                "1100000100001000010100110",
                                "1100000101001000010100110",
                                "1100000110001000010100110",
                                "1100001000001000010100110",
                                "1100001001001000010100110",
                                "1100001010001000010100110",
                                "1100001100001000010100110",
                                "1100001101001000010100110",
                                "1100001110001000010100110",
                                "1100001111001000010100110",
                              others => "0000000000000000000000000");
                              
    signal i : integer := 0;      
BEGIN
    
	-- Instantiate the Unit Under Test (UUT)
    uut: Pipeline PORT MAP (
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        inst_in => inst_in,
        run => run
    );
    
    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns
        reset <= '1';
        wait for 100 ns;
        
        reset <= '0';
        wait for clk_period*2;
        
        for i in 0 to 63 loop
            wr_en <= '1';
            inst_in <= to_stdlogicvector(inst_out(i));
            wait for clk_period;
        end loop;
        
        wr_en <= '0';
        run <= '1';        
        
        wait for clk_period*8;  -- 8 instruction + 2 clocks for finish ptr instruction -> 10 clocks (2+ 8)
        
        wait;
    end process;

END testbench;
