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
        LDA #$70
        STA COLUBK
    	LDA #2
        STA VBLANK 
        STA VSYNC  
        STA WSYNC
        STA WSYNC
        STA WSYNC
        LDA #0
        STA VSYNC 
        LDX #36
        
VBlankLoop:
	STA WSYNC
        DEX
        BNE VBlankLoop          
        LDA #$ff
        STA PF0
        STA PF1
        STA PF2
        LDA #$2E
        STA COLUPF
        STA WSYNC
        LDA #0
        STA VBLANK
        LDX #10
        
BorderTop:
	STA WSYNC
        DEX
        BNE BorderTop
        LDA $01
        STA CTRLPF
	LDA $10
	STA PF0
        LDA #0
        STA PF1
        STA PF2
        LDX #172
        
BorderMiddle:
	STA WSYNC
        DEX
        BNE BorderMiddle
        LDA #$ff
        STA PF0
        STA PF1
        STA PF2
        LDX #10
        
BorderBottom:
    	STA WSYNC
        DEX
        BNE BorderBottom        
        LDA #2
        STA VBLANK 
        LDX #30
        
OverscanLoop:
	STA WSYNC
        DEX 
        BNE OverscanLoop

	JMP NextFrame
	
	ORG $fffc
	.word Start
	.word Start
