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
        LDX #8
        
HorizontalLoop:
        DEX
        BNE HorizontalLoop
        STA RESP0
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
        LDX #82
        
BorderMiddleTop:
	STA WSYNC
        DEX
        BNE BorderMiddleTop
        LDX #8
        
DrawSprite:
	STA WSYNC
        LDA #$70
        STA COLUBK
        LDA Player1,X
        STA GRP0
        LDA ColorPlayer1,X
        STA COLUP0
        DEX
        BNE DrawSprite
        STA WSYNC
        LDA #0
        STA GRP0
        LDX #91
        
BorderMiddleBottom:
	STA WSYNC
        DEX
        BNE BorderMiddleBottom
        LDA #$ff
        STA PF0
        STA PF1
        STA PF2
        LDA #$2E
        STA COLUPF
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
	
Player1:
        .byte #%00011000;
        .byte #%00011000;
        .byte #%00011000;
        .byte #%00011000;
        .byte #%11111111;
        .byte #%11111111;
        .byte #%00011000;
        .byte #%00011000;
        .byte #%00011000;

ColorPlayer1:
	.byte #$30;
        .byte #$30;
        .byte #$30;
        .byte #$30;
        .byte #$30;
        .byte #$30;
        .byte #$30;
        .byte #$30;
        .byte #$30;
	
	ORG $fffc
	.word Start
	.word Start
