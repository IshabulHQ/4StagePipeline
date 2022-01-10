-------------------------------------------------------------------------------
--
-- Title       : Four-Stage Pipelined Multimedia Unit 
-- Design      : pipeline
-- Author      : Ishabul Haque 
-- Company     : 
-------------------------------------------------------------------------------
-- Description : Clock edge-sensitive pipeline registers separate the IF, ID, EXE, 
-- and WB stages. Data is written to the Register File after the WB Stage.
-- All instructions (including li) take four cycles to complete. 
-- Pipeline is implemented as a structural model with modules for each corresponding 
-- pipeline stages and their interstage registers.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
entity Pipeline is
port(
    clk : in std_logic;
    reset : in std_logic;
    wr_en : in std_logic;
    inst_in : in std_logic_vector(24 downto 0);
    run : in std_logic
);
end Pipeline;
architecture structural of Pipeline is

    --stage 1
    signal adder_out, pc_out : std_logic_vector(5 downto 0);
    signal inst : std_logic_vector(24 downto 0);

    --IF/ID Reg
    signal inst_IFID : std_logic_vector(24 downto 0);
    
    --stage 2
    signal rs1, rs2, rs3 : std_logic_vector(127 downto 0);
    signal rf_datain : std_logic_vector(127 downto 0);
    signal rf_we : std_logic;
    signal rf_wr_reg : std_logic_vector(4 downto 0);
    signal rf_loadindex : std_logic_vector(3 downto 0);
    
    --ID/EX Reg
    signal inst_IDEX : std_logic_vector(24 downto 0);
    signal rs1_IDEX : std_logic_vector(127 downto 0);
    signal rs2_IDEX : std_logic_vector(127 downto 0);
    signal rs3_IDEX : std_logic_vector(127 downto 0);
    
    --stage 3    
    signal loadIndex : std_logic_vector(3 downto 0);
    signal control : std_logic_vector(4 downto 0);
    signal immediate : std_logic_vector(15 downto 0);
    signal alu_out : std_logic_vector(127 downto 0);
    
    --EX/WB Reg
    signal inst_EXWB : std_logic_vector(24 downto 0);
    signal alu_out_EXWB : std_logic_vector(127 downto 0);
    
    signal fw1, fw2, fw3 : std_logic;
    signal rs1_fw, rs2_fw, rs3_fw : std_logic_vector(127 downto 0);
    
    component InstBuffer
    port(
        clk : in std_logic;
        
        wr_en : in std_logic;
        inst_in : in std_logic_vector(24 downto 0);
        
        addr : in std_logic_vector(5 downto 0);
        inst_out : out std_logic_vector(24 downto 0)
    );
    end component;
    
    component reg 
      generic( DWIDTH : integer := 16 );
      port( CLK : in std_logic;
            RST : in std_logic;
            CE : in std_logic;
            
            D : in std_logic_vector( DWIDTH-1 downto 0 );
            Q : out std_logic_vector( DWIDTH-1 downto 0 ) );
    end component;
    
    component adder
        generic( DWIDTH : integer := 16 );
        port( A : in std_logic_vector( DWIDTH-1 downto 0 );
              B : in std_logic_vector( DWIDTH-1 downto 0 );
              D : out std_logic_vector( DWIDTH-1 downto 0 )
        );
    end component;
    
    component RF 
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
    end component;
    
    component ALU
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
    
    component ControlUnit is
    port(
        inst : in std_logic_vector(24 downto 0);
        
        control : out std_logic_vector(4 downto 0);
        write_en : out std_logic;
        immediate : out std_logic_vector(15 downto 0);
        loadIndex : out std_logic_vector(3 downto 0)
    );
    end component;
    
    component mux2 
       generic( DWIDTH : integer := 16 );
       port( IN0 : in std_logic_vector( DWIDTH-1 downto 0 );
             IN1 : in std_logic_vector( DWIDTH-1 downto 0 );
             SEL : in std_logic;
             DOUT : out std_logic_vector( DWIDTH-1 downto 0 ) );
    end component;
    
    component DataForwarding is
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
    end component;

begin

    --Stage 1: Instruction Fetch               
    ProgramCounter: reg generic map (DWIDTH => 6)
    port map (
        CLK => CLK,
        RST => RESET,
        CE  => run,
        D   => adder_out,
        Q   => pc_out
    );    
    
    PCadder: adder generic map (DWIDTH => 6)
    port map (
        A => "000001",
        B => pc_out,
        D => adder_out
    );  
    
    InstBuffer_inst: InstBuffer 
    port map (
        clk => CLK,
        
        wr_en => wr_en,
        inst_in => inst_in,
        
        addr => pc_out,
        inst_out => inst
    );
    
    --IF/ID Reg    
    Instruction_IFID_inst: reg generic map (DWIDTH => 25)
        port map (
        CLK => CLK,
        RST => RESET,
        CE  => '1',
        D   => inst,
        Q   => inst_IFID
        ); 
    
    --Stage 2: Decode and Read Operands
    
    RF_inst: RF port map (
        CLK => CLK,
        rst => RESET,
        
        write_En => rf_we,
        index => rf_loadindex,
        data => rf_datain,        
        wr_reg => rf_wr_reg,
        rd_reg1 => inst_IFID(9 downto 5),
        rd_reg2 => inst_IFID(14 downto 10),
        rd_reg3 => inst_IFID(19 downto 15),
        rs1 => rs1,
        rs2 => rs2,
        rs3 => rs3
    );  
    
    --ID/EX Reg  
    Instruction_IDEX_inst: reg generic map (DWIDTH => 25)
        port map (
        CLK => CLK,
        RST => RESET,
        CE  => '1',
        D   => inst_IFID,
        Q   => inst_IDEX
        ); 
              
    rs1_IDEX_inst: reg generic map (DWIDTH => 128)
        port map (
        CLK => CLK,
        RST => RESET,
        CE  => '1',
        D   => rs1,
        Q   => rs1_IDEX
        );  
        
    rs2_IDEX_inst: reg generic map (DWIDTH => 128)
        port map (
        CLK => CLK,
        RST => RESET,
        CE  => '1',
        D   => rs2,
        Q   => rs2_IDEX
        );  
                
    rs3_IDEX_inst: reg generic map (DWIDTH => 128)
        port map (
        CLK => CLK,
        RST => RESET,
        CE  => '1',
        D   => rs3,
        Q   => rs3_IDEX
        );  
        
    --Stage 3:Execute
    ControlUnit_EX: ControlUnit 
    port map(
        inst => inst_IDEX,
        
        control => control,
        write_en => open,
        immediate => immediate, 
        loadIndex => loadIndex
    );
    
    --FORWARDING MUXS
    
    rs1_mux_inst: mux2 generic map ( DWIDTH => 128)
        port map (
        IN0  => rs1_IDEX,  -- 00
        IN1  => rf_datain,  -- 01
        SEL  => fw1,
        DOUT => rs1_fw
        );
    rs2_mux_inst: mux2 generic map ( DWIDTH => 128)
        port map (
        IN0  => rs2_IDEX,  -- 00
        IN1  => rf_datain,  -- 01
        SEL  => fw2,
        DOUT => rs2_fw
        );
    rs3_mux_inst: mux2 generic map ( DWIDTH => 128)
        port map (
        IN0  => rs1_IDEX,  -- 00
        IN1  => rf_datain,  -- 01
        SEL  => fw1,
        DOUT => rs3_fw
        );
    
    
    ALU_inst: alu port map (
        rs1 => rs1_fw,
        rs2 => rs2_fw,
        rs3 => rs3_fw,
        
        loadIndex => loadIndex(2 downto 0),
        immediate => immediate,
        alu_out => alu_out,
        control => control
    );  
    
    --EX/WB Reg  
    Instruction_EXWB_inst: reg generic map (DWIDTH => 25)
        port map (
        CLK => CLK,
        RST => RESET,
        CE  => '1',
        D   => inst_IDEX,
        Q   => inst_EXWB
        );   
        
    alu_out_EXWB_inst: reg generic map (DWIDTH => 128)
        port map (
        CLK => CLK,
        RST => RESET,
        CE  => '1',
        D   => alu_out,
        Q   => alu_out_EXWB
    );  
        
    --stage 4: Write back
    --control
    ControlUnit_WB: ControlUnit 
    port map(
        inst => inst_EXWB,
        
        control => open,
        write_en => rf_we,
        immediate => open, 
        loadIndex => rf_loadIndex
    );
    rf_datain <= alu_out_EXWB;
    rf_wr_reg <= inst_EXWB(4 downto 0);
    
    DataForwarding_inst: DataForwarding
        port map( 
            rf_we => rf_we,
            rf_wr_reg => rf_wr_reg,    
            
            rs1_reg => inst_IDEX(9 downto 5),
            rs2_reg => inst_IDEX(14 downto 10),     
            rs3_reg => inst_IDEX(19 downto 15),
            
            fw1 => fw1, 
            fw2 => fw2, 
            fw3 => fw3 
    );
        
    
end structural;