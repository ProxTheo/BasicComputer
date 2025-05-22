import cocotb
from cocotb.triggers import Timer, FallingEdge
from cocotb.clock import Clock

DEBUG = True

@cocotb.test()
async def test_memory_check(dut):
    
    # Checkpoints for successfull performance 
    memory_check_dc = {
        0x004: 0x0001,  # CHECK: RESULT = 1
        0x00D: 0x0087,  # CHECK: ROUTINE 1: RESULT(A+B) == 10
        0x018: 0xFF78,  # CHECK: ROUTINE 2: RESULT(A & B) == 0x004A
    }

    # Initializing the clock
    clock = Clock(dut.clk, 100, "us")
    await cocotb.start(clock.start())
    current_Timing_signal = 0
    i = 0
    dut.FGI.value = 0

    S_check = 0
    fetched_PC = 0

    cycles_spent_HALTED = 0

    # Various while loops for different purposes
    
    # Set amount of cycles  
    #while i < 100:

    # Stopping after a set amount of halted cycle
    while cycles_spent_HALTED < 10:  

    # COMMENT OUT FOR ENDING TESTBENCH AFTER HALT
    #while S_check == 0:
        await FallingEdge(dut.clk)
        current_Timing_signal = dut.controller.T0.value.integer
        S_check = dut.controller.S.value.integer

        # Printing the results at halted cycles
        if S_check == 1:
            cycles_spent_HALTED += 1
            dut._log.info(
                f"PC={hex(dut.PC.value.integer)}, AR={hex(dut.AR.value.integer)}, IR={hex(dut.IR.value.integer)}, "
                f"AC={hex(dut.AC.value.integer)}, DR={hex(dut.DR.value.integer)}"
            )

        # Setting input flag up
        if (dut.PC.value.integer == 0x010) and not dut.FGI.value:
            dut._log.info("FGI is set")
            dut.FGI.value = 1
        
        # Setting input flag down
        elif (dut.PC.value.integer == 0x007) and dut.FGI.value:
            dut._log.info("FGI is resetted")
            dut.FGI.value = 0

        
        # Printing at every case
        dut._log.info(
            f"T{dut.controller.out_timing.value.integer}:R= {dut.controller.R.value.integer} PC={hex(dut.PC.value.integer)}, AR={hex(dut.AR.value.integer)}, IR={hex(dut.IR.value.integer)}, "
            f"AC={hex(dut.AC.value.integer)}, DR={hex(dut.DR.value.integer)}"
        )


    # Memory validation
    for address, expected_value in memory_check_dc.items():
        actual_value = dut.datapath.mem1.memory_block[address].value.integer
        assert actual_value == expected_value, (
            f"Memory mismatch at address {hex(address)}: "
            f"Expected {hex(expected_value)}, got {hex(actual_value)}"
        )

    dut._log.info("All memory checks passed.")