	processor 6502
	include "vcs.h"
	ORG  $f000

Start:
	SEI
	CLD
        LDX #$ff 
        TXS 
        LDA #0
        LDX #$ff
        	
ClearZeroPage:
	STA $0,X
	DEX
        BNE ClearZeroPage

NextFrame:
        LDA #$D0
        STA COLUBK
	JMP NextFrame
	
	
	ORG $fffc
	.word Start
	.word Start
