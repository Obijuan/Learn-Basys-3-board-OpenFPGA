    .include "stdio.h"

.macro ANSI_HOME
    PUTSL _ANSI_HOME
.endm

.macro ANSI_CLS
    PUTSL _ANSI_CLS
.endm

.macro ANSI_GREEN
    PUTSL _ANSI_GREEN
.endm

.macro ANSI_BLUE
    PUTSL _ANSI_BLUE
.endm

.macro ANSI_RED
    PUTSL _ANSI_RED
.endm

.macro ANSI_RESET
    PUTSL _ANSI_RESET
.endm

