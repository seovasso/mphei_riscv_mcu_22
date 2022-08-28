@ECHO OFF

IF [%1]==[] (
    ECHO Missing firmware file argument
    GOTO :print_help
)

SET firmware="%1"
SET firmware=%firmware:\=/%
SET address=0
SET openocd_path="%~dp0..\openocd_syntacore"

%openocd_path%\src\openocd.exe -f %openocd_path%/tcl/interface/ftdi/olimex-arm-usb-ocd-h.cfg -f %openocd_path%/tcl/target/syntacore_scr4_scr1.cfg -c "debug_level 0;init;halt;load_image %firmware% %address%;resume 0x200200;exit"
pause

EXIT /B

:print_help
ECHO Usage: flash_firmware.cmd firmware [address]
EXIT /B
