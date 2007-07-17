CC	= iverilog
SIM = vvp

CFLAGS =-Irtl/

vpath %.v rtl tb
vpath %.vh rtl

.PHONY: all sim doc clean

all: sim


sim: fifo const_enc


const_enc: const_enc.vvp
	@echo -e "\n--> Simulating $@"
	$(SIM) $^

const_enc.vvp: const_enc.v tb_const_enc.v
	$(CC) $(CFLAGS) $^ -s tb_const_encoder -o $@

fifo: fifo.vvp
	@echo -e "\n--> Simulating $@"
	$(SIM) $^
	
fifo.vvp: fifo.v tb_fifo.v generic_dpram.v
	@echo -e "\n--> Compiling $@"
	$(CC) $(CFLAGS) $^ -s tb_fifo -o $@

doc:
	$(MAKE) -C doc/


clean:
	rm -f *.vvp
	$(MAKE) -C doc/ cleantex
