// code for Avatar 2
.global _start
_start:
    LDR R0, = 0xff200020 // seven segments 0_3
    LDR R1, = 0xff200030 // seven segments 4_5
    LDR R2, = 0x00000007 // avatar 1
    LDR R3, = 0x00000038 // avatar 2

MENU:
	LDR R4, = 0xff200000 // LEDS 
	LDR R7, = 0x01
	STR R7, [R4]
	LDR R4, = 0xff200040 // switches
	LDR R7, [R4]
	CMP R7, #1
	BLT MENU // Will keep user in menu until any switch flipped

	LDR R4, = 0xff200000 // LEDS
	LDR R7, = 0x1f
	// health of Avatar 2
    STR R7, [R4] // set health equal to 5 (Binary 11111)   
	MOV R5, #0 // avatar 1 position
    MOV R6, #4 // avatar 2 position

// Begin Game
INFINITY:
    // These are the "universal" registers
    // They are set back to 0 after every iteration
    // And then "scene" is added based upon the users input
    MOV R11, #0 // Contents of 0xff200020
    MOV R12, #0 // Contents of 0xff200030
    
    MOVEMENT_AVATAR1:
	BL Fetch_Avatar_1_MOVES
    
    // Detect if user hits both
    AND R9, R7, #3
    CMP R9, #3
    BEQ END_MOVEMENT1 // if so don't move at all
	CMP R9, #0
	BEQ END_MOVEMENT1
	AND R9, R7, #1
	CMP R9, #1
	BEQ MOVERIGHT1
    
    // Move Left
    CMP R5, #5
    BEQ END_MOVE_LEFT1
    // if @ border between addresses
    CMP R5, #3
    LDREQ R2, = 0x00000007
    LSLNE R2, #8 // go to next segment
    ADDGE R12, R2
    ADDLT R11, R2
    ADD R5, #1
    B ATTACK1
    
END_MOVE_LEFT1:

MOVERIGHT1:
    // Move Right
    CMP R5, #0 
    BEQ END_MOVE_RIGHT1
    // if @ border between addresses
    CMP R5, #4
    LDREQ R2, = 0x07000000
    LSRNE R2, #8 // go to next segment
    ADDGT R12, R2
    ADDLE R11, R2
    SUB R5, #1
    B ATTACK1
    
    END_MOVE_RIGHT1:
    
END_MOVEMENT1:
    CMP R5, #4
    ADDLT R11, R2
    ADDGE R12, R2
    
ATTACK1:
// Attacking Animations
    // Attack Left
	
    AND R9, R7, #8 // above is val to display dash
    CMP R9, #8
    BEQ ATTACKLEFT1
	AND R9, R7, #4
	CMP R9, #4
	BEQ ATTACKRIGHT1
	B END_ATTACK_RIGHT1

ATTACKLEFT1:
    // Check if Avatar 1 (R5) is at Same (R6) or Right (R6-1)
    CMP R5, R6          // Check overlap
    BEQ AV1_HIT_R
    SUB R10, R6, #1     // Calculate tile to the right
    CMP R5, R10         // Check adjacent right
    BNE AV1_MISS_R
    
    AV1_HIT_R:
    BL DECREASE_HEALTH
    
    AV1_MISS_R:

    LDR R9, = 0x00000040 // Load Dash Pattern

    CMP R5, #4
    BLT ATTACK_LOW_HEX_LEFT1
    
    // attack 5-4
    SUB R8, R5, #4
    LSL R8, #3
    LSL R9, R8           // Shift the dash pattern to the correct place
    ADD R12, R9
    B END_ATTACK_RIGHT1

    // attack 3-0
    ATTACK_LOW_HEX_LEFT1:
    MOV R8, R5           // Local offset is just the position
    LSL R8, #3           // Multiply offset by 8
    LSL R9, R8
    ADD R11, R9
    B END_ATTACK_RIGHT1

ATTACKRIGHT1:
    // Attack Right

	// Check if Avatar 1 (R5) is at Same (R6) or Left (R6+1)
    CMP R5, R6          // Check overlap
    BEQ AV1_HIT_L
    ADD R10, R6, #1     // Calculate tile to the left
    CMP R5, R10         // Check adjacent left
    BNE AV1_MISS_L      // If neither, miss
	    

    AV1_HIT_L:
    BL DECREASE_HEALTH  // Call health function
    
    AV1_MISS_L:
	
    LDR R9, = 0x00000040 // Load Dash Pattern

    CMP R5, #5
    BLT ATTACK_LOW_HEX_RIGHT1
    
    // attack 5
    SUB R8, R5, #5
    LSL R8, #3
    LSL R9, R8           // Shift the dash pattern to the correct place
    ADD R12, R9
    B END_ATTACK_RIGHT1
    
    // attack 4-0
    ATTACK_LOW_HEX_RIGHT1:
    SUB R8, R5, #1          // Local offset is just the position
    LSL R8, #3           // Multiply offset by 8
    LSL R9, R8
    ADD R11, R9
    
    END_ATTACK_RIGHT1:
	// of Avatar1's moveset
    
    // Movement of Avatar 2
    MOVEMENT_AVATAR2:
    LDR R4, = 0xff200050 // pushbuttons
    
    // Detect if user hits both
    LDR R7, [R4]
	BL INPUT_SENT
    AND R9, R7, #3
    CMP R9, #3
    BEQ END_MOVEMENT2 // if so don't move at all
	CMP R9, #0
    BEQ END_MOVEMENT2 // if so don't move at all
	AND R9, R7, #1
	CMP R9, #1
	BEQ MOVERIGHT2
    
    // Move Left
    LDR R7, [R4] // switches val -> R4
    AND R7, #2 // BITWISE operation
    CMP R7, #2 // check if move left push buttons high
    BNE END_MOVE_LEFT2
    CMP R6, #5
    BEQ END_MOVE_LEFT2
    // if @ border between addresses
    CMP R6, #3
    LDREQ R3, = 0x00000038
    LSLNE R3, #8 // go to next segment
    ADDGE R12, R3
    ADDLT R11, R3
    ADD R6, #1
    B ATTACK2
    
    END_MOVE_LEFT2:
    
MOVERIGHT2:
    // Move Right
    LDR R7, [R4]
    AND R7, #1 // BITWISE operation
    CMP R7, #1 // check if move right push buttons high
    BNE END_MOVE_RIGHT2
    CMP R6, #0 
    BEQ END_MOVE_RIGHT2
    // if @ border between addresses
    CMP R6, #4
    LDREQ R3, = 0x38000000
    LSRNE R3, #8 // go to next segment
    ADDGT R12, R3
    ADDLE R11, R3
    SUB R6, #1
    B ATTACK2
    
    END_MOVE_RIGHT2:
    
END_MOVEMENT2:
    CMP R6, #4
    ADDLT R11, R3
    ADDGE R12, R3
    
ATTACK2:
// Attacking Animations
    // Attack Left 
    AND R9, R7, #8 // above is val to display dash
    CMP R9, #8
    BEQ ATTACKLEFT2
	AND R9, R7, #4 // above is val to display dash
    CMP R9, #4
    BEQ ATTACKRIGHT2
	B END_ATTACK_RIGHT2
   
ATTACKLEFT2:
    LDR R9, = 0x00000040 // Load Dash Pattern

    CMP R6, #3
    BLT ATTACK_LOW_HEX_LEFT2
    
    // attack 5-3
    SUB R8, R6, #3
    LSL R8, #3
    LSL R9, R8           // Shift the dash pattern to the correct place
    ADD R12, R9
    B END_ATTACK_RIGHT2

    // attack 2-0
    ATTACK_LOW_HEX_LEFT2:
    ADD R8, R6, #1           // Local offset is just the position
    LSL R8, #3           // Multiply offset by 8
    LSL R9, R8
    ADD R11, R9
	B END_ATTACK_RIGHT2
    
    END_ATTACK_LEFT2:
    
    // Attack Right

ATTACKRIGHT2:
    LDR R9, = 0x00000040 // Load Dash Pattern

    CMP R6, #4
    BLT ATTACK_LOW_HEX_RIGHT2
    
    // attack 5-4
    SUB R8, R6, #4
    LSL R8, #3
    LSL R9, R8           // Shift the dash pattern to the correct place
    ADD R12, R9
    B END_ATTACK_RIGHT2
    
    // attack 3-0
    ATTACK_LOW_HEX_RIGHT2:
    SUB R8, R6, #0       // Local offset is just the position
    LSL R8, #3           // Multiply offset by 8
    LSL R9, R8
    ADD R11, R9
    
    END_ATTACK_RIGHT2:

DISPLAY:
    STR R11, [R0]   // Write to HEX0-3
    STR R12, [R1]   // Write to HEX4-5

	LDR R4, = 0xff200000
	LDR R8, [R4]
	CMP R8, #0 // if health reaches zero
	BLEQ ENDGAME_YOULOSE
	BLEQ Reset // resets contents of registers
	BEQ MENU

	MOV R9, #0 // value to determine if WIN
	BL Determine_WIN
    CMP R9, #1
	BLEQ WIN_Flash
	BLEQ Reset // resets contents of registers
	BEQ MENU
	
	BL DELAY
    B INFINITY

.type Determine_WIN %function
Determine_WIN:
	PUSH {R0-R4, LR}
	LDR R0, = 0xFF200070 // Address of JP2
	ADD R1, R0, #4 // Base address added by 4 to get new address
	LDR R2, = 0x00F // set all but output bits low
	STR R2, [R1]
	LDR R2, [R0]
	LSR R2, #8
	CMP R2, #1
	MOVEQ R9, #1
	POP {R0-R4, LR}
	BX LR

.type ENDGAME %function
ENDGAME_YOULOSE:
	PUSH {R0-R4}
	LDR R0, = 0xFF200070 // Address of JP2
	ADD R3, R0, #4 // Base address added by 4 to get new address
	LDR R1, = 0x100 // set end bit high
	STR R3, [R4] // declaring bit as output
	STR R1, [R4] // send loser bit
	
	POP {R0-R4}
	BX LR


// Delay function
.type DELAY %function
DELAY:
    PUSH {R0-R4}
    
    LDR R1, = 0xfffec600 // timer address
    LDR R4,= 0x0BEBC200
    STR R4, [R1] // set load equal to 0x0BEBC200
    MOV R4, #1 
    STR R4, [R1, #0x0C] // set f = 1
    MOV R4, #1
    STR R4, [R1, #0x08] // set e = 1
LOOP:
    LDR R4, [R1, #0x0C] // check f = 0
    CMP R4, #1
    BNE LOOP

    POP {R0-R4}
    BX lr

.type DECREASE_HEALTH %function
DECREASE_HEALTH:
    PUSH {R4, R7, LR}    // Save registers we are about to use
    
    LDR R4, = 0xff200000 // Address of LEDs
    LDR R7, [R4]         // Load current health value
    
    CMP R7, #0           // Check if health is already 0
    BEQ SKIP_DAMAGE      // If 0, do nothing (Dead)
    
    LSR R7, #1           // Logical Shift Right (e.g., 11111 -> 01111)
    STR R7, [R4]         // Store updated health back to LEDs
    
SKIP_DAMAGE:
    POP {R4, R7, LR}     // Restore registers
    BX LR                // Return

// this functions reads out movement of board
.type INPUT_SENT %function
INPUT_SENT:
    PUSH {R0,R1,R3, LR}    // Save registers we are about to use
   
    LDR R0, = 0xFF200070 // Address of JP2
	ADD R3, R0, #4 //Base address added by 4
	MOV R1, #0x0F //Used set the bits
	STR R1, [R3] //Sets Directional bits to high
	STR R7, [R0] // sends data of pushbuttons to JP2

    POP {R0,R1,R3, LR}     // Restore registers
    BX LR                // Return

// this functions reads out movement of board
// contents will be stored in R7
// this program takes pins 4 - 8 as input from board 1
// 
.type Fetch_Avatar_1_MOVES %function
Fetch_Avatar_1_MOVES:
	PUSH {R0, R1, R2, R3, LR}
	LDR R4, = 0xFF200070 // JP2 address
	LDR R0, [R4]
	LSR R0, #4 // get 3-7 bits
	MOV R7, R0	

	POP {R0, R1, R2, R3, LR}
	BX LR

// Delay function
.type DELAY_1ms %function
DELAY_1ms:
    PUSH {R0-R4}
   
    LDR R1, = 0xfffec600 // timer address
    LDR R4,= 0x30D40
    STR R4, [R1] // set load equal to 0x0BEBC200
    MOV R4, #1
    STR R4, [R1, #0x0C] // set f = 1
    MOV R4, #1
    STR R4, [R1, #0x08] // set e = 1
LOOP_1ms:
    LDR R4, [R1, #0x0C] // check f = 0
    CMP R4, #1
    BNE LOOP_1ms

    POP {R0-R4}
    BX lr

.type WIN_Flash %function
WIN_Flash:
	Push {R0-R3, LR}

	LDR R0, = 0xFF200000 //Loads the LEDs
	LDR R1, = 0x3FF
	MOV R2, #0
	MOV R3,#20

Flashloop:
	STR R1, [R0] // All LEDS
	BL DELAY_1ms
	STR R2,[R0] //Turn off
	CMP R3,#0
	BEQ STOPFlash
	SUB R3, #1
	b Flashloop
STOPFlash:
	pop {R0-R3,LR}
	BX lr

.type Reset %function
Reset:
	Push {R0-R4, LR}
	LDR R4, = 0x00000000 // used to clear contents of addresses
	LDR R0, = 0xFF200000
	STR R4, [R0] // set LEDs equal to zero
	LDR R0, = 0xff200020
	STR R4, [R0]
	LDR R0, = 0xff200030 
	STR R4, [R0]
	LDR R0, = 0xFF200070
	STR R4, [R0]
	POP {R0-R4,LR}
	BX LR
