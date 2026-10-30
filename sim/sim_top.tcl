	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB				"test_top"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"100 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/approx_mult.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/array_multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/bram_inp.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/bram_out.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/ControlUnit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/counter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/shift_register.v
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


#	add wave -hex -group 	 	{TB}				sim:/$TB/*
#	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
#	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
#	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	