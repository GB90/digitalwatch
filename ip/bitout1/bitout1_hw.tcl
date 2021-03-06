# Jasper ter Weeme

package require -exact qsys 13.1

source ../common.tcl

mymodule bitout1 bitout1

add_fileset_file bitout1.v VERILOG PATH bitout1.v TOP_LEVEL_FILE

add_interface               clock clock end
set_interface_property      clock clockRate 0
set_interface_property      clock ENABLED true
set_interface_property      clock EXPORT_OF ""
set_interface_property      clock PORT_NAME_MAP ""
set_interface_property      clock SVD_ADDRESS_GROUP ""
add_interface_port          clock csi_clk clk Input 1

add_interface               reset reset end
set_interface_property      reset associatedClock clock
set_interface_property      reset synchronousEdges DEASSERT
set_interface_property      reset ENABLED true
set_interface_property      reset EXPORT_OF ""
set_interface_property      reset PORT_NAME_MAP ""
set_interface_property      reset SVD_ADDRESS_GROUP ""
add_interface_port          reset csi_reset reset Input 1

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
add_interface_port          s1 avs_s1_writedata writedata Input 32
add_interface_port          s1 avs_s1_address address Input 2
add_interface_port          s1 avs_s1_read read Input 1
add_interface_port          s1 avs_s1_readdata readdata Output 32
set_interface_assignment    s1 embeddedsw.configuration.isFlash 0
set_interface_assignment    s1 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment    s1 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment    s1 embeddedsw.configuration.isPrintableDevice 0

add_interface               conduit_end conduit end
set_interface_property      conduit_end associatedClock clock
set_interface_property      conduit_end associatedReset reset
set_interface_property      conduit_end ENABLED true
set_interface_property      conduit_end EXPORT_OF ""
set_interface_property      conduit_end PORT_NAME_MAP ""
set_interface_property      conduit_end SVD_ADDRESS_GROUP ""
add_interface_port          conduit_end coe_bit export Output 1



