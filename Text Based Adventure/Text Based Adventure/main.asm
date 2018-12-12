;
; Ruiz - A Text-Based Adventure 
;
; Created: 11/27/2018 11:47:40 AM
; Author : Marc Anthony Ruiz
;

.equ                        WIDTH           = 128                                  
.equ                        HEIGHT          = 64
   
.def						button_press	= r20  
.def						temp			= r21                               


.macro		blank				;enters a "blank" into the array (essentially hitting space on a keyboard)
ldi			r18, @0
ldi			r19, @1
rcall		GFX_set_array_pos
rcall		GFX_draw_blank
.endmacro

.macro		char				;enters a character based on ascii numbers into the array
ldi			ZL, low(Char_@0<<1)
ldi			ZH, high(Char_@0<<1)
call		GFX_set_shape
ldi			r18, @1
ldi			r19, @2
call		GFX_set_array_pos
call		GFX_draw_shape
.endmacro

.macro		next_page			;small delay to refresh OLED display, buffer button presses, and a post-Interrupt check to move to next page (any button press)
call		refresh
call		delay_1s
call		delay_1s
call		delay_1s
cpi			button_press, 0xFF
breq		@0
cpi			button_press, 0x0F
breq		@0
.endmacro

.macro		branch_page			;small delay to refresh OLED display, buffer button presses, and a post-Interrupt check to branch to next a choice of two pages (button_press dependent)
call		refresh
call		delay_1s
call		delay_1s
call		delay_1s
cpi			button_press, 0xFF
breq		@0
cpi			button_press, 0x0F
breq		@1
.endmacro

.cseg
.org		0x00
rjmp		setup
.org		0x08
jmp			ISR_PCINT1
.org		0x0A
jmp			ISR_PCINT2
.org		0x100



setup:		call		OLED_initialize
			call		GFX_clear_array

			ldi			temp, 0b11111110
			out			DDRD, temp			;sets PORTD bit 0 as input
			out			DDRC, temp			;sets PORTC bit 0 as input
			ldi			temp, 0x01
			out			PORTD, temp			;pull up resistors
			out			PORTC, temp			;pull up resistors

			ldi			temp, 0b00000110
			sts			PCICR, temp			;enables pin change interrupts for PCI1 and PCI2
			ldi			temp, 0b00000001
			sts			PCMSK1, temp		;enables pin change interrupts for PCI1, specifically pin 0
			sts			PCMSK2, temp		;enables pin change interrupts for PCI2, specifically pin 0
			sei								;set global interrupt

title_page:	call		GFX_clear_array

			char		069, 0x28, 0x10
			char		083, 0x30, 0x10
			char		067, 0x38, 0x10
			char		065, 0x40, 0x10
			char		080, 0x48, 0x10
			char		069, 0x50, 0x10

			next_page	instr_page

			rjmp		title_page

instr_page:	call		GFX_clear_array

			char		065, 0x10, 0x00
			;blank		0x18, 0x00
			char		084, 0x20, 0x00
			char		101, 0x28, 0x00
			char		120, 0x30, 0x00
			char		116, 0x38, 0x00
			char		196, 0x40, 0x00
			char		066, 0x48, 0x00
			char		097, 0x50, 0x00
			char		115, 0x58, 0x00
			char		101, 0x60, 0x00
			char		100, 0x68, 0x00
			;line
			char		065, 0x10, 0x08
			char		100, 0x18, 0x08
			char		118, 0x20, 0x08
			char		101, 0x28, 0x08
			char		110, 0x30, 0x08
			char		116, 0x38, 0x08
			char		117, 0x40, 0x08
			char		114, 0x48, 0x08
			char		101, 0x50, 0x08
			;line
			char		067, 0x10, 0x20
			char		097, 0x18, 0x20
			char		110, 0x20, 0x20
			;blank		0x28, 0x20
			char		089, 0x30, 0x20
			char		111, 0x38, 0x20
			char		117, 0x40, 0x20
			;blank		0x48, 0x20
			char		069, 0x50, 0x20
			char		115, 0x58, 0x20
			char		099, 0x60, 0x20
			char		097, 0x68, 0x20
			char		112, 0x70, 0x20
			char		101, 0x78, 0x20
			;line
			char		063, 0x38, 0x30

			next_page	instr_page2

						jmp		instr_page

instr_page2:
			call		GFX_clear_array
			
			char		084,0x00,0x00
			char		111,0x08,0x00
			;blank		0x10,0x00
			char		097,0x18,0x00
			char		100,0x20,0x00
			char		118,0x28,0x00
			char		097,0x30,0x00
			char		110,0x38,0x00
			char		099,0x40,0x00
			char		101,0x48,0x00
			;blank		0x50,0x00
			char		102,0x58,0x00
			char		114,0x60,0x00
			char		111,0x68,0x00
			char		109,0x70,0x00
			;line
			char		097,0x00,0x08
			;blank		0x08,0x08
			char		116, 0x10, 0x08
			char		101, 0x18, 0x08
			char		120, 0x20, 0x08
			char		116, 0x28, 0x08
			;blank		0x30,0x08
			char		112,0x38, 0x08
			char		097,0x40,0x08
			char		103,0x48,0x08
			char		101,0x50,0x08
			char		044,0x58,0x08
			;line
			char		112,0x00,0x10
			char		114,0x08,0x10
			char		101,0x10,0x10
			char		115,0x18,0x10
			char		115,0x20,0x10
			;blank		0x28,0x10
			char		097,0x30,0x10
			char		110,0x38,0x10
			char		121,0x40,0x10
			;blank		0x48,0x10
			char		098,0x50,0x10
			char		117,0x58,0x10
			char		116,0x60,0x10
			char		116,0x68,0x10
			char		111,0x70,0x10
			char		110,0x78,0x10
			;line
			char		084,0x00,0x20
			char		111,0x08,0x20
			;blank		0x10,0x20
			char		097,0x18,0x20
			char		100,0x20,0x20
			char		118,0x28,0x20
			char		097,0x30,0x20
			char		110,0x38,0x20
			char		099,0x40,0x20
			char		101,0x48,0x20
			;blank		0x50,0x20
			char		102,0x58,0x20
			char		114,0x60,0x20
			char		111,0x68,0x20
			char		109,0x70,0x20
			;line
			char		097,0x00,0x28
			;blank		0x08,0x28
			char		100,0x10,0x28
			char		101,0x18,0x28
			char		099,0x20,0x28
			char		105,0x28,0x28
			char		115,0x30,0x28
			char		105,0x38,0x28
			char		111,0x40,0x28
			char		110,0x48,0x28
			;blank		0x50,0x28
			char		112,0x58,0x28
			char		097,0x60,0x28
			char		103,0x68,0x28
			char		101,0x70,0x28
			char		044,0x78,0x28
			;line
			char		112,0x00,0x30
			char		114,0x08,0x30
			char		101,0x10,0x30
			char		115,0x18,0x30
			char		115,0x20,0x30
			;blank
			char		116,0x30,0x30
			char		104,0x38,0x30
			char		101,0x40,0x30
			;blank
			char		116,0x50,0x30
			char		111,0x58,0x30
			char		112,0x60,0x30
			;line
			char		111,0x70,0x30
			char		114,0x78,0x30
			;blank
			char		098,0x00,0x38
			char		111,0x08,0x38
			char		116,0x10,0x38
			char		116,0x18,0x38
			char		111,0x20,0x38
			char		109,0x28,0x38
			;blank	
			char		098,0x38,0x38
			char		117,0x40,0x38
			char		116,0x48,0x38
			char		116,0x50,0x38
			char		111,0x58,0x38
			char		110,0x60,0x38

			next_page	instr_page3

						jmp		instr_page2

instr_page3:
			call		GFX_clear_array


			char		080,0x00,0x20
			char		114,0x08,0x20
			char		101,0x10,0x20
			char		115,0x18,0x20
			char		115,0x20,0x20
			;blank
			char		065,0x30,0x20
			char		110,0x38,0x20
			char		121,0x40,0x20
			;blank
			char		066,0x50,0x20
			char		117,0x58,0x20
			char		116,0x60,0x20
			char		116,0x68,0x20
			char		111,0x70,0x20
			char		110,0x78,0x20
			;line
			char		116,0x00,0x28
			char		111,0x08,0x28
			;blank
			char		083,0x18,0x28
			char		116,0x20,0x28
			char		097,0x28,0x28
			char		114,0x30,0x28
			char		116,0x38,0x28
			char		046,0x40,0x28
			char		046,0x48,0x28
			char		046,0x50,0x28

			next_page	page1

				jmp		instr_page3

page1:		call		GFX_clear_array	

			char		042, 0x10, 0x18
			char		100, 0x18, 0x18
			char		114, 0x20, 0x18
			char		105, 0x28, 0x18
			char		112, 0x30, 0x18
			char		042, 0x38, 0x18
			
			next_page	page2

				rjmp		page1

page2:		call		GFX_clear_array	

			char		042, 0x10, 0x20
			char		100, 0x18, 0x20
			char		114, 0x20, 0x20
			char		105, 0x28, 0x20
			char		112, 0x30, 0x20
			char		042, 0x38, 0x20
			
			next_page	page3

			rjmp		page2

page3:		call		GFX_clear_array	

			char		042, 0x10, 0x30
			char		100, 0x18, 0x30
			char		114, 0x20, 0x30
			char		105, 0x28, 0x30
			char		112, 0x30, 0x30
			char		042, 0x38, 0x30
			
			next_page	repetitive_onomatopoeia

			rjmp		page3

repetitive_onomatopoeia:			;*splash*
						call		GFX_clear_array

						char		042, 0x40, 0x38
						char		115, 0x48, 0x38
						char		112, 0x50, 0x38
						char		108, 0x58, 0x38
						char		097, 0x60, 0x38
						char		115, 0x68, 0x38
						char		104, 0x70, 0x38
						char		042, 0x78, 0x38

						next_page	labored_prose

						rjmp		repetitive_onomatopoeia


labored_prose:						;A sympathetic light
						call		GFX_clear_array

						char		065, 0x00, 0x00
						;blank		0x08, 0x00
						char		115, 0x10, 0x00
						char		121, 0x18, 0x00
						char		109, 0x20, 0x00
						char		112, 0x28, 0x00
						char		097, 0x30, 0x00
						char		116, 0x38, 0x00
						char		104, 0x40, 0x00
						char		101, 0x48, 0x00
						char		116, 0x50, 0x00
						char		105, 0x58, 0x00
						char		099, 0x60, 0x00
						;line
						char		108, 0x00, 0x08
						char		105, 0x08, 0x08
						char		103, 0x10, 0x08
						char		104, 0x18, 0x08
						char		116, 0x20, 0x08
						;blank
						char		102, 0x30, 0x08
						char		114, 0x38, 0x08
						char		111, 0x40, 0x08
						char		109, 0x48, 0x08
						;blank
						char		116, 0x58, 0x08
						char		104, 0x60, 0x08
						char		101, 0x68, 0x08
						;line
						char		109, 0x00, 0x10
						char		111, 0x08, 0x10
						char		111, 0x10, 0x10
						char		110, 0x18, 0x10
						char		108, 0x20, 0x10
						char		105, 0x28, 0x10
						char		116, 0x30, 0x10
						;blank
						char		110, 0x40, 0x10
						char		105, 0x48, 0x10
						char		103, 0x50, 0x10
						char		104, 0x58, 0x10
						char		116, 0x60, 0x10
						;line
						char		106, 0x00, 0x18
						char		117, 0x08, 0x18
						char		115, 0x10, 0x18
						char		116, 0x18, 0x18
						;blank
						char		104, 0x20, 0x18
						char		097, 0x28, 0x18
						char		114, 0x30, 0x18
						char		100, 0x38, 0x18
						char		108, 0x40, 0x18
						char		121, 0x48, 0x18
						;blank
						char		099, 0x58, 0x18
						char		117, 0x60, 0x18
						char		116, 0x68, 0x18
						char		115, 0x70, 0x18
						;line
						char		116, 0x00, 0x20
						char		104, 0x08, 0x20
						char		101, 0x10, 0x20
						;blank
						char		100, 0x18, 0x20
						char		097, 0x20, 0x20
						char		114, 0x28, 0x20
						char		107, 0x30, 0x20
						char		110, 0x38, 0x20
						char		101, 0x40, 0x20
						char		115, 0x48, 0x20
						char		115, 0x50, 0x20
						;blank
						char		111, 0x60, 0x20
						char		102, 0x68, 0x20
						;blank
						char		097, 0x78, 0x20
						;line
						char		100, 0x00, 0x28
						char		101, 0x08, 0x28
						char		099, 0x10, 0x28
						char		114, 0x18, 0x28
						char		101, 0x20, 0x28
						char		112, 0x28, 0x28
						char		105, 0x30, 0x28
						char		116, 0x38, 0x28
						;blank
						char		099, 0x48, 0x28
						char		101, 0x50, 0x28
						char		108, 0x58, 0x28
						char		108, 0x60, 0x28
						char		046, 0x68, 0x28
						;line
						char		089, 0x00, 0x38
						char		111, 0x08, 0x38
						char		117, 0x10, 0x38
						char		114, 0x18, 0x38
						;blank
						char		099, 0x28, 0x38
						char		101, 0x30, 0x38
						char		108, 0x38, 0x38
						char		108, 0x40, 0x38
						char		046, 0x48, 0x38

						next_page	page6

						jmp		labored_prose

page6:		call		GFX_clear_array
			
			char		072,0x00,0x00
			char		101,0x08,0x00
			char		114,0x10,0x00
			char		101,0x18,0x00
			;blank
			char		111,0x28,0x00
			char		110,0x30,0x00
			;blank
			char		116,0x40,0x00
			char		104,0x48,0x00
			char		101,0x50,0x00
			;blank
			char		099,0x60,0x00
			char		111,0x68,0x00
			char		108,0x70,0x00
			char		100,0x78,0x00
			;line
			char		115,0x00,0x08
			char		116,0x08,0x08
			char		111,0x10,0x08
			char		110,0x18,0x08
			char		101,0x20,0x08
			;blank
			char		102,0x30,0x08
			char		108,0x38,0x08
			char		111,0x40,0x08
			char		111,0x48,0x08
			char		114,0x50,0x08
			;blank
			char		121,0x60,0x08
			char		111,0x68,0x08
			char		117,0x70,0x08
			;line
			char		108,0x00,0x10
			char		105,0x08,0x10
			char		101,0x10,0x10
			char		046,0x18,0x10

			next_page	page7

			jmp			page6
			
page7:		call		GFX_clear_array
			
			char		082,0x00,0x08
			char		105,0x08,0x08
			char		115,0x10,0x08
			char		101,0x18,0x08
			char		046,0x20,0x08
			char		046,0x28,0x08
			char		046,0x30,0x08
			;blank
			char		024,0x78,0x00
			;line
			char		083,0x00,0x30
			char		117,0x08,0x30
			char		114,0x10,0x30
			char		114,0x18,0x30
			char		101,0x20,0x30
			char		110,0x28,0x30
			char		100,0x30,0x30
			char		101,0x38,0x30
			char		114,0x40,0x30
			char		046,0x48,0x30
			char		046,0x50,0x30
			char		046,0x58,0x30
			;blank
			char		025,0x78,0x38

			branch_page	page8, page10_jmp

			jmp			page7

page10_jmp:	jmp			page10

page8:		call		GFX_clear_array
			
			char		089,0x00,0x00
			char		111,0x08,0x00
			char		117,0x10,0x00
			;blank
			char		112,0x20,0x00
			char		117,0x28,0x00
			char		108,0x30,0x00
			char		108,0x38,0x00
			;line
			char		121,0x00,0x08
			char		111,0x08,0x08
			char		117,0x10,0x08
			char		114,0x18,0x08
			char		115,0x20,0x08
			char		101,0x28,0x08
			char		108,0x30,0x08
			char		102,0x38,0x08
			;blank
			char		116,0x48,0x08
			char		111,0x50,0x08
			;blank
			char		121,0x60,0x08
			char		111,0x68,0x08
			char		117,0x70,0x08
			char		115,0x78,0x08
			;line
			char		102,0x00,0x10
			char		101,0x08,0x10
			char		101,0x10,0x10
			char		116,0x18,0x10
			char		046,0x20,0x10
			;blank
			char		065,0x30,0x10
			;blank
			char		104,0x40,0x10
			char		101,0x48,0x10
			char		114,0x50,0x10
			char		111,0x58,0x10
			char		105,0x60,0x10
			char		099,0x68,0x10
			;line
			char		115,0x00,0x18
			char		116,0x08,0x18
			char		114,0x10,0x18
			char		101,0x18,0x18
			char		110,0x20,0x18
			char		103,0x28,0x18
			char		116,0x30,0x18
			char		104,0x38,0x18
			;blank
			char		102,0x48,0x18
			char		105,0x50,0x18
			char		108,0x58,0x18
			char		108,0x60,0x18
			char		115,0x68,0x18
			;line
			char		121,0x00,0x20
			char		111,0x08,0x20
			char		117,0x10,0x20
			char		114,0x18,0x20
			;blank
			char		118,0x28,0x20
			char		101,0x30,0x20
			char		105,0x38,0x20
			char		110,0x40,0x20
			char		115,0x48,0x20
			char		046,0x50,0x20
			;blank
			char		089,0x60,0x20
			char		111,0x68,0x20
			char		117,0x70,0x20
			;line
			char		116,0x00,0x28
			char		104,0x08,0x28
			char		114,0x10,0x28
			char		111,0x18,0x28
			char		119,0x20,0x28
			;blank
			char		097,0x30,0x28
			;blank		
			char		112,0x40,0x28
			char		117,0x48,0x28
			char		110,0x50,0x28
			char		099,0x58,0x28
			char		104,0x60,0x28
			;blank	
			char		097,0x70,0x28
			char		116,0x78,0x28
			;line
			char		116,0x00,0x30
			char		104,0x08,0x30
			char		101,0x10,0x30
			;blank
			char		119,0x20,0x30
			char		097,0x28,0x30
			char		108,0x30,0x30
			char		108,0x38,0x30
			char		059,0x40,0x30
			;blank
			char		105,0x50,0x30
			char		116,0x58,0x30
			;line
			char		102,0x00,0x38
			char		097,0x08,0x38
			char		108,0x10,0x38
			char		108,0x18,0x38
			char		115,0x20,0x38
			char		046,0x28,0x38
			;blank
			char		089,0x38,0x38
			char		111,0x40,0x38
			char		117,0x48,0x38
			;blank
			char		114,0x58,0x38
			char		117,0x60,0x38
			char		110,0x68,0x38
			char		046,0x70,0x38

			next_page	page9

			jmp			page8


page9:		rcall		GFX_clear_array

			char		086,0x28,0x18
			char		105,0x30,0x18
			char		099,0x38,0x18
			char		116,0x40,0x18
			char		111,0x48,0x18
			char		114,0x50,0x18
			char		121,0x58,0x18
			char		033,0x60,0x18

			next_page	title_page_jmp

			rjmp		page9

title_page_jmp:			jmp	title_page

page10:		rcall		GFX_clear_array

			char		089,0x00,0x00
			char		111,0x08,0x00
			char		117,0x10,0x00
			char		114,0x18,0x00
			;blank
			char		098,0x28,0x00
			char		111,0x30,0x00
			char		100,0x38,0x00
			char		121,0x40,0x00
			;blank
			char		070,0x48,0x00
			char		114,0x50,0x00
			char		101,0x58,0x00
			char		101,0x60,0x00
			char		122,0x68,0x00
			char		101,0x70,0x00
			char		115,0x78,0x00
			;line
			char		111,0x00,0x08
			char		118,0x08,0x08
			char		101,0x10,0x08
			char		114,0x18,0x08
			char		046,0x20,0x08
			;line
			char		089,0x00,0x18
			char		111,0x08,0x18
			char		117,0x10,0x18
			;blank
			char		115,0x20,0x18
			char		117,0x28,0x18
			char		098,0x30,0x18
			char		109,0x38,0x18
			char		105,0x40,0x18
			char		116,0x48,0x18

			next_page	title_page_jmp2

			jmp			page10

title_page_jmp2:		jmp	title_page

refresh:	ldi			r18, 0x00			;subroutine to fufill OLED_refresh_screen in its entirety 
			ldi			r19, 0x00
			rcall		GFX_set_array_pos
			rcall		OLED_refresh_screen
			ret

ISR_PCINT1:									;button near bottom (PC0)
			in			r20, SREG			;preserve status reg
			ldi			button_press, 0x0F	;button_press reg set with 0x0F flag indicating bottom button was pressed
			out			SREG, r20
			reti



ISR_PCINT2:									;button near top (PD0) 
			in			r20, SREG			;preserve status reg
			ldi			button_press, 0xFF	;button_press reg set with 0xFF flag indicating top button was pressed
			out			SREG, r20
			reti






.include		"lib_delay.asm"
.include		"lib_GFX.asm"
.include		"lib_SSD1306_OLED.asm"
