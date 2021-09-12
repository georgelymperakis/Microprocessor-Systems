;EXERCISE 3 / 5TH GROUP 

INCLUDE "macros_lib.asm"
;--------------------------------
DATA SEGMENT
        NEWLINE DB 0AH,0DH,'$' 
DATA ENDS
;------------------------------------    

;-----------------------------------
CODE SEGMENT
    ASSUME CS:CODE_SEG, DS:DATASEG
    
MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX
    
START:
    MOV DX,0
    MOV CX,3        ;ITERATOR
ADDR1:
    CALL HEX_KEYB  ;READ HEX
    CMP AL,'T'     ;IF 'T' EXIT
    JE QUIT       
    ADD AL,30H     ;PRINT HEX
    PRINT AL
    SUB AL,30H     ;ROTATE CURRENT SUM 4 TIMES
    SHL DX,1
    SHL DX,1
    SHL DX,1
    SHL DX,1
    ADD DL,AL       ;ADD AL TO CURRENT SUM
    LOOP ADDR1      ;REPEAT 3 TIMES
    MOV BX,DX
    PRINT '='
    CALL PRINT_DEC   ;PRINT IN DECIMAL FORM
    PRINT '=' 
    CALL PRINT_OCT   ;PRINT IN OCTAL FORM
    PRINT '=' 
    CALL PRINT_BIN   ;PRINT IN BINARY FORM  
    PRINT_STR NEWLINE 
    
    JMP START
QUIT:
    EXIT
MAIN ENDP

;PRINT DEC--------------------------------
PRINT_DEC PROC NEAR   
    PUSH BX
    MOV AH,0
    MOV AX,BX 			
    MOV BL,10 	
    MOV CX,1 			
LOOP_10: 
    DIV BL			; DIVIDE AX BY 10
    PUSH AX         ; SAVE AX    	    
    CMP AL,0 		; IF 0 PRINT	
    JE PRINT_DIGITS_10  
    INC CX			; INCREMENT DIGITS
    MOV AH,0   
    JMP LOOP_10		;REPEAT	
PRINT_DIGITS_10:    ;PRINT
    POP DX			
    MOV DL,DH
    MOV DH,0			
    ADD DL,30H
    PRINT DL		
    LOOP PRINT_DIGITS_10	   
    POP BX    
    RET
ENDP PRINT_DEC          

;PRINT OCT---------------------------
PRINT_OCT PROC NEAR

    PUSH BX
    MOV AH,0
    MOV AX,BX 
    MOV BL,8 
    MOV CX,1 
LOOP_8: 
    DIV BL    ; DIVIDE AX BY 6
    PUSH AX   ;SAVE AX              
    CMP AL,0   ; IF 0 PRINT
    JE GOOUT_8              
    INC CX    ; INCREMET DIGITS
    MOV AH,0   
    JMP LOOP_8 ;REPEAT
GOOUT_8: 
    MOV DH,AL
    PUSH DX   
    
    POP DX
PRINT_DIGITS_8:  ;PRINT
    POP DX
    MOV DL,DH
    MOV DH,0
    ADD DL,30H
    PRINT DL
    LOOP PRINT_DIGITS_8  
    POP BX     
    RET
ENDP PRINT_OCT      

;PRINT BIN --------------------------------
PRINT_BIN PROC NEAR  ;HERE WE TAKE A DIFFERENT APPROACH
    PUSH BX          ;DUE TO DIVIDE OVERFLOW OF LARGE NUMBERS
    MOV AX,BX 
    MOV CX,16        
DISCARD_ZEROS:      ;REMOVE MSB OF AH AND FRST ZEROS OF BINARY
    SHL BX,1        ; SHIFT LEFT WTH CARRY
    JC PRINT_DIGITS_2      ; IF CARRY IS 1 PRINT
    LOOP DISCARD_ZEROS
    PRINT '0'
    JMP FIN       
PRINT_DIGITS_2:            ;PRINT THE ONE IN CARRY
    PRINT '1' 
    DEC CX          ;DECREMENT ITERATOR
PRINT_LOOP: 
    SHL BX,1        ; SHIFT LEFT WTH CARRY
    MOV DL,0        ; ADD CARRY TO DL
    ADC DL,0
    ADD DL,30H      ;PRINT DL
    PRINT DL    
    LOOP PRINT_LOOP
FIN: 
    POP BX   
    RET
ENDP PRINT_BIN 



;HEX_KEYB ------------------------  
HEX_KEYB PROC NEAR


IGNORE:    
    READ
    CMP AL,30H        
    
    JL IGNORE
    CMP AL,39H       
    JG CHECK_LETTER
    SUB AL,30H        
    JMP INPUT_OK
 
CHECK_LETTER:
    CMP AL,'T'       
    JE INPUT_OK
    CMP AL,'A'       
    JL IGNORE         
    CMP AL,'F'        
    JG IGNORE
    SUB AL,37H        
    
INPUT_OK:          
    RET  
HEX_KEYB ENDP

CODE   ENDS   
;----------------

    END MAIN  
