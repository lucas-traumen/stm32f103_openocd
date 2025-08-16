/* stm32f103c8.ld - Linker script cho STM32F103C8 (64KB Flash, 20KB RAM) */

MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 64K
  RAM   (rwx): ORIGIN = 0x20000000, LENGTH = 20K
}

/* stack/heap sizes (tùy chỉnh) */
__StackSize = 0x00000400; /* 1KB stack reserve */
__HeapSize  = 0x00000200; /* 512 bytes heap */

SECTIONS
{
  /* Vector table placed at start of FLASH */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector))      /* giữ vector table dù gc-sections */
    . = ALIGN(4);
  } > FLASH

  /* code + rodata */
  .text :
  {
    . = ALIGN(4);
    *(.text*)                 /* all .text sections (startup, C code) */
    *(.rodata*)               /* read-only data */
    *(.glue_7) *(.glue_7t)
    . = ALIGN(4);
  } > FLASH

  /* init values for .data (in FLASH) */
  _sidata = LOADADDR(.data);

  /* data in RAM (copied from _sidata) */
  .data : AT (ADDR(.text) + SIZEOF(.text))
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } > RAM

  /* bss */
  .bss (NOLOAD) :
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } > RAM

  /* heap & stack space (optional region) */
  ._user_heap_stack :
  {
    . = ALIGN(4);
    __heap_start = .;
    . = . + __HeapSize;
    __heap_end = .;
    __stack_start = .;
    . = . + __StackSize;
    __stack_end = .;
    . = ALIGN(4);
  } > RAM

  /* end of sections */
  PROVIDE(end = .);
}

/* Symbols for startup file */
_estack = ORIGIN(RAM) + LENGTH(RAM); /* top of RAM: stack start */

/* Export common symbols used in startup code */
PROVIDE(_sidata = _sidata);
PROVIDE(_sdata  = _sdata);
PROVIDE(_edata  = _edata);
PROVIDE(_sbss   = _sbss);
PROVIDE(_ebss   = _ebss);
PROVIDE(_estack = _estack);
