	.data

face0:	.string "000000000" ;
face1:	.string "000000000" ;
face2:	.string "000000000" ;
face3:	.string "000000000" ;
face4:	.string "000000000" ;
face5:	.string "000000000" ;
faceEX:	.string "000000000" ,0 ;

firstFlag:	.string '1' ,0;

squire:	.string "  " ,0 ;
cursor11:			.string 27,"[1;1H", 0
cursor14:			.string 27,"[1;4H", 0
cursor17:			.string 27,"[1;7H", 0

cursor71:			.string 27,"[7;1H", 0
cursor131:			.string 27,"[13;1H", 0

cursor121:			.string 27,"[1;21H", 0
cursor921:			.string 27,"[9;21H", 0

cursorup:			.string 27,"[1A", 0
cursordown:			.string 27,"[1B", 0
cursorright2:		.string 27,"[2C", 0
cursorleft2:		.string 27,"[2D", 0

cursorup3:			.string 27,"[3A", 0
cursordown3:		.string 27,"[3B", 0
cursorright4:		.string 27,"[4C", 0
cursorleft4:		.string 27,"[4D", 0
cursorright6:		.string 27,"[6C", 0
cursorleft6:		.string 27,"[6D", 0

location:			.string	"11" ,0 		; This is location of node
charColor:			.string	"0" ,0 			; This is color of node

animType:			.string	"0" ,0 			;
animdirect:			.string	"0" ,0 			;
animTimer:			.string	"0" ,0 			;

scoreText:			.string "SCORE: " ,0	;
scoreIntValue:		.string "00" ,0			;
scoreStringValue:	.string "0000" ,0		;
timeText:			.string "Time: " ,0		;
timeIntValue:		.string "00" ,0	   		;
timeStringValue:	.string "0000" ,0	   	;
pauseText:			.string "PAUSE" ,0		;

keyWState:			.string "0" ,0	   		;
keyAState:			.string "0" ,0	   		;
keySState:			.string "0" ,0	   		;
keyDState:			.string "0" ,0	   		;
keySpaceState:		.string "0" ,0	   		;
keyWFlag:			.string "0" ,0	   		;
keyAFlag:			.string "0" ,0	   		;
keySFlag:			.string "0" ,0	   		;
keyDFlag:			.string "0" ,0	   		;
keySpaceFlag:		.string "0" ,0	   		;
currentInputValue	.string "0" ,0	   		;
gameStateFlag:		.string "0" ,0		   	; This is flag to show the game is over or not 1->Over 0->Looping

redPrefix: 		.string 27, "[41m" ,0
bluePrefix: 	.string 27, "[44m" ,0
greenPrefix: 	.string 27, "[42m" ,0
purplePrefix: 	.string 27, "[45m" ,0
yellowPrefix: 	.string 27, "[43m" ,0
whitePrefix: 	.string 27, "[47m" ,0
blackPrefix: 	.string 27, "[40m" ,0

front_up_down_left_right_back_id:	.string "012345" ,0
front_up_down_left_right_back_id_ex:	.string "000000" ,0

secondTime 	.string "00" ,0	   		;



	.text

ptr_to_face0:	.word face0
ptr_to_face1:	.word face1
ptr_to_face2:	.word face2
ptr_to_face3:	.word face3
ptr_to_face4:	.word face4
ptr_to_face5:	.word face5
ptr_to_faceEX:	.word faceEX

ptr_to_firstFlag:	.word firstFlag

ptr_to_squire:		.word squire
ptr_to_cursor11:	.word cursor11
ptr_to_cursor921:	.word cursor921
ptr_to_cursor121:	.word cursor121

ptr_to_cursorup:		.word cursorup
ptr_to_cursordown:		.word cursordown
ptr_to_cursorleft2:		.word cursorleft2
ptr_to_cursorright2:	.word cursorright2

ptr_to_cursorup3:		.word cursorup3
ptr_to_cursordown3:		.word cursordown3
ptr_to_cursorleft4:		.word cursorleft4
ptr_to_cursorright4:	.word cursorright4
ptr_to_cursorleft6:		.word cursorleft6
ptr_to_cursorright6:	.word cursorright6


ptr_to_keyWFlag:	.word keyWFlag
ptr_to_keyAFlag:	.word keyAFlag
ptr_to_keySFlag:	.word keySFlag
ptr_to_keyDFlag:	.word keyDFlag
ptr_to_keySpaceFlag:	.word keySpaceFlag

ptr_to_keyWState:	.word keyWState
ptr_to_keyAState:	.word keyAState
ptr_to_keySState:	.word keySState
ptr_to_keyDState:	.word keyDState
ptr_to_keySpaceState:	.word keySpaceState

ptr_to_currentInputValue:	.word currentInputValue

ptr_to_location:			.word location
ptr_to_charColor:			.word charColor
ptr_to_scoreText:			.word scoreText
ptr_to_scoreValue:			.word scoreIntValue
ptr_to_scoreStringValue:	.word scoreStringValue
ptr_to_timeText:			.word timeText
ptr_to_timeValue:			.word timeIntValue
ptr_to_timeStringValue:		.word timeStringValue
ptr_to_gameStateFlag:		.word gameStateFlag

ptr_to_redPrefix:		.word redPrefix
ptr_to_bluePrefix:		.word bluePrefix
ptr_to_greenPrefix:		.word greenPrefix
ptr_to_purplePrefix:	.word purplePrefix
ptr_to_yellowPrefix:	.word yellowPrefix
ptr_to_whitePrefix:		.word whitePrefix
ptr_to_blackPrefix:		.word blackPrefix

ptr_to_front_up_down_left_right_back_id	.word front_up_down_left_right_back_id
ptr_to_front_up_down_left_right_back_id_ex	.word front_up_down_left_right_back_id_ex

ptr_to_secondTime 		.word secondTime


	.global lab7
	.global Timer_Handler

lab7:
	PUSH {r4-r12,lr}

	BL uart_init
	BL gpio_btn_and_LED_init
	BL time_interrupt_init

	LDR r0, ptr_to_gameStateFlag

restart:

	LDR r0, ptr_to_gameStateFlag ;Initialize gameStateFlag; 0 -> keep loop 5-> gameover
	MOV r1, #0
	STRB r1, [r0]

	LDR r0, ptr_to_scoreValue ;Initialize scoreValue; store int value of score
	MOV r1, #0xFFFF
	MOVT r1, #0xFFFF
	STRH r1, [r0]

	LDR r0, ptr_to_timeValue ;Initialize scoreValue; store int value of score
	MOV r1, #0x0
	STRH r1, [r0]

	LDR r0, ptr_to_secondTime ;Initialize scoreValue; store int value of score
	MOV r1, #0x0
	MOVT r1, #0x0
	STRH r1, [r0]


	LDR r0, ptr_to_cursor11 ;Initialize time 0
	BL output_string

	BL make_random_cube




lab_loop:
	LDR r10, ptr_to_gameStateFlag
	LDRB r11, [r10]

	BL get_input_flag

	CMP r11, #5
	BNE lab_loop

	POP {r4-r12, lr}	; Restore registers to adhere to the AAPCS
	MOV pc, lr







Timer_Handler:

	PUSH {r4-r12,lr}

	; disable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		AND r0, #0xFE
		STR r0, [r1, #0x00C]

	; set Clear Interrupts
		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x0024
		MOVT r7, #0x4003
		LDR r8, [r7, #0]
		ORR r8, #0x1
		STR r8, [r7, #0]


;update
		BL get_current_input_value
		BL update_input_state

		LDR r0, ptr_to_timeValue
		LDRH r4, [r0]
		ADD r4, r4, #1
		STRH r4, [r0]

		CMP r4, #30
		BEQ add1sec
		BL passAdd1sec

add1sec:
		LDR r0, ptr_to_timeValue
		MOV r4, #0
		STRH r4, [r0]

		LDR r0, ptr_to_secondTime ;Initialize scoreValue; store int value of score
		LDR r4, [r0]
		ADD r4, r4, #1
		STRH r4, [r0]

passAdd1sec:

		LDR r1, ptr_to_currentInputValue
		LDRB r0, [r1]
		CMP r0, #0x30
		BNE set_updateOn

		LDR r1, ptr_to_firstFlag
		LDRB r0, [r1]
		CMP r0, #0x30
		MOV r0, #0x30
		STRB r0, [r1]
		BNE set_updateOn

		BL set_updateOff


set_updateOn:
		LDR r0, ptr_to_scoreValue
		LDRH r4, [r0]
		ADD r4, r4, #1
		STRH r4, [r0]

		LDR r0, ptr_to_gameStateFlag
		LDRB r1, [r0]
		CMP r1 ,#0
		BEQ static_0
		CMP r1 ,#1
		BEQ character_move_1
		CMP r1 ,#2
		BEQ cube_rota_2
		CMP r1 ,#3
		BEQ pause_3
		CMP r1 ,#4
		BEQ game_over_4
		;state 5 is game over(no restart jumpout at lab_loop)

static_0:
		LDR r0, ptr_to_location
		LDRB r10, [r0, #0]
		LDRB r11, [r0, #1]

		LDR r0, ptr_to_currentInputValue
		LDRB r12, [r0, #0]

		;if r12 == w(0x77) and if r11 == 0(0x30) rotate up : change game state, animType, animdirect, animTimer, location
		;if r12 == s(0x73) and if r11 == 0(0x32) rotate down
		;if r12 == a(0x61) and if r10 == 0(0x30) rotate left
		;if r12 == d(0x64) and if r10 == 0(0x32) rotate right

		;else do location change

		CMP r12, #0x77
		BEQ static_0_up
		CMP r12, #0x73
		BEQ static_0_down
		CMP r12, #0x61
		BEQ static_0_left
		CMP r12, #0x64
		BEQ static_0_right
		CMP r12, #0x20
		BEQ static_0_space
		BL static_0_end

static_0_up:
		CMP r11, #0x30
		BEQ static_0_down_rotate

;; store character location r6 x
;; store character location r7 y
;; store character location r8 1D
;; store character color r9
;; store up block color r8
;; compare not run SUB

		LDR r0, ptr_to_location
		LDRB r6, [r0, #0]
		LDRB r7, [r0, #1]
		SUB r6, r6, #0x30
		SUB r7, r7, #0x30
		MOV r0, #0x3
		MUL r7, r7, r0
		ADD r8, r6, r7
		SUB r8, r8, #3
		LDR r0, ptr_to_charColor
		LDRB r9, [r0]
		MOV r0, #0
		BL take_face
		LDRB r8, [r1,r8]
		CMP r8, r9
		BEQ static_0_end

		SUB r11, r11, #1
		LDR r0, ptr_to_location
		STRB r11, [r0, #1]
		BL static_0_end


static_0_up_rotate:
;; store character location r6 x
;; store down face block color r7 address r0
;; store character color r8


		LDR r0, ptr_to_location
		LDRB r6, [r0, #0]
		SUB r6, r6, #0x30

		MOV r0, #2
		BL take_face
		LDRB r7, [r1, r6]

		LDR r0, ptr_to_charColor
		LDRB r8, [r0, #0]

		CMP r8, r7
		BEQ static_0_end


;; change frount up down left right back id

		LDR r6, ptr_to_front_up_down_left_right_back_id
		LDR r7, ptr_to_front_up_down_left_right_back_id_ex

		LDRB r8, [r6,#0]
		STRB r8, [r7,#1];
		LDRB r8, [r6,#1]
		STRB r8, [r7,#5];
		LDRB r8, [r6,#2]
		STRB r8, [r7,#0];
		LDRB r8, [r6,#5]
		STRB r8, [r7,#2];

		LDRB r8, [r7,#0]
		STRB r8, [r6,#0];
		LDRB r8, [r7,#1]
		STRB r8, [r6,#1];
		LDRB r8, [r7,#2]
		STRB r8, [r6,#2];
		LDRB r8, [r7,#5]
		STRB r8, [r6,#5];

		MOV r0, #3
		BL take_face
		MOV r0, r1
		BL face_left_rotation
		MOV r0, #4
		BL take_face
		MOV r0, r1
		BL face_right_rotation

		LDR r0, ptr_to_location
		MOV r6, #0x30
		STRB r6, [r0, #1]

		BL static_0_end

static_0_down:
		CMP r11, #0x32
		BEQ static_0_up_rotate


		LDR r0, ptr_to_location
		LDRB r6, [r0, #0]
		LDRB r7, [r0, #1]
		SUB r6, r6, #0x30
		SUB r7, r7, #0x30
		MOV r0, #0x3
		MUL r7, r7, r0
		ADD r8, r6, r7
		ADD r8, r8, #3
		LDR r0, ptr_to_charColor
		LDRB r9, [r0]
		MOV r0, #0
		BL take_face
		LDRB r8, [r1,r8]
		CMP r8, r9
		BEQ static_0_end


		ADD r11, r11, #1
		LDR r0, ptr_to_location
		STRB r11, [r0, #1]
		BL static_0_end

static_0_down_rotate:
;; store character location r6 x
;; store down face block color r7 address r0
;; store character color r8


		LDR r0, ptr_to_location
		LDRB r6, [r0, #0]
		SUB r6, r6, #0x30
		ADD r6, r6, #6

		MOV r0, #1
		BL take_face
		LDRB r7, [r1, r6]

		LDR r0, ptr_to_charColor
		LDRB r8, [r0, #0]

		CMP r8, r7
		BEQ static_0_end


;; change frount up down left right back id

		LDR r6, ptr_to_front_up_down_left_right_back_id
		LDR r7, ptr_to_front_up_down_left_right_back_id_ex

		LDRB r8, [r6,#0]
		STRB r8, [r7,#2];
		LDRB r8, [r6,#1]
		STRB r8, [r7,#0];
		LDRB r8, [r6,#2]
		STRB r8, [r7,#5];
		LDRB r8, [r6,#5]
		STRB r8, [r7,#1];

		LDRB r8, [r7,#0]
		STRB r8, [r6,#0];
		LDRB r8, [r7,#1]
		STRB r8, [r6,#1];
		LDRB r8, [r7,#2]
		STRB r8, [r6,#2];
		LDRB r8, [r7,#5]
		STRB r8, [r6,#5];

		MOV r0, #3
		BL take_face
		MOV r0, r1
		BL face_right_rotation
		MOV r0, #4
		BL take_face
		MOV r0, r1
		BL face_left_rotation

		LDR r0, ptr_to_location
		MOV r6, #0x32
		STRB r6, [r0, #1]

		BL static_0_end


static_0_left:
		CMP r10, #0x30
		BEQ static_0_right_rotate


		LDR r0, ptr_to_location
		LDRB r6, [r0, #0]
		LDRB r7, [r0, #1]
		SUB r6, r6, #0x30
		SUB r7, r7, #0x30
		MOV r0, #0x3
		MUL r7, r7, r0
		ADD r8, r6, r7
		SUB r8, r8, #1
		LDR r0, ptr_to_charColor
		LDRB r9, [r0]
		MOV r0, #0
		BL take_face
		LDRB r8, [r1,r8]
		CMP r8, r9
		BEQ static_0_end


		SUB r10, r10, #1
		LDR r0, ptr_to_location
		STRB r10, [r0, #0]
		BL static_0_end

static_0_left_rotate:
;; store character location r6 x
;; store left face block color r7 address r0
;; store character color r8


		LDR r0, ptr_to_location
		LDRB r7, [r0, #1]
		SUB r7, r7, #0x30
		MOV r0, #3
		MUL r7, r7, r0
		MOV r6, r7

		MOV r0, #4
		BL take_face
		LDRB r7, [r1, r6]

		LDR r0, ptr_to_charColor
		LDRB r8, [r0, #0]

		CMP r8, r7
		BEQ static_0_end


;; change frount up down left right back id

		LDR r6, ptr_to_front_up_down_left_right_back_id
		LDR r7, ptr_to_front_up_down_left_right_back_id_ex

 		LDRB r8, [r6,#0]
		STRB r8, [r7,#3];
		LDRB r8, [r6,#3]
		STRB r8, [r7,#5];
		LDRB r8, [r6,#4]
		STRB r8, [r7,#0];
		LDRB r8, [r6,#5]
		STRB r8, [r7,#4];

		LDRB r8, [r7,#0]
		STRB r8, [r6,#0];
		LDRB r8, [r7,#3]
		STRB r8, [r6,#3];
		LDRB r8, [r7,#4]
		STRB r8, [r6,#4];
		LDRB r8, [r7,#5]
		STRB r8, [r6,#5];

		MOV r0, #1
		BL take_face
		MOV r0, r1
		BL face_right_rotation
		MOV r0, #2
		BL take_face
		MOV r0, r1
		BL face_left_rotation

		LDR r0, ptr_to_location
		MOV r6, #0x30
		STRB r6, [r0, #0]

		BL static_0_end

static_0_right:
		CMP r10, #0x32
		BEQ static_0_left_rotate


		LDR r0, ptr_to_location
		LDRB r6, [r0, #0]
		LDRB r7, [r0, #1]
		SUB r6, r6, #0x30
		SUB r7, r7, #0x30
		MOV r0, #0x3
		MUL r7, r7, r0
		ADD r8, r6, r7
		ADD r8, r8, #1
		LDR r0, ptr_to_charColor
		LDRB r9, [r0]
		MOV r0, #0
		BL take_face
		LDRB r8, [r1,r8]
		CMP r8, r9
		BEQ static_0_end


		ADD r10, r10, #1
		LDR r0, ptr_to_location
		STRB r10, [r0, #0]
		BL static_0_end

static_0_right_rotate:
;; store character location r6 x
;; store left face block color r7 address r0
;; store character color r8


		LDR r0, ptr_to_location
		LDRB r7, [r0, #1]
		SUB r7, r7, #0x30
		MOV r0, #3
		MUL r7, r7, r0
		ADD r6, r7, #2

		MOV r0, #3
		BL take_face
		LDRB r7, [r1, r6]

		LDR r0, ptr_to_charColor
		LDRB r8, [r0, #0]

		CMP r8, r7
		BEQ static_0_end


;; change frount up down left right back id

		LDR r6, ptr_to_front_up_down_left_right_back_id
		LDR r7, ptr_to_front_up_down_left_right_back_id_ex

 		LDRB r8, [r6,#0]
		STRB r8, [r7,#4];
		LDRB r8, [r6,#3]
		STRB r8, [r7,#0];
		LDRB r8, [r6,#4]
		STRB r8, [r7,#5];
		LDRB r8, [r6,#5]
		STRB r8, [r7,#3];

		LDRB r8, [r7,#0]
		STRB r8, [r6,#0];
		LDRB r8, [r7,#3]
		STRB r8, [r6,#3];
		LDRB r8, [r7,#4]
		STRB r8, [r6,#4];
		LDRB r8, [r7,#5]
		STRB r8, [r6,#5];

		MOV r0, #2
		BL take_face
		MOV r0, r1
		BL face_right_rotation
		MOV r0, #1
		BL take_face
		MOV r0, r1
		BL face_left_rotation

		LDR r0, ptr_to_location
		MOV r6, #0x32
		STRB r6, [r0, #0]

		BL static_0_end


static_0_space:
;; store character location r6 x
;; store character location r7 y
;; store character location r8 1D
;; store character color r9
;; store up block color r8
		LDR r0, ptr_to_location
		LDRB r6, [r0, #0]
		LDRB r7, [r0, #1]
		SUB r6, r6, #0x30
		SUB r7, r7, #0x30
		MOV r0, #0x3
		MUL r7, r7, r0
		ADD r8, r6, r7
		LDR r0, ptr_to_charColor
		LDRB r9, [r0]
		MOV r0, #0
		BL take_face
		LDRB r7, [r1,r8]

		STRB r9, [r1,r8]
		LDR r0, ptr_to_charColor
		STRB r7, [r0]

static_0_end:


		BL Timer_Handler_update_end

character_move_1:
cube_rota_2:
pause_3:
game_over_4:

		BL Timer_Handler_update_end

Timer_Handler_update_end:

		LDR r0, ptr_to_gameStateFlag
		LDRB r1, [r0]
		CMP r1 ,#0
		BEQ static_0draw
		CMP r1 ,#1
		BEQ static_0draw
		CMP r1 ,#2
		BEQ cube_rota_2draw
		CMP r1 ,#3
		BEQ pause_3draw
		CMP r1 ,#4
		BEQ game_over_4draw
		;state 5 is game over(no restart jumpout at lab_loop)
















;draw
static_0draw:

		BL static_face_draw
		BL step_counter_draw
		BL check_all_face_completed
		BL Timer_Handler_draw_end

cube_rota_2draw:
pause_3draw:
game_over_4draw:
		BL Timer_Handler_draw_end



Timer_Handler_draw_end:

set_updateOff:

	LDR r0, ptr_to_secondTime
	LDRH r1, [r0]
	LDR r0, ptr_to_timeStringValue
	BL int2string

	LDR r0, ptr_to_cursor121
	BL output_string
	LDR r0, ptr_to_timeText
	BL output_string
	LDR r0, ptr_to_timeStringValue
	BL output_string


	; enable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, #0x10
		STR r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		ORR r0, #0x1
		STR r0, [r1, #0x00C]

	POP {r4-r12,lr}

	BX lr       		; Return







check_all_face_completed: ; take r0 face address check if has all same color
		PUSH {r4-r12,lr}

		MOV r4, #0
		MOV r0, #0
		BL take_face
		BL check_face_completed
		ADD r4, r4, r0
		MOV r0, #1
		BL take_face
		BL check_face_completed
		ADD r4, r4, r0
		MOV r0, #2
		BL take_face
		BL check_face_completed
		ADD r4, r4, r0
		MOV r0, #3
		BL take_face
		BL check_face_completed
		ADD r4, r4, r0
		MOV r0, #4
		BL take_face
		BL check_face_completed
		ADD r4, r4, r0
		MOV r0, #5
		BL take_face
		BL check_face_completed
		ADD r4, r4, r0

		CMP r4, #0
		BEQ check_all_face_completed_LEDS_partten_0
		CMP r4, #1
		BEQ check_all_face_completed_LEDS_partten_1
		CMP r4, #2
		BEQ check_all_face_completed_LEDS_partten_2
		CMP r4, #3
		BEQ check_all_face_completed_LEDS_partten_3
		CMP r4, #4
		BEQ check_all_face_completed_LEDS_partten_4
		CMP r4, #5
		BEQ check_all_face_completed_LEDS_partten_5
		CMP r4, #6
		BEQ check_all_face_completed_LEDS_partten_6

check_all_face_completed_LEDS_partten_0:
		MOV r0, #0
		BL check_all_face_completed_end
check_all_face_completed_LEDS_partten_1:
		MOV r0, #1
		BL check_all_face_completed_end
check_all_face_completed_LEDS_partten_2:
		MOV r0, #3
		BL check_all_face_completed_end
check_all_face_completed_LEDS_partten_3:
		MOV r0, #7
		BL check_all_face_completed_end
check_all_face_completed_LEDS_partten_4:
		MOV r0, #0xF
		BL check_all_face_completed_end
check_all_face_completed_LEDS_partten_5:
		MOV r0, #5
		BL check_all_face_completed_end
check_all_face_completed_LEDS_partten_6:
		MOV r0, #6
		BL check_all_face_completed_end

check_all_face_completed_end:
		BL illuminate_LEDs

		POP {r4-r12,lr}
		MOV pc, lr






check_face_completed: ; take r0 face address check if has all same color

		PUSH {r4-r12,lr}
		MOV r4, #1
		MOV r5, #8
		LDRB r6, [r1,#0]

check_face_completed_Loop:

		LDRB r7, [r1,r4]
		CMP r6, r7
		BNE check_face_completed_no
		CMP r4, r5
		ADD r4, r4, #1
		BNE check_face_completed_Loop

check_face_completed_yes:
		MOV r0, #1
		BL check_face_completed_end

check_face_completed_no:
		MOV r0, #0
		BL check_face_completed_end

check_face_completed_end:

		POP {r4-r12,lr}
		MOV pc, lr



;take_face: take r0 id 012345 to current front up down left right back

take_face:
	PUSH {r4-r12,lr}

	LDR r1, ptr_to_front_up_down_left_right_back_id ;
	LDRB r5, [r1,r0]
	CMP r5, #0x30
	BEQ take_face0
	CMP r5, #0x31
	BEQ take_face1
	CMP r5, #0x32
	BEQ take_face2
	CMP r5, #0x33
	BEQ take_face3
	CMP r5, #0x34
	BEQ take_face4
	CMP r5, #0x35
	BEQ take_face5

take_face0:
	LDR r1, ptr_to_face0 ;
	BL take_face_end
take_face1:
	LDR r1, ptr_to_face1 ;
	BL take_face_end
take_face2:
	LDR r1, ptr_to_face2 ;
	BL take_face_end
take_face3:
	LDR r1, ptr_to_face3 ;
	BL take_face_end
take_face4:
	LDR r1, ptr_to_face4 ;
	BL take_face_end
take_face5:
	LDR r1, ptr_to_face5 ;
	BL take_face_end

take_face_end:

	POP {r4-r12,lr}
	MOV pc, lr






rotate_6_parten_R1_draw:		;take first face ptr in r0 and second ptr r1 draw
rotate_6_parten_R2_draw:		;take first face ptr in r0 and second ptr r1 draw
rotate_6_parten_U1_draw:		;take first face ptr in r0 and second ptr r1 draw
rotate_6_parten_U2_draw:		;take first face ptr in r0 and second ptr r1 draw

static_face_draw:
	PUSH {r4-r12,lr}	; Spill registers to stack

	LDR r0, ptr_to_cursor11 ; back to 00
	BL output_string

	MOV r0, #0
	BL take_face
	MOV r5 ,r1

	LDRB r0, [r5]	;get first color
	BL draw_3x3_block
	LDRB r0, [r5, #1]	;get second color
	BL draw_3x3_block
	LDRB r0, [r5, #2]	;get third color
	BL draw_3x3_block
	LDR r0, ptr_to_cursor11 ; back to 00
	BL output_string
	LDR r0, ptr_to_cursordown3 ; to next line
	BL output_string


	LDRB r0, [r5, #3]	;get 4th color
	BL draw_3x3_block
	LDRB r0, [r5, #4]	;get 5th color
	BL draw_3x3_block
	LDRB r0, [r5, #5]	;get 6th color
	BL draw_3x3_block

	LDR r0, ptr_to_cursor11 ; back to 00
	BL output_string
	LDR r0, ptr_to_cursordown3 ; to next line
	BL output_string
	BL output_string

	LDRB r0, [r5, #6]	;get 7th color
	BL draw_3x3_block
	LDRB r0, [r5, #7]	;get 8th color
	BL draw_3x3_block
	LDRB r0, [r5, #8]	;get 9th color
	BL draw_3x3_block

	LDR r0, ptr_to_location
	LDRB r10, [r0, #0]
	LDRB r11, [r0, #1]

	LDR r0, ptr_to_cursor11 ; back to 00
	BL output_string

static_face_draw_char_x:
	CMP r10, #0x30
	BEQ static_face_draw_char_x0
	CMP r10, #0x31
	BEQ static_face_draw_char_x1
	CMP r10, #0x32
	BEQ static_face_draw_char_x2

static_face_draw_char_x0:
	LDR r0, ptr_to_cursorright2 ; to next line
	BL output_string
	BL static_face_draw_char_Y

static_face_draw_char_x1:
	LDR r0, ptr_to_cursorright2 ; to next line
	BL output_string
	LDR r0, ptr_to_cursorright6
	BL output_string
	BL static_face_draw_char_Y

static_face_draw_char_x2:
	LDR r0, ptr_to_cursorright2 ; to next line
	BL output_string
	LDR r0, ptr_to_cursorright6
	BL output_string
	BL output_string
	BL static_face_draw_char_Y

static_face_draw_char_Y:
	CMP r11, #0x30
	BEQ static_face_draw_char_y0
	CMP r11, #0x31
	BEQ static_face_draw_char_y1
	CMP r11, #0x32
	BEQ static_face_draw_char_y2


static_face_draw_char_y0:
	LDR r0, ptr_to_cursordown ; to next line
	BL output_string
	BL static_face_draw_end

static_face_draw_char_y1:
	LDR r0, ptr_to_cursordown ; to next line
	BL output_string
	LDR r0, ptr_to_cursordown3
	BL output_string
	BL static_face_draw_end

static_face_draw_char_y2:
	LDR r0, ptr_to_cursordown ; to next line
	BL output_string
	LDR r0, ptr_to_cursordown3
	BL output_string
	BL output_string
	BL static_face_draw_end

static_face_draw_end:
	LDR r12, ptr_to_charColor
	LDRB r0, [r12]
	BL draw_single_squire
	LDR r12, ptr_to_charColor
	LDRB r0, [r12]
	BL illuminate_RGB_LED
	LDR r0, ptr_to_cursor11 ; back to 00
	BL output_string

	POP {r4-r12,lr}
	MOV pc, lr


;scoreText:			.string "SCORE: " ,0	;
;scoreIntValue:		.string "00" ,0			;
;scoreStringValue:	.string "0000" ,0		;
;timeText:			.string "Time: " ,0		;
;timeIntValue:		.string "00" ,0	   		;
;timeStringValue:	.string "0000" ,0	   	;
;pauseText:			.string "PAUSE" ,0		;

step_counter_draw: ;draw step counter
	PUSH {r4-r12,lr}	; Spill registers to stack

	LDR r0, ptr_to_blackPrefix
	BL output_string

	LDR r0, ptr_to_scoreValue
	LDRH r1, [r0]
	LDR r0, ptr_to_scoreStringValue
	BL int2string

	LDR r0, ptr_to_cursor921
	BL output_string
	LDR r0, ptr_to_scoreText
	BL output_string
	LDR r0, ptr_to_scoreStringValue
	BL output_string

	LDR r0, ptr_to_cursor11
	BL output_string

	POP {r4-r12,lr}
	MOV pc, lr


draw_3x3_block:		; take r0 color draw a block
	PUSH {r4-r12,lr}	; Spill registers to stack

	CMP r0, #8
	BEQ draw_red_3x3_block
	CMP r0, #2
	BEQ draw_blue_3x3_block
	CMP r0, #4
	BEQ draw_green_3x3_block
	CMP r0, #10
	BEQ draw_purple_3x3_block
	CMP r0, #12
	BEQ draw_yellow_3x3_block
	CMP r0, #14
	BEQ draw_white_3x3_block
	CMP r0, #0
	BEQ draw_black_3x3_block


draw_red_3x3_block:	; take r0 color draw a squire
	LDR r0, ptr_to_redPrefix
	BL output_string
	BL draw_3x3_block_end
draw_blue_3x3_block:	; take r0 color draw a squire
	LDR r0, ptr_to_bluePrefix
	BL output_string
	BL draw_3x3_block_end
draw_green_3x3_block:	; take r0 color draw a squire
	LDR r0, ptr_to_greenPrefix
	BL output_string
	BL draw_3x3_block_end
draw_purple_3x3_block:	; take r0 color draw a squire
	LDR r0, ptr_to_purplePrefix
	BL output_string
	BL draw_3x3_block_end
draw_yellow_3x3_block:	; take r0 color draw a squire
	LDR r0, ptr_to_yellowPrefix
	BL output_string
	BL draw_3x3_block_end
draw_white_3x3_block:	; take r0 color draw a squire
	LDR r0, ptr_to_whitePrefix
	BL output_string
	BL draw_3x3_block_end
draw_black_3x3_block:	; take r0 color draw a squire
	LDR r0, ptr_to_blackPrefix
	BL output_string
	BL draw_3x3_block_end

draw_3x3_block_end:

	LDR r0, ptr_to_squire
	BL output_string
	BL output_string
	BL output_string
	LDR r0, ptr_to_cursorleft6
	BL output_string

	LDR r0, ptr_to_cursordown
	BL output_string
	LDR r0, ptr_to_squire
	BL output_string
	BL output_string
	BL output_string
	LDR r0, ptr_to_cursorleft6
	BL output_string

	LDR r0, ptr_to_cursordown
	BL output_string
	LDR r0, ptr_to_squire
	BL output_string
	BL output_string
	BL output_string
	LDR r0, ptr_to_cursorup
	BL output_string
	BL output_string


	POP {r4-r12,lr}
	MOV pc, lr

;draw_3x2_block:		; take r0 color draw a block r1 for current location
;	PUSH {r4-r12,lr}	; Spill registers to stack

;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;	LDR r0, ptr_to_cursorleft6
;	BL output_string
;
;	LDR r0, ptr_to_cursordown
;	BL output_string
;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;
;	LDR r0, ptr_to_cursorup
;	BL output_string
;
;	POP {r4-r12,lr}
;	MOV pc, lr

;draw_3x1_block:		; take r0 color draw a block r1 for current location
;	PUSH {r4-r12,lr}	; Spill registers to stack
;
;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;
;
;	POP {r4-r12,lr}
;	MOV pc, lr

;draw_2x3_block:		; take r0 color draw a block r1 for current location
;	PUSH {r4-r12,lr}	; Spill registers to stack

;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;	LDR r0, ptr_to_cursorleft4
;	BL output_string

;	LDR r0, ptr_to_cursordown
;	BL output_string
;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;	LDR r0, ptr_to_cursorleft4
;	BL output_string
;
;	LDR r0, ptr_to_cursordown
;	BL output_string
;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;	LDR r0, ptr_to_cursorup
;	BL output_string
;	BL output_string


;	POP {r4-r12,lr}
;	MOV pc, lr

;draw_1x3_block:		; take r0 color draw a block r1 for current location
;	PUSH {r4-r12,lr}	; Spill registers to stack

;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;	LDR r0, ptr_to_cursorleft2
;	BL output_string
;
;	LDR r0, ptr_to_cursordown
;	BL output_string
;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;	LDR r0, ptr_to_cursorleft2
;	BL output_string

;	LDR r0, ptr_to_cursordown
;	BL output_string
;	LDR r0, ptr_to_squire
;	BL output_string
;	BL output_string
;	BL output_string
;	LDR r0, ptr_to_cursorup
;	BL output_string
;	BL output_string



;	POP {r4-r12,lr}
;	MOV pc, lr

draw_single_squire:		; take r0 color draw
	PUSH {r4-r12,lr}	; Spill registers to stack

	CMP r0, #8
	BEQ draw_red_squire
	CMP r0, #2
	BEQ draw_blue_squire
	CMP r0, #4
	BEQ draw_green_squire
	CMP r0, #10
	BEQ draw_purple_squire
	CMP r0, #12
	BEQ draw_yellow_squire
	CMP r0, #14
	BEQ draw_white_squire
	CMP r0, #0
	BEQ draw_black_squire


draw_red_squire:	; take r0 color draw a squire
	LDR r0, ptr_to_redPrefix
	BL output_string
	BL draw_squire_end
draw_blue_squire:	; take r0 color draw a squire
	LDR r0, ptr_to_bluePrefix
	BL output_string
	BL draw_squire_end
draw_green_squire:	; take r0 color draw a squire
	LDR r0, ptr_to_greenPrefix
	BL output_string
	BL draw_squire_end
draw_purple_squire:	; take r0 color draw a squire
	LDR r0, ptr_to_purplePrefix
	BL output_string
	BL draw_squire_end
draw_yellow_squire:	; take r0 color draw a squire
	LDR r0, ptr_to_yellowPrefix
	BL output_string
	BL draw_squire_end
draw_white_squire:	; take r0 color draw a squire
	LDR r0, ptr_to_whitePrefix
	BL output_string
	BL draw_squire_end
draw_black_squire:	; take r0 color draw a squire
	LDR r0, ptr_to_blackPrefix
	BL output_string
	BL draw_squire_end

draw_squire_end:
	LDR r0, ptr_to_squire
	BL output_string

	POP {r4-r12,lr}
	MOV pc, lr



face_left_rotation: ;r0 is face address
	PUSH {r4-r12,lr}	; Spill registers to stack
	LDR r4, ptr_to_faceEX
	LDRB r5, [r0, #0]
	STRB r5, [r4, #6]

	LDRB r5, [r0, #1]
	STRB r5, [r4, #3]

	LDRB r5, [r0, #2]
	STRB r5, [r4, #0]

	LDRB r5, [r0, #3]
	STRB r5, [r4, #7]

	LDRB r5, [r0, #4]
	STRB r5, [r4, #4]

	LDRB r5, [r0, #5]
	STRB r5, [r4, #1]

	LDRB r5, [r0, #6]
	STRB r5, [r4, #8]

	LDRB r5, [r0, #7]
	STRB r5, [r4, #5]

	LDRB r5, [r0, #8]
	STRB r5, [r4, #2]

	LDR r5, [r4, #0]
	STR r5, [r0, #0]
	LDR r5, [r4, #4]
	STR r5, [r0, #4]
	LDRB r5, [r4, #8]
	STRB r5, [r0, #8]


	POP {r4-r12,lr}
	MOV pc, lr

face_right_rotation: ;r0 is face address
	PUSH {r4-r12,lr}	; Spill registers to stack

	LDR r4, ptr_to_faceEX
	LDRB r5, [r0, #0]
	STRB r5, [r4, #2]

	LDRB r5, [r0, #1]
	STRB r5, [r4, #5]

	LDRB r5, [r0, #2]
	STRB r5, [r4, #8]

	LDRB r5, [r0, #3]
	STRB r5, [r4, #1]

	LDRB r5, [r0, #4]
	STRB r5, [r4, #4]

	LDRB r5, [r0, #5]
	STRB r5, [r4, #7]

	LDRB r5, [r0, #6]
	STRB r5, [r4, #0]

	LDRB r5, [r0, #7]
	STRB r5, [r4, #3]

	LDRB r5, [r0, #8]
	STRB r5, [r4, #6]

	LDR r5, [r4, #0]
	STR r5, [r0, #0]
	LDR r5, [r4, #4]
	STR r5, [r0, #4]
	LDRB r5, [r4, #8]
	STRB r5, [r0, #8]

	POP {r4-r12,lr}
	MOV pc, lr


get_current_input_value:
	PUSH {r4-r12,lr}	; Spill registers to stack

	LDR r10, ptr_to_keySpaceFlag
	LDRB r11, [r10]
	CMP r11, #0x30
	BEQ get_current_input_value_w
	LDR r10, ptr_to_keySpaceState
	LDRB r11, [r10]
	CMP r11, #0x31
	BEQ get_current_input_value_w
	LDR r10, ptr_to_currentInputValue
	MOV r11, #0x20
	STRB r11, [r10]
	BL get_current_input_value_end

get_current_input_value_w:
	LDR r10, ptr_to_keyWFlag
	LDRB r11, [r10]
	CMP r11, #0x30
	BEQ get_current_input_value_a
	LDR r10, ptr_to_keyWState
	LDRB r11, [r10]
	CMP r11, #0x31
	BEQ get_current_input_value_a
	LDR r10, ptr_to_currentInputValue
	MOV r11, #0x77
	STRB r11, [r10]
	BL get_current_input_value_end

get_current_input_value_a:
	LDR r10, ptr_to_keyAFlag
	LDRB r11, [r10]
	CMP r11, #0x30
	BEQ get_current_input_value_s
	LDR r10, ptr_to_keyAState
	LDRB r11, [r10]
	CMP r11, #0x31
	BEQ get_current_input_value_s
	LDR r10, ptr_to_currentInputValue
	MOV r11, #0x61
	STRB r11, [r10]
	BL get_current_input_value_end

get_current_input_value_s:
	LDR r10, ptr_to_keySFlag
	LDRB r11, [r10]
	CMP r11, #0x30
	BEQ get_current_input_value_d
	LDR r10, ptr_to_keySState
	LDRB r11, [r10]
	CMP r11, #0x31
	BEQ get_current_input_value_d
	LDR r10, ptr_to_currentInputValue
	MOV r11, #0x73
	STRB r11, [r10]
	BL get_current_input_value_end

get_current_input_value_d:
	LDR r10, ptr_to_keyDFlag
	LDRB r11, [r10]
	CMP r11, #0x30
	BEQ get_current_input_value_set_0
	LDR r10, ptr_to_keyDState
	LDRB r11, [r10]
	CMP r11, #0x31
	BEQ get_current_input_value_set_0
	LDR r10, ptr_to_currentInputValue
	MOV r11, #0x64
	STRB r11, [r10]
	BL get_current_input_value_end

get_current_input_value_set_0:
	LDR r10, ptr_to_currentInputValue
	MOV r11, #0x30
	STRB r11, [r10]
	BL get_current_input_value_end

get_current_input_value_end:

	POP {r4-r12, lr}	; Restore registers to adhere to the AAPCS
	MOV pc, lr



update_input_state:
	PUSH {r4-r12,lr}	; Spill registers to stack

	LDR r10, ptr_to_keySpaceFlag
	LDRB r11, [r10]
	MOV r12, #0x30
	STRB r12, [r10]
	LDR r10, ptr_to_keySpaceState
	STRB r11, [r10]

	LDR r10, ptr_to_keyWFlag
	LDRB r11, [r10]
	MOV r12, #0x30
	STRB r12, [r10]
	LDR r10, ptr_to_keyWState
	STRB r11, [r10]

	LDR r10, ptr_to_keyAFlag
	LDRB r11, [r10]
	MOV r12, #0x30
	STRB r12, [r10]
	LDR r10, ptr_to_keyAState
	STRB r11, [r10]

	LDR r10, ptr_to_keySFlag
	LDRB r11, [r10]
	MOV r12, #0x30
	STRB r12, [r10]
	LDR r10, ptr_to_keySState
	STRB r11, [r10]

	LDR r10, ptr_to_keyDFlag
	LDRB r11, [r10]
	MOV r12, #0x30
	STRB r12, [r10]
	LDR r10, ptr_to_keyDState
	STRB r11, [r10]

	POP {r4-r12, lr}	; Restore registers to adhere to the AAPCS
	MOV pc, lr


get_input_flag:
	PUSH {r4-r12,lr}	; Spill registers to stack

	BL read_character

	;space state change
	CMP r0, #0x20
	BEQ space_flag_on

	CMP r0, #0x57
	BEQ w_flag_on
	CMP r0, #0x41
	BEQ a_flag_on
	CMP r0, #0x53
	BEQ s_flag_on
	CMP r0, #0x44
	BEQ d_flag_on

	CMP r0, #0x77
	BEQ w_flag_on
	CMP r0, #0x61
	BEQ a_flag_on
	CMP r0, #0x73
	BEQ s_flag_on
	CMP r0, #0x64
	BEQ d_flag_on

	BL get_input_flag_end

space_flag_on:
	MOV r11, #0x31
	LDR r10, ptr_to_keySpaceFlag
	STRB r11, [r10]
	BL get_input_flag_end
w_flag_on:
	MOV r11, #0x31
	LDR r10, ptr_to_keyWFlag
	STRB r11, [r10]
	BL get_input_flag_end
a_flag_on:
	MOV r11, #0x31
	LDR r10, ptr_to_keyAFlag
	STRB r11, [r10]
	BL get_input_flag_end
s_flag_on:
	MOV r11, #0x31
	LDR r10, ptr_to_keySFlag
	STRB r11, [r10]
	BL get_input_flag_end
d_flag_on:
	MOV r11, #0x31
	LDR r10, ptr_to_keyDFlag
	STRB r11, [r10]
	BL get_input_flag_end
get_input_flag_end:

	POP {r4-r12, lr}	; Restore registers to adhere to the AAPCS
	MOV pc, lr


output_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r1, #0xC018
	MOVT r1, #0x4000
TSMTLOOP:
	MOV r3, #0x20
	LDRB r2, [r1, #0]
	AND r3, r3, r2
	CMP r3, #0x20
	BEQ TSMTLOOP
	MOV r1, #0xC000
	MOVT r1, #0x4000
	STRB r0, [r1, #0]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

output_string:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
	MOV r4, r0
	MOV r5, #0
OPSLOOP:
	LDRB r0, [r4, r5]
	ADD r5, r5, #1
	CMP r0, #0x00
	BEQ BREAKOPSLOOP
	BL output_character
	B OPSLOOP
BREAKOPSLOOP:
	MOV r0, r4

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

read_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r1, #0xC018
	MOVT r1, #0x4000
	MOV r3, #0x10
	LDRB r2, [r1, #0]
	AND r3, r3, r2
	CMP r3, #0x10
	BEQ read_character_pass
	MOV r1, #0xC000
	MOVT r1, #0x4000
	LDRB r0, [r1, #0]
	BL read_character_end
read_character_pass:
	MOV r0, #0
read_character_end:

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

make_random_cube:
	PUSH {r4-r12,lr}	; Spill registers to stack

	MOV r1, #0xE010
	MOVT r1, #0xE000
	MOV r0, #0x1
	STR r0, [r1, #0]

	MOV r1, #0xE014
	MOVT r1, #0xE000
	MOV r0, #0x02FA
	MOVT r0, #0x0000
	STR r0, [r1, #0]

	MOV r3, #0xE018
	MOVT r3, #0xE000

	LDR r5, ptr_to_face0

	MOV r6, #9
	MOV r7, #9
	MOV r8, #9
	MOV r9, #9
	MOV r10, #9
	MOV r11, #9

	MOV r1, #6

	MOV r12, #0

make_random_cube_loop:
	LDR r0, [r3]
	BL div_and_mod

	CMP r1, #0
	BEQ assign_red
	CMP r1, #1
	BEQ assign_blue
	CMP r1, #2
	BEQ assign_green
	CMP r1, #3
	BEQ assign_purple
	CMP r1, #4
	BEQ assign_yellow
	CMP r1, #5
	BEQ assign_white

assign_red:
	CMP r6, #0
	BEQ assign_blue
	SUB r6, #1
	MOV r1, #8
	BL assign_end
assign_blue:
	CMP r7, #0
	BEQ assign_green
	SUB r7, #1
	MOV r1, #2
	BL assign_end
assign_green:
	CMP r8, #0
	BEQ assign_purple
	SUB r8, #1
	MOV r1, #4
	BL assign_end
assign_purple:
	CMP r9, #0
	BEQ assign_yellow
	SUB r9, #1
	MOV r1, #10
	BL assign_end
assign_yellow:
	CMP r10, #0
	BEQ assign_white
	SUB r10, #1
	MOV r1, #12
	BL assign_end
assign_white:
	CMP r11, #0
	BEQ assign_red
	SUB r11, #1
	MOV r1, #14
	BL assign_end

assign_end:
	STRB r1, [r5]
	ADD r5, r5, #1

	MOV r1, #6
	ADD r12, r12, #1
	CMP r12, #54
	BNE make_random_cube_loop

	LDR r1, ptr_to_face0
	LDRB r0, [r1, #4]
	CMP r0, #8
	BEQ set_char_blue
	BL set_char_red

set_char_blue:
	LDR r5, ptr_to_charColor
	MOV r1, #2
	STRB r1, [r5]
	BL set_char_end

set_char_red:
	LDR r5, ptr_to_charColor
	MOV r1, #8
	STRB r1, [r5]
	BL set_char_end

set_char_end:

	MOV r1, #0xE010
	MOVT r1, #0xE000
	MOV r0, #0x0
	STR r0, [r1, #0]

	POP {r4-r12, lr}	; Restore registers to adhere to the AAPCS
	MOV pc, lr


div_and_mod:
	PUSH {r4-r12,lr}	; Spill registers to stack

	;  Your code is placed here
	MOV r2, #0
	CMP r0, #0
	BGT GREATER
	BLT LESS
	B R1IS0
GREATER:
	CMP r1, #0
	BGT PPBRC
	BLT PNBRC
LESS:
	CMP r1, #0
	BGT NPBRC
	BLT NNBRC
R1IS0:
	MOV r0, #0
	MOV r1, #0
	B RES

PPBRC:
PPLOOP:
	CMP r0, r1
	BLT PPRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B PPLOOP
PPRES:
	MOV r1, r0
	MOV r0, r2
	B RES

PNBRC:
	RSB r1, r1, #0
PNLOOP:
	CMP r0, r1
	BLT PNRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B PNLOOP
PNRES:
	MOV r1, r0
	RSB r0, r2, #0
	B RES

NPBRC:
	RSB r0, r0, #0
NPLOOP:
	CMP r0, #0
	BLE NPRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B NPLOOP
NPRES:
	RSB r1, r0, #0
	RSB r0, r2, #0
	B RES

NNBRC:
NNLOOP:
	CMP r0, #0
	BGE NNRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B NNLOOP
NNRES:
	MOV r1, r0
	MOV r0, r2
	B RES

RES:
	MOV r2, #0

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

int2string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
	;;  that are used in your routine.  Include lr if this
	;;  routine calls another routine.

	;;  Your code for your int2string routine is placed here
	MOV r5, r1 		;store dividend
	MOV r6, #10 		;stroe divisor
	MOV r7, #0 		;store quotient
	MOV r8, #0 		;store remain
	MOV r4, r0 		;store address to assign
	MOV r9, #0 		;store address offset

	MOV r0, r5 		; pre setup for div_and_mod
	MOV r1, r6
	CMP r0, #0
	BGE length_test_loop
	RSB r0, r0, #0
	ADD r9, r9, #1
	B length_test_loop

length_test_loop:
	BL div_and_mod
	MOV r1, r6
	ADD r9, r9, #1
	CMP r0, #0
	BEQ to_int_branch
	B length_test_loop

to_int_branch:
	MOV r0, r5 		; pre setup for div_and_mod
	MOV r1, r6
	MOV r10, #0x00
	STRB r10, [r4, r9]
	SUB r9, r9, #1
	CMP r5, #0
	BGE pos_to_int_loop
	RSB r0, r5, #0
	B neg_to_int_loop

pos_to_int_loop:
	BL div_and_mod
	ADD r1, r1, #0x30
	STRB r1, [r4, r9]
	MOV r1, r6
	CMP r9, #0
	BEQ pos_break_to_int_loop
	SUB r9, r9, #1
	B pos_to_int_loop

neg_to_int_loop:
	BL div_and_mod
	ADD r1, r1, #0x30
	STRB r1, [r4, r9]
	MOV r1, r6
	CMP r9, #0
	BEQ neg_break_to_int_loop
	SUB r9, r9, #1
	B neg_to_int_loop

pos_break_to_int_loop:
	MOV r0, r4
	b toStringEnd

neg_break_to_int_loop:
	MOV r0, #45
	STRB r0, [r4, #0]
	MOV r0, r4
	b toStringEnd

toStringEnd:

	POP {r4-r12,lr}   	; Restore registers all registers preserved in the
	;;  PUSH at the top of this routine from the stack.
	mov pc, lr


illuminate_LEDs:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
        MOV r4, #0x53FC
		MOVT r4, #0x4000
		STRB r0, [r4, #0]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr


illuminate_RGB_LED:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
        MOV r4, #0x53FC
		MOVT r4, #0x4002
		;; 2 -> blue _red
		;; 4 -> green _blue
		;; 8 _> red -green

		CMP r0, #8
		BEQ decode_8_2_rgb
		CMP r0, #4
		BEQ decode_4_8_rgb
		CMP r0, #2
		BEQ decode_2_4_rgb

		CMP r0, #0xc
		BEQ decode_c_a_rgb
		CMP r0, #0xa
		BEQ decode_a_6_rgb
		CMP r0, #2
		BEQ decode_6_c_rgb

decode_8_2_rgb:
		MOV r0, #2
		BL decode_end
decode_4_8_rgb:
		MOV r0, #8
		BL decode_end
decode_2_4_rgb:
		MOV r0, #4
		BL decode_end

decode_c_a_rgb:
		MOV r0, #0xa
		BL decode_end
decode_a_6_rgb:
		MOV r0, #6
		BL decode_end
decode_6_c_rgb:
		MOV r0, #0xc
		BL decode_end

decode_end:

		STRB r0, [r4, #0]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr


uart_init:
	PUSH {r4-r12,lr}	; Spill registers to stack

        ; Your code is placed here

        MOV r1, #0xE618
		MOVT r1, #0x400F
		MOV r0, #1
		STR r0, [r1, #0]
		MOV r1, #0xE608
		MOVT r1, #0x400F
		MOV r0, #1
		STR r0, [r1, #0]
		MOV r1, #0xC030
		MOVT r1, #0x4000
		MOV r0, #0
		STR r0, [r1, #0]
		MOV r1, #0xC024
		MOVT r1, #0x4000
		MOV r0, #8
		STR r0, [r1, #0]
		MOV r1, #0xC028
		MOVT r1, #0x4000
		MOV r0, #44
		STR r0, [r1, #0]
		MOV r1, #0xCFC8
		MOVT r1, #0x4000
		MOV r0, #0
		STR r0, [r1, #0]
		MOV r1, #0xC02C
		MOVT r1, #0x4000
		MOV r0, #0x60
		STR r0, [r1, #0]
		MOV r1, #0xC030
		MOVT r1, #0x4000
		MOV r0, #0x301
		STR r0, [r1, #0]

		MOV r1, #0x451C
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, r0, #0x03
		STR r0, [r1, #0]
		MOV r1, #0x4420
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, r0, #0x03
		STR r0, [r1, #0]
		MOV r1, #0x452C
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, r0, #0x11
		STR r0, [r1, #0]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

gpio_btn_and_LED_init:
	PUSH {r4-r12,lr}	; Spill registers to stack

        ; Your code is placed here
    	;enables clock for GPIO Ports
		;for input of board port F D B
		MOV r1, #0xE608
		MOVT r1, #0x400F
		LDRB r0, [r1, #0]
		ORR r0, #0x2A
		STRB r0, [r1, #0]

		;set direction of GPIO port F Pin 4 as 0, Pin 1 2 3 as 1
		MOV r1, #0x5400
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0xE
		AND r0, #0xEF
		STRB r0, [r1, #0]

		;set GPIO port F Pin 1 2 3 4 as Digital
		MOV r1, #0x551c
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x1E
		STRB r0, [r1, #0]

		; Pull-Up Resistor port F pin 4
		MOV r1, #0x5510
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		;set direction of GPIO port D Pin 0 1 2 3 as 0
		MOV r1, #0x7400
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		AND r0, #0xF0
		STRB r0, [r1, #0]

		;set GPIO port D Pin 0 1 2 3 as Digital
		MOV r1, #0x751c
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		ORR r0, #0xF
		STRB r0, [r1, #0]

		;set direction of GPIO port B Pin 0 1 2 3 as 1
		MOV r1, #0x5400
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		ORR r0, #0xF
		STRB r0, [r1, #0]

		;set GPIO port B Pin 0 1 2 3 as Digital
		MOV r1, #0x551c
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		ORR r0, #0xF
		STRB r0, [r1, #0]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

time_interrupt_init:
	;  Your code to initialize the UART0 interrupt goes here
	; set RCGCTIMER
	PUSH {r4-r12,lr}

		MOV r1, #0xE604
		MOVT r1, #0x400F
		LDR r0, [r1, #0x0]
		MOV r0, #0x1
		STR r0, [r1, #0]

	; set GPTMCTL
		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDRB r0, [r1, #0x0C]
		AND r0, #0xFE
		STRB r0, [r1, #0x0C]

	; set GPTMCFG
		LDR r0, [r1, #0x0]
		ORR r0, #0x0
		STR r0, [r1, #0x0]

	; set GPTMTAMR
		LDRB r0, [r1, #0x4]
		MOV r0, #0x2
		STRB r0, [r1, #0x4]

	; set GPTMTAILR
		MOV r0, #0x5300
		MOVT r0, #0x0007
		STR r0, [r1, #0x28]


	; set GPTMIMR
		LDR r0, [r1, #0x18]
		ORR r0, #0x1
		STR r0, [r1, #0x18]

	; set EN0
		MOV r1, #0xE100
		MOVT r1, #0xE000
		LDR r0, [r1, #0]
		ORR r0, #0x80000
		STR r0, [r1, #0]

	; set GPTMCTL
		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		ORR r0, #0x1
		STR r0, [r1, #0x00C]

	POP {r4-r12,lr}
	MOV pc, lr

	.end
