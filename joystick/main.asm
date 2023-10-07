	processor 6502
	include "vcs.h"
	
	seg.u Variables
	ORG  $80
	
Player0XPos .byte
Player0YPos .byte
	
	seg Code
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
        
        
        ; Set Player 1 Position
	LDA #40
	STA Player0YPos
	LDA #35
	STA Player0XPos

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
        LDA Player0XPos
        LDY #0
        JSR SetXPos
        STA WSYNC
        STA HMOVE      
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
        LDX Player0YPos
        
BorderMiddleTop:
	STA WSYNC
        DEX
        BNE BorderMiddleTop
        LDA #$32
        STA COLUP0
        LDX #8
        
DrawSprite:
	STA WSYNC
        LDA Player0,X
        STA GRP0
        LDA ColorPlayer0,X
        STA COLUP0
        DEX
        BNE DrawSprite
        STA WSYNC
        LDA #0
        STA GRP0
        LDA #$70
        STA COLUBK
        LDA #192
        SBC #10
        SBC #8
        SBC #8
        SBC Player0YPos
        TAX
        
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
        
JoystickPlayer0Up:
	LDA #%00100000
	BIT SWCHA
	BNE JoystickPlayer0Down
	INC Player0YPos

JoystickPlayer0Down:
	LDA #%00010000
	BIT SWCHA
	BNE JoystickPlayer0Left
	DEC Player0YPos

JoystickPlayer0Left:
	LDA #%01000000
	BIT SWCHA
	BNE JoystickPlayer0Right
	DEC Player0XPos

JoystickPlayer0Right:
	LDA #%10000000
	BIT SWCHA
	BNE JoystickPlayer0NoInput
	INC Player0XPos

JoystickPlayer0NoInput:
        
        
	JMP NextFrame
	
SetXPos:
	STA WSYNC
	SEC
Div15Loop:
	SBC #15
	BCS Div15Loop
	EOR #7
	ASL
	ASL
	ASL
	ASL
	STA HMP0,Y
	STA RESP0,Y
	RTS
	
Player0:
        .byte #%00011000;
        .byte #%00011000;
        .byte #%00011000;
        .byte #%00011000;
        .byte #%11111111;
        .byte #%11111111;
        .byte #%00011000;
        .byte #%00011000;
        .byte #%00011000;

ColorPlayer0:
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
