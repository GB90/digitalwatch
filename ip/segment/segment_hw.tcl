# TCL File Generated by Component Editor 13.0sp1
# Tue Mar 04 18:55:14 CET 2014
# DO NOT MODIFY


# 
# segment "segment" v1.0
#  2014.03.04.18:55:14
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module segment
# 
set_module_property DESCRIPTION ""
set_module_property NAME segment
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Jasper
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME segment
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL segment
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file segment.v VERILOG PATH segment.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


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
# connection point en
# 
add_interface en conduit end
set_interface_property en associatedClock clock
set_interface_property en associatedReset reset
set_interface_property en ENABLED true
set_interface_property en EXPORT_OF ""
set_interface_property en PORT_NAME_MAP ""
set_interface_property en SVD_ADDRESS_GROUP ""

add_interface_port en en readdata Output 8


# 
# connection point seg_data
# 
add_interface seg_data conduit end
set_interface_property seg_data associatedClock clock
set_interface_property seg_data associatedReset reset
set_interface_property seg_data ENABLED true
set_interface_property seg_data EXPORT_OF ""
set_interface_property seg_data PORT_NAME_MAP ""
set_interface_property seg_data SVD_ADDRESS_GROUP ""

add_interface_port seg_data seg_data readdata Output 8


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
add_interface_port slave slave_read read Input 1
add_interface_port slave slave_write write Input 1
add_interface_port slave slave_readdata readdata Output 64
add_interface_port slave slave_writedata writedata Input 64
add_interface_port slave slave_byteenable byteenable Input 8
set_interface_assignment slave embeddedsw.configuration.isFlash 0
set_interface_assignment slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment slave embeddedsw.configuration.isPrintableDevice 0

