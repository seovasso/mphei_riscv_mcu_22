@ECHO OFF

SET openocd_path="%~dp0..\openocd_syntacore"

%openocd_path%\src\openocd.exe -f %openocd_path%/tcl/interface/ftdi/olimex-arm-usb-ocd-h.cfg -f %openocd_path%/tcl/target/syntacore_riscv.cfg -c "debug_level 0;init;halt"

pause

EXIT /B