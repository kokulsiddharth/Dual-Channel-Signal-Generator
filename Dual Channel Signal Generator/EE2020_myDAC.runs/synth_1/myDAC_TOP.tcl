# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.cache/wt [current_project]
set_property parent.project_path C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/new/dff.v
  C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/new/SAMP_CLOCK.v
  C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/new/NEW_CLOCK.v
  C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/new/maindff.v
  C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/new/HALF_CLOCK.v
  C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/new/sevensegment.v
  C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/imports/sources_1/new/myDAC_TOP.v
}
read_vhdl -library xil_defaultlib C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/sources_1/imports/sources_1/imports/SourceFiles/DA2RefComp.vhd
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/constrs_1/imports/_solution_files/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/Kokul/Desktop/EE2020_KokulDAC/EE2020_myDAC.srcs/constrs_1/imports/_solution_files/Basys3_Master.xdc]


synth_design -top myDAC_TOP -part xc7a35tcpg236-1


write_checkpoint -force -noxdef myDAC_TOP.dcp

catch { report_utilization -file myDAC_TOP_utilization_synth.rpt -pb myDAC_TOP_utilization_synth.pb }