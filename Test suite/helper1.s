; helper1.s
; Version 1.0
; https://github.com/richardcavell/6809-strlen
;
; A 6809 assembly routine to help with the testing of strlen.s
;
; Written by Richard John Foster Cavell (c) 2017.
; Licensed to you under the MIT License.
;
; Inputs:
; Memory location $2FFC (2 bytes) = Pointer to the strlen routine.
; Memory location $2FFE (2 bytes) = Pointer to the string.
;
; Outputs:
; Memory location $2FFE (2 bytes) = Length of the string.
;
; This code may be placed anywhere in memory, so it is position-independent.
; It is re-entrant. But the memory locations $2FFC and $2FFE are
; hard-coded below. Interrupts are allowed to occur during execution.
; It uses 6 bytes of the System stack, in addition to the 2 bytes used
; for the return address
;
; The pointers are stored in big-endian order (the 6809's natural method).
;
; Issues:
; If ($2FFC:$2FFD) does not point to a valid routine, the
;   behaviour is undefined.
; If ($2FFE:$2FFF) does not point to a valid string, the
;   behaviour is undefined.
;   If there is no terminating null byte, the code might access forbidden
;     areas of the memory map.
;   It is possible for X to wrap (say from $FFFF to $0000). This code makes
;     no attempt to detect this possibility, because the behaviour may be
;     desirable.

  ORG $3100   ; Change all the locations if you have <16K RAM

_helper1
_helper1_start
_helper1_entry

  PSHS X,A,B  ; Preserve registers
  LDX $2FFE   ; Pull the pointer from memory into register X
  JSR [$2FFC] ; Execute strlen
  STD $2FFE   ; Store the result in memory
  PULS X,A,B  ; Restore registers

  RTS         ; Return to BASIC

_helper1_end
