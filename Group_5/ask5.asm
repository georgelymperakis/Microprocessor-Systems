;EXERCISE 5 / 5TH GROUP 


INCLUDE "macros_lib.asm"   


;---------------------------------------------------
DATA SEGMENT
    MSG1 DB 'START (Y,N) : $'
    MSG2 DB 0AH,0DH,'VOLTAGE (VOLT)  |   TEMPRATURE (CELSIUS)$'
    
    ERROR DB 'ERROR$'  
      
DATA ENDS
;--------------------------------------------------- 


;---------------------------------------------------
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA 
        

MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX
    
    PRINT_STR MSG1

START:
      
    READ    ;START THE PROGRAM AND WAIT FOR WHAT 
    CMP AL,'Y'; THE USER WANTS TO DO (START OR STOP) 
    JE CON
    CMP AL,'N'
    JE QUIT
    JMP START 

CON:
    PRINT 'Y'
    PRINT_LN
    PRINT_STR MSG2
    PRINT_LN  
    PRINT_LN
       
READ_VOL: ; READ THE FIRST 12 BITS (IN FORM OF 3 HEXADECIMAL)
  
    MOV BH,16D       
    MOV AX,0
                     
    CALL HEX_KEYB ;READ FIRST HEXADECIMAL
    MUL BH
    MUL BH      ;SHIFT THE NUMBER 8 TIMES
    
    MOV DX,AX        
    
    CALL HEX_KEYB ;READ SECOND HEXADECIMAL
    MUL BH        ;SHIFT THE NUMBER 4 TIMES
    ADD DX,AX
    
    
    CALL HEX_KEYB ;READ THIRD HEXADECIMAL
    MOV AH,0
    ADD AX,DX    ; LINK THE 3 NUMBERS

    
    PRINT_TAB  ;PREPARE THE USER FOR THE RESULT
    PRINT_TAB
    PRINT '|'
    PRINT_TAB
    
   
    CMP AX,2047D ;CHECK IN WHICH BRANCH YOUR VOLTAGE IS
    JBE BR1
    CMP AX,3071D
    JBE BR2
    PRINT_STR ERROR ; IF YOU ARE HERE THEN YOU HAVE A WRONG INPUT 
    PRINT_LN
    JMP READ_VOL ;GO TO THE NEXT INPUT 
 
BR1:      
    MOV BX,800D ;BRANCH 1 ->CALCULATE THE EXPRESSION 
    MUL BX
    MOV BX,4095D
    DIV BX
    JMP PRINT


BR2:
    MOV BX,3200D ;BRANCH 1 ->CALCULATE THE EXPRESSION 
    MUL BX
    MOV BX,4095D
    DIV BX  
    SUB AX,1200D
    

PRINT:  ;NOW IT'S THE TIME FOR PRINTING 

    PUSH DX ;SAVE IS STACK THE REMINDER OF THE ABOVE DIVISION  
    MOV CX,0 
    
  DIGIT: ;ALGORITH FOR PRINTING IN BCD FORM THE NUMBER 
    MOV DX,0
    MOV BX,10D 
    DIV BX
    PUSH DX
    INC CX
    CMP AX,0
    JNE DIGIT
    MOV AX,DX
    

  TIGID: ;NOW POP THE NUMBERS FROM THE STACK
    POP DX
    MPRINT_DEC ;AND PRINT THEM FROM THE MSB TO LSB
    LOOP TIGID 
    
    PRINT '.'  ;BE READY FOR THE FRACTIONAL PART 

    POP DX 
    MOV AX,DX
    
    MOV BX,10 ;CODE FOR CALCULATING THE FRACTIONAL PART
    MUL BX
    MOV BX,4095
    DIV BX      
    MOV DL,AL
    MPRINT_DEC ;PRINT IT 
          
    PRINT_LN ;GO TO THE NEXT LINE
    
    JMP READ_VOL ; LET'S READ THE NEXT 12BIT
            
                
QUIT: ;IF THE USER HAS PRESS THE BUTTON "N" AT ANY MOMENT
    EXIT ;THEN HE GOES HERE AND THE PROGRAM RETURN THE CONTROL        
         ;BACK TO THE OPERATING SYSTEM


MAIN ENDP 


HEX_KEYB PROC NEAR ;ROUTINE WHICH READ THE ASCII NUMBER AND
                   ;CONVERT IT IN HEXADECINAL SYSTEM
    PUSH DX 

IGNORE1:
    READ 
    CMP AL, 'N' 
    JE QUIT1


    CMP AL,30H 
    JL IGNORE1
    CMP AL,39H
    JG ADDR11
    PUSH AX 
    
PRINT AL 
    POP AX
    SUB AL,30H 
    JMP ADDR22

ADDR11: 
    CMP AL,'A'
    JL IGNORE1
    CMP AL,'F'
    JG IGNORE1
    PUSH AX
    PRINT AL
    POP AX
    SUB AL,37H 

ADDR22: 
    POP DX 
    RET 

QUIT1:
    EXIT
    
HEX_KEYB ENDP 
                                    

CODE ENDS
;---------------------------------------------------
    END MAIN