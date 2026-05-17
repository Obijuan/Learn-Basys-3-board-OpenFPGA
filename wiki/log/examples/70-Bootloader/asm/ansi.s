#-- Cadenas con codigos ANSI
.global _ANSI_HOME
.global _ANSI_CLS
.global _ANSI_GREEN
.global _ANSI_BLUE
.global _ANSI_RED
.global _ANSI_RESET
.global _ANSI_RGB
.global _ESC
.global _ANSI_HIDE_CURSOR
.global _ANSI_SHOW_CURSOR
.global _ANSI_BACKGROUND_BLACK
.global _ANSI_FOREGROUND_WHITE


.data
_ESC: .string "\033["
_ANSI_HOME:  .string "\033[H"
_ANSI_CLS:   .string "\033[2J" 
_ANSI_GREEN: .string "\033[0;32m"
_ANSI_BLUE:  .string "\033[0;34m"
_ANSI_RED:   .string "\033[0;31m"
_ANSI_RESET: .string "\033[0m"
_ANSI_RGB:   .string "\033[48;2;"
_ANSI_HIDE_CURSOR:  .string "\033[?25l"
_ANSI_SHOW_CURSOR:  .string "\033[?25h"
_ANSI_BACKGROUND_BLACK: .string "\033[48;5;16m"
_ANSI_FOREGROUND_WHITE: .string "\033[38;5;15m"
 
