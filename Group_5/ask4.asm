;EXERCISE 4 / 5TH GROUP 
INCLUDE "macros_lib.asm" 

   
;------------------------

DATA SEGMENT
    SYMBOLS DB 20 DUP(?)
    NEWLINE DB 0AH,0DH,'$'            
DATA ENDS

;-------------------------


CODE SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
    
    
    
MAIN PROC FAR  
    
    MOV AX,DATA
    MOV DS,AX
  
  
AGAIN:    
    MOV CX,20            ; INITIALIZE COUNTER
    MOV DI,0             ; INITIALIZE ITERATOR
INPUT:
    CALL GET_CHAR        ; GET CHARACTER (ACCEPTABLE ONLY)
    CMP AL,0DH           ; EXIT IF ENTER IS PRESSED
    JE END_OF_PROG
    MOV [SYMBOLS+DI],AL  
    PRINT [SYMBOLS+DI]   ; PRINT CHARACTER
    INC DI
    LOOP INPUT
      
      
      

OUTPUT:
    PRINT_STR NEWLINE     ; new line 
      
      
    MOV CX,20
    MOV DI,0 
    
PRINT_LETTERS:
    MOV AL,[SYMBOLS+DI]
    CMP AL,'a'            ; CHECK IF NON-CAPITAL ASCII 
    JL  NOT_A_LETTER
    CMP AL,'z'
    JG NOT_A_LETTER
    SUB AL,20H            ; MAKE CAPITAL 
    PRINT AL              ; PRINT CAPITAL
    
NOT_A_LETTER:
    INC DI
    LOOP PRINT_LETTERS
    

    
    PRINT '-'
    
    MOV CX,20
    MOV DI,0
PRINT_NUMS:
    MOV AL,[SYMBOLS+DI]
    CMP AL,30H            ; IF ASCII
    JL  NOT_A_NUMBER
    CMP AL,39H
    JG NOT_A_NUMBER
    PRINT AL              ; PRINT DIGITS
    
NOT_A_NUMBER:
    INC DI
    LOOP PRINT_NUMS 
      
        
    PRINT_STR NEWLINE     ; NEW LINE   
    JMP AGAIN
      
END_OF_PROG:
    EXIT
MAIN ENDP 


GET_CHAR PROC NEAR
IGNORE:    
    READ
    CMP AL,0DH
    JE INPUT_OK
    CMP AL,30H        ;IF INPUT < 30H ('0') IGNORE
    JL IGNORE
    CMP AL,39H        ; IF INPUT > 39H ('9') CHECK IF ASCII
    JG MAYBE_ASCII
    JMP INPUT_OK
 
MAYBE_ASCII:
    CMP AL,'a'        ; IF INPUT < 'a' IGNORE
    JL IGNORE         
    CMP AL,'z'        ; IF INPUT > 'z' IGNORE
    JG IGNORE
    
INPUT_OK:          
    RET  
GET_CHAR ENDP

CODE   ENDS   
;----------------------------------

    END MAIN
