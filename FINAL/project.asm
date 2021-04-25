			#include<p18F4550.inc>
loop_cnt1	set	0x00
loop_cnt2	set	0x01


			org 0x00 
			goto start 
			org 0x08 
			retfie 
			org 0x18 
			retfie
	
dup_nop	macro	kk	
		variable i 
i = 0
		while i < kk 
		nop		
i += 1
		endw 
		endm


start		SETF	TRISB,A ;configure portB as input
			CLRF	TRISE,A ;configure portE as output
			CLRF 	TRISD,A ;configure portD as output
			CLRF	PORTD,A ;initialize portD to turn off
			CLRF	PRODH,A ;initialize PRODH to hold the value
			BSF		PORTE,1,A ;disable 2nd 7seg, enable 1st 7seg
			BCF		TRISC,2,A 
			BCF		PORTC,2,A

			


                                                                                                                                                                                                                       
AGAIN      	BTFSS	PORTB,0	;CHECK SW1 CONDITION
			BRA		FIRST	;SW1
			BTFSC	PORTB,1 ;CHECK SW2 CONDITION
			BRA		AGAIN 	;SW2
			MOVLW 	0x0A 	;SW2
			MOVWF 	PRODL,A ;SW2
			BRA 	LOOP3	;SW2
			NOP


					
;SW1		
FIRST		BSF		PORTD,7,A ;EXECUTE WHEN SW1 IS PRESSED
			CALL	DELAY1S
			MOVLW 	0x07
			MOVWF 	PRODL,A
			BRA	 	LOOP


;SW1 ROTATE 
LOOP		RRNCF	PORTD,F,A
			CALL	DELAY0.5S
			DECFSZ	PRODL,F,A
			BRA		LOOP
			CALL	BLINK

BLINK		RLNCF	PORTD,F,A
			CALL	DELAY0.5S
			RLNCF	PORTD,F,A
			CALL	DELAY0.5S
			RLNCF	PORTD,F,A
			CALL	DELAY0.5S
			RLNCF	PORTD,F,A
			CALL	DELAY0.5S
			RLNCF	PORTD,F,A
			CALL	DELAY0.5S
			RLNCF	PORTD,F,A
			CALL	DELAY0.5S
			RLNCF	PORTD,F,A
			CALL	DELAY0.5S			
			BRA		LOOP2
		
;BLINK					
LOOP2		SETF	PORTD,A
			CALL	DELAY0.5S
			CLRF	PORTD,A
			BRA		BLINK2
				
			

;EFFECTS
BLINK2		MOVLW	B'10101010'
			MOVFF   WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'01010101'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'10101010'
			MOVFF   WREG,PORTD
			CALL	DELAY0.5S
			MOVLW	B'01010101'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'10000001'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'01000010'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'00100100'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW	B'00011000'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'00100100'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'01000010'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			MOVLW 	B'10000001'
			MOVFF	WREG,PORTD
			CALL	DELAY0.5S
			CLRF	PORTD,A
			BRA		BLINK2

			NOP
			RETURN


;SW2 7SEG DISPLAY
LOOP3		MOVFF	PRODH,PORTD
			CALL	DELAY1S
			INCF	PRODH,F,A
			DECFSZ	PRODL,F,A	
			BRA		LOOP3
			CALL	BUZZER
			CLRF	PRODH,A
			CLRF	PORTD,A
			BRA		LED1
		
			RETURN
	
			
LED1		SETF	PORTD,A  ;LED
			CALL	DELAY0.5S
			CLRF	PORTD,A
			CALL	DELAY0.5S
			CALL	BUZZER   
			SETF	PORTD,A
			CALL	DELAY1S
			CLRF	PORTD,A
			
			RETURN



BUZZER		BSF		PORTC,2,A ;BUZZER ON
			CALL	DELAY1S	
			BCF		PORTC,2,A ;BUZZER OFF
			CALL 	DELAY1S
			
			RETURN
	



;1ST DELAY
DELAY1S		MOVLW	D'80'		 ;1sec delay subroutine for 
			MOVWF	loop_cnt2,A	 ;20MHz
AGAIN1		MOVLW	D'250'
			MOVWF	loop_cnt1,A 
AGAIN2		dup_nop	D'247'	
			DECFSZ	loop_cnt1,F,A	
			BRA		AGAIN2
			DECFSZ	loop_cnt2,F,A	
			BRA		AGAIN1
			NOP
				
			RETURN



;2ND DELAY
DELAY0.5S	MOVLW	D'40'		 ;0.5sec delay subroutine for 
			MOVWF	loop_cnt2,A	 ;20MHz
AGAIN3		MOVLW	D'250'
			MOVWF	loop_cnt1,A 
AGAIN4		dup_nop	D'247'	
			DECFSZ	loop_cnt1,F,A	
			BRA		AGAIN2
			DECFSZ	loop_cnt2,F,A	
			BRA		AGAIN1
			NOP
		
			RETURN
			
			END	