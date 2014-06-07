package require -exact qsys 13.1

proc klok {} {
    add_interface clock clock end
    set_interface_property clock clockRate 0
    set_interface_property clock ENABLED true
    set_interface_property clock EXPORT_OF ""
    set_interface_property clock PORT_NAME_MAP ""
    set_interface_property clock SVD_ADDRESS_GROUP ""
    add_interface_port clock csi_clk clk Input 1
}

set_module_property DESCRIPTION ""
set_module_property NAME leds2
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Jasper
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME leds2
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL leds
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file leds.v VERILOG PATH leds.v TOP_LEVEL_FILE

klok


add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset csi_reset reset Input 1


# 
# connection point slave
# 
add_interface               s1 avalon end
set_interface_property      s1 addressUnits WORDS
set_interface_property      s1 associatedClock clock
set_interface_property      s1 associatedReset reset
set_interface_property      s1 bitsPerSymbol 8
set_interface_property      s1 burstOnBurstBoundariesOnly false
set_interface_property      s1 burstcountUnits WORDS
set_interface_property      s1 explicitAddressSpan 0
set_interface_property      s1 holdTime 0
set_interface_property      s1 linewrapBursts false
set_interface_property      s1 maximumPendingReadTransactions 0
set_interface_property      s1 readLatency 0
set_interface_property      s1 readWaitTime 1
set_interface_property      s1 setupTime 0
set_interface_property      s1 timingUnits Cycles
set_interface_property      s1 writeWaitTime 0
set_interface_property      s1 ENABLED true
set_interface_property      s1 EXPORT_OF ""
set_interface_property      s1 PORT_NAME_MAP ""
set_interface_property      s1 SVD_ADDRESS_GROUP ""
add_interface_port          s1 avs_s1_write write Input 1
add_interface_port          s1 avs_s1_writedata writedata Input 8
add_interface_port          s1 avs_s1_address address Input 4
add_interface_port          s1 avs_s1_read read Input 1
add_interface_port          s1 avs_s1_readdata readdata Output 8
set_interface_assignment    s1 embeddedsw.configuration.isFlash 0
set_interface_assignment    s1 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment    s1 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment    s1 embeddedsw.configuration.isPrintableDevice 0

add_interface           conduit_end conduit end
set_interface_property  conduit_end associatedClock clock
set_interface_property  conduit_end associatedReset ""
set_interface_property  conduit_end ENABLED true
set_interface_property  conduit_end EXPORT_OF ""
set_interface_property  conduit_end PORT_NAME_MAP ""
set_interface_property  conduit_end SVD_ADDRESS_GROUP ""
add_interface_port      conduit_end user_dataout_0 export Output 8

