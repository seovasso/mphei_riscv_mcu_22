@ECHO OFF
SET openocd_path="%~dp0..\openocd_syntacore"

START "openOCD" %openocd_path%\src\openocd.exe ^
-f %openocd_path%/tcl/interface/ftdi/olimex-arm-usb-ocd-h.cfg ^
-f %openocd_path%/tcl/target/syntacore_scr4_scr1.cfg ^
-c "debug_level 0;init;halt;"

START "PuTTY" putty/plink.exe -telnet -P 4444 localhost
