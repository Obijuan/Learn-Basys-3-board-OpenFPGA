#-- Cadenas con codigos ANSI
.global _ANSI_HOME
.global _ANSI_CLS
.global _ANSI_GREEN
.global _ANSI_BLUE
.global _ANSI_RED
.global _ANSI_RESET

.data
_ANSI_HOME:  .string "\033[H"
_ANSI_CLS:   .string "\033[2J" 
_ANSI_GREEN: .string "\033[0;32m"
_ANSI_BLUE:  .string "\033[0;34m"
_ANSI_RED:   .string "\033[0;31m"
_ANSI_RESET: .string "\033[0m"
