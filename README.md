# 4StagePipeline
Final Project for Class ESE 345: Computer Architecture. Project was done primarily in VHDL with the Assembler being done in C.


The complete 4-stage pipelined design is to be developed in a structural/RTL manner with several modules operating simultaneously. Each module represents a pipelined stage with its interstage register. The major units inside those stages modules are described below.
1. Multimedia ALU
Takes up to three inputs from the Register File, and calculates the result based on the current instruction to be performed.
The ALU must be implemented as behavioral model in VHDL or continuous assign- ment (dataflow models in Verilog).
2. Register File
The register file has 32 128-bit registers. On any cycle, there can be 3 reads and 1 write. When executing instructions, each cycle two/three 128-bit register values are read, and one 128-bit result can be written if a write signal is valid. This register write signal must be explicitly declared so it can be checked during simulation and demonstration of your design. The register module must be implemented as a behavioral model in VHDL (dataflow/RTL model in Verilog).
3. Instruction Buffer
The instruction buffer can store 64 25-bit instructions. The contents of the buffer should be loaded by the testbench instructions from a test file at the start of simulation. On each cycle, the instruction specified by the Program Counter (PC) is fetched, and the value of PC is incremented by 1.
The Instruction Buffer module must be implemented as a behavioral model in VHDL (dataflow/RTL model in Verilog).
4. Forwarding Unit
Every instruction must use the most recent value of a register, even if this value has not yet been written to the Register File. Be mindful of the ordering of instructions; the most recent value should be used, in the event of two consecutive writes to a register, followed by a read from that same register. Your processor should never stall in the event of hazards. Take extra care of which instructions require forwarding, and which ones do not. Namely, NOP (wr enabled signal low) and Immediate fields (doesn’t contain a register source). Only valid data and source/destination registers should be considered for forwarding.
5. Four-Stage Pipelined Multimedia Unit
Clock edge-sensitive pipeline registers separate the IF, ID, EXE, and WB stages. Data should be written to the Register File after the WB Stage.
All instructions (including li) take four cycles to complete. This pipeline must be imple- mented as a structural model with modules for each corresponding pipeline stages and their interstage registers. Four instructions can be at different stages of the pipeline at every cycle.
6. Testbench This module loads the instruction buffer using data loaded from a file, begins simulation, and upon completion, compares the contents of the register file to a file containing the expected results. This expected results file does not need to be auto-generated. Instead, this can be manually entered when designing a test program.
This must be implemented as a behavioral model.
7. Assembler This is a separate program written in any language your team prefers (i.e. Java, C++, Python). Its purpose is to convert an assembly file to the binary format for the Instruction Buffer. This assembler does not need to be robust, and can assume very specific syntax rules that you as a team decide.
8. Results File This file must show the status of the pipeline for each cycle during program execution. It should include the opcodes, input operand, and results of the execution of instructions, as well as all relevant control signals and forwarding information. This should be carried out by your testbench.
