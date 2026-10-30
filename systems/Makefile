SHELL:=/bin/bash
IVERILOG=iverilog -g2012 -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -y./ -y../components -y./tests -Y.sv -I../components
VVP=vvp
VVP_POST=-fst
WAVES=gtkwave

# Vivado is still used by conway_system and uart_hello_world until they are migrated.
VIVADO=vivado -mode batch -source

# Open-source ECP5 flow (buttons_and_leds for now).
YOSYS ?= yosys
NEXTPNR ?= nextpnr-ecp5
ECPPACK ?= ecppack
FUJPROG ?= fujprog

# nextpnr-ecp5 device options. FPGA_SIZE uses nextpnr's 12k/25k/45k/85k names.
FPGA_SIZE ?= 85k
FPGA_SEED ?= 1
FPGA_PACKAGE = CABGA381
FPGA_FREQ = 25
FPGA_SPEED = 6

# FIXME: This is sloppy; it needs to be different for every system
# Board constraints. Set FPGA_LPF= to let nextpnr place unconstrained IO.
FPGA_LPF ?= buttons_and_leds/buttons_and_leds.lpf
NEXTPNR_LPF_FLAGS = $(if $(FPGA_LPF),--lpf $(FPGA_LPF),--lpf-allow-unconstrained)

VALID_FPGA_SIZES := 12k 25k 45k 85k
ifeq ($(filter $(FPGA_SIZE),$(VALID_FPGA_SIZES)),)
  $(error FPGA_SIZE must be one of: $(VALID_FPGA_SIZES))
endif

.PHONY: clean FORCE

clean:
	rm -f *.bin *.vcd vivado*.log vivado*.jou vivado*.str *.fst *.bit *.json *.config *.svf *.log *.checkpoint

# Force nextpnr to rerun when FPGA_* variables change; Make does not track variable values.
FORCE:

################################################################
## Buttons and LEDs
################################################################
# Use the line with the component modules in them once you start part 3 of this exercise.
BUTTONS_AND_LEDS_HDL=buttons_and_leds/buttons_and_leds.sv
# BUTTONS_AND_LEDS_HDL=$(addprefix ../components/, edge_detector.sv debouncer.sv) buttons_and_leds/buttons_and_leds.sv
BUTTONS_AND_LEDS_TOP=buttons_and_leds

test_buttons_and_leds: tests/test_buttons_and_leds.sv ${BUTTONS_AND_LEDS_HDL}
	${IVERILOG} tests/test_buttons_and_leds.sv ${BUTTONS_AND_LEDS_HDL} -o $@.bin && ${VVP} $@.bin ${VVP_POST}

waves_buttons_and_leds: test_buttons_and_leds
	${WAVES} -a tests/buttons_and_leds.gtkw buttons_and_leds.fst

buttons_and_leds.json: ${BUTTONS_AND_LEDS_HDL}
	$(YOSYS) -p "read_verilog -sv ${BUTTONS_AND_LEDS_HDL}; synth_ecp5 -top ${BUTTONS_AND_LEDS_TOP} -json $@"

buttons_and_leds.config: buttons_and_leds.json $(FPGA_LPF) FORCE
	$(NEXTPNR) --$(FPGA_SIZE) --package $(FPGA_PACKAGE) \
		--json $< --textcfg $@ \
		--freq $(FPGA_FREQ) --speed $(FPGA_SPEED) --seed $(FPGA_SEED) \
		$(NEXTPNR_LPF_FLAGS)

buttons_and_leds.bit: buttons_and_leds.config
	$(ECPPACK) --compress $< $@

program_buttons_and_leds: buttons_and_leds.bit
	${FUJPROG} $^

################################################################
## Conway's Game of Life
################################################################
# TODO(student) - add sources to the following variables based on what you use in each module.
# CONWAY_HDL=conways_game_of_life/conway_cell.sv $(addprefix ../components/, adder_1.sv)
CONWAY_HDL=conways_game_of_life/conway_cell.sv $(addprefix ../components/, adder_1.sv adder_n.sv )
LED_ARRAY_DRIVER_HDL=conways_game_of_life/led_array_driver.sv $(addprefix ../components/, decoder_1_to_2.sv decoder_2_to_4.sv decoder_3_to_8.sv)
CONWAY_SYSTEM_HDL:=${CONWAY_HDL} ${LED_ARRAY_DRIVER_HDL}  $(addprefix ../components/, pulse_generator.sv )
CONWAY_SYSTEM_HDL:=$(CONWAY_SYSTEM_HDL) $(addprefix conways_game_of_life/, conway_system.sv conway_initial_conditions.sv)

test_conway_cell: tests/test_conway_cell.sv ${CONWAY_HDL}
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}
waves_conway_cell: test_conway_cell
	gtkwave -a tests/conway_cell.gtkw conway_cell.fst

test_led_array_driver: tests/test_led_array_driver.sv tests/led_array_model.sv ${LED_ARRAY_DRIVER_HDL}
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

waves_led_array_driver: test_led_array_driver
	${WAVES} -a tests/led_array_driver.gtkw led_array_driver.fst

test_conway_system: tests/test_conway_system.sv tests/led_array_model.sv ${CONWAY_SYSTEM_HDL}
	@echo "Might take a while, we're testing a lot of clock cycles!"
	${IVERILOG} -I./conways_game_of_life $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}
# TODO(student) - make an annotated waves command that works *after* a make clean for your final signoff.

conway_system.bit: ${CONWAY_SYSTEM_HDL} conways_game_of_life/conway_system.xdc build.tcl
	SYNTH_HDL_SOURCES="${CONWAY_SYSTEM_HDL}" SYNTH_XDC_FILE=conways_game_of_life/conway_system.xdc SYNTH_TOP_MODULE=conway_system ${VIVADO} build.tcl

program_conway_system: conway_system.bit
	SYNTH_BITSTREAM=conway_system.bit ${VIVADO} program.tcl


################################################################
## UART Hello World
################################################################
UART_HELLO_WORLD_SRCS:=$(addprefix ../components/, uart_driver.sv block_rom.sv edge_detector.sv) ./uart_hello_world.sv

memories/uart_hello_world.memh: tests/generate_hello_world.py
	./tests/generate_hello_world.py --out memories/uart_hello_world.memh

test_uart_hello_world : tests/test_uart_hello_world.sv memories/uart_hello_world.memh ../components/tests/uart_tester.sv ${UART_HELLO_WORLD_SRCS}
	${IVERILOG} tests/test_uart_hello_world.sv ${UART_HELLO_WORLD_SRCS} ../components/tests/uart_tester.sv -o $@.bin && ${VVP} $@.bin ${VVP_POST}

waves_uart_hello_world: test_uart_hello_world tests/uart_hello_world.gtkw
	gtkwave uart_hello_world.fst -a tests/uart_hello_world.gtkw

uart_hello_world.bit: ${UART_HELLO_WORLD_SRCS} uart_hello_world.xdc memories/uart_hello_world.memh
	@echo "########################################"
	@echo "#### Building FPGA bitstream        ####"
	@echo "########################################"
	SYNTH_HDL_SOURCES="${UART_HELLO_WORLD_SRCS}" SYNTH_XDC_FILE=uart_hello_world.xdc SYNTH_TOP_MODULE=uart_hello_world ${VIVADO} build.tcl

program_uart_hello_world: uart_hello_world.bit
	@echo "########################################"
	@echo "#### Programming FPGA (Vivado)      ####"
	@echo "########################################"
	SYNTH_BITSTREAM=uart_hello_world.bit ${VIVADO} program.tcl
	@echo "Run 'picocom -b 115200 --omap crcrlf /dev/ttyUSBx' to test, replacing ttyUSBx with what is on your system."
