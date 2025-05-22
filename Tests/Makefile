# Makefile
CWD=$(shell pwd)
# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

#Add your sources one by one as below or use *.v to add all verilog files

VERILOG_SOURCES = $(CWD)/../HDL/*.v

#$(info VERILOG_SOURCES=$(VERILOG_SOURCES))


# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
#Should be the name of the basic computer module for you
TOPLEVEL = BC_I

# MODULE is the basename of the Python test file
#Name of your python file
MODULE := cocotb_test
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim