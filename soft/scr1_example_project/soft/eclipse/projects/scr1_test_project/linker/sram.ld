OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY {
	PM_RAM (rwx) : ORIGIN = 0xf0000000, LENGTH = 60K
	DM_RAM (rwx) : ORIGIN = 0xf000F000, LENGTH = 4K
}

STACK_SIZE = 1024;

SECTIONS {
	
	.init ORIGIN(PM_RAM):
	{
		. = 0x200;
		*(.init.startup)
    	. = ALIGN(64);
    	*(.init.traphandler)
    	. = ALIGN(4);
	} >PM_RAM
	
	.text : 
    {
        *(.text*)
        . = ALIGN(4);
        *(.rodata .rodata.*)
		. = ALIGN(4);
    } >PM_RAM

  	.data : {
  		_sdata = .;
  		_ldata = LOADADDR(.data);
    	*(.data .data.*)
    	*(.sdata .sdata.*)
    	. = ALIGN(4);
    	_edata = .;
    	_end = .;
  	} >DM_RAM AT>PM_RAM

	.bss : {
  		_sbss = .;
    	*(.bss .bss.*)
    	. = ALIGN(4);
    	*(.sbss .sbss.*)
    	. = ALIGN(4);
    	_ebss = .;
  	} >DM_RAM
  	
  	.stack ORIGIN(DM_RAM) + LENGTH(DM_RAM) - STACK_SIZE : {
  		PROVIDE(__STACK_START__ = .);
    	. += STACK_SIZE;
    	PROVIDE(__C_STACK_TOP__ = .);
  	} >DM_RAM

  	/DISCARD/ : {
    	*(.eh_frame .eh_frame.*)
  	}
}
