# TCL File Generated by Component Editor 13.0sp1
# Tue Apr 08 00:13:46 CEST 2014
# DO NOT MODIFY


# 
# myrtc "myrtc" v1.0
#  2014.04.08.00:13:46
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module myrtc
# 
set_module_property DESCRIPTION ""
set_module_property NAME myrtc
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Jasper
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME myrtc
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL myrtc
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file myrtc.vhd VHDL PATH myrtc.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point slave
# 
add_interface slave avalon end
set_interface_property slave addressUnits WORDS
set_interface_property slave associatedClock clock
set_interface_property slave associatedReset reset
set_interface_property slave bitsPerSymbol 8
set_interface_property slave burstOnBurstBoundariesOnly false
set_interface_property slave burstcountUnits WORDS
set_interface_property slave explicitAddressSpan 0
set_interface_property slave holdTime 0
set_interface_property slave linewrapBursts false
set_interface_property slave maximumPendingReadTransactions 0
set_interface_property slave readLatency 0
set_interface_property slave readWaitTime 1
set_interface_property slave setupTime 0
set_interface_property slave timingUnits Cycles
set_interface_property slave writeWaitTime 0
set_interface_property slave ENABLED true
set_interface_property slave EXPORT_OF ""
set_interface_property slave PORT_NAME_MAP ""
set_interface_property slave SVD_ADDRESS_GROUP ""

add_interface_port slave slave_address address Input 4
add_interface_port slave slave_readdata readdata Output 8
set_interface_assignment slave embeddedsw.configuration.isFlash 0
set_interface_assignment slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1

