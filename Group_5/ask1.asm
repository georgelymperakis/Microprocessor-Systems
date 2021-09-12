;EXERCISE 1 / 5TH GROUP 

include "macros_lib.asm"

;---------------------------------------------------                     
DATA SEGMENT
    
    TABLE DB 128 DUP(?)
                        
              
DATA ENDS
;---------------------------------------------------



;---------------------------------------------------
CODE SEGMENT

    ASSUME CS: CODE , DS : DATA    
                               
MAIN PROC FAR                      
                  
    MOV AX,DATA
    MOV DS,AX
    
    MOV DI,0
    MOV CL,128
    
    
STORE_ARRAY: ;CREATE THE ARRAY
    MOV TABLE[DI],CL
    INC DI
    LOOP STORE_ARRAY  
    

    MOV CX,64 
    MOV DI,1
    MOV AX,0
    MOV DH,0    
    
SUM_ODDS: ;ADD TOGETHER ALL THE ODDS NUMBER
    MOV DL,TABLE[DI] 
    ADD AX,DX   
    ADD DI,2
    LOOP SUM_ODDS 
    
    MOV CL,64
    DIV CL
    

    CALL PRINT_DEC_BCD    
      
    PRINT_LN
    
    ;AL <- MIN,AH <- MAX
   
    MOV AL,TABLE[0]
    MOV AH,TABLE[0]             
    MOV CX,127 
    MOV DI,1
   
FIND_MIN_MAX: ;FIND MIN-MAX VALUE IN THE ARRAY
    CMP CX,0
    JE PRINT
    MOV DL,TABLE[DI]
    INC DI
    DEC CX       
    CMP AL,DL
    JNC NEW_MIN  
    CMP AH,DL
    JNC NEW_MAX
    JMP FIND_MIN_MAX 
    
NEW_MIN:
    MOV AL,DL
    JMP FIND_MIN_MAX

NEW_MAX:
    MOV AH,DL    
    JMP FIND_MIN_MAX

PRINT:    ;PRINT THE MIN-MAX FROM BEFORE
       
       
    MOV DL,AH ;PRINT MAX
    AND DL,0F0H 
    CMP AL,0
    JE SECOND    ;CHECK IF THE FIRST DIGIT IS ZERO
    MOV CL,4     ;AND SKIP IT
    RCR DL,CL
    CALL PRINT_HEX
    MOV DL,AH
    AND DL,0FH
    CALL PRINT_HEX
    
    PRINT ' '   
    
SECOND: ;PRINT MIN          
    MOV DL,AL
    AND DL,0F0H
    JE LAST
    MOV CL,4
    RCR DL,CL
    CALL PRINT_HEX 
   LAST: 
    MOV DL,AL
    AND DL,0FH
    CALL PRINT_HEX
    
    EXIT

MAIN ENDP         
      
      

PRINT_HEX PROC NEAR  ;ROUTINE FOR PRINTING HEXADECIMAL NUMBER
    CMP DL, 9 
    JG ADDR1 
    ADD DL, 30H
    JMP ADDR2
ADDR1:
    ADD DL, 37H 
    ADDR2:       
    PRINT DL 
    RET

PRINT_HEX ENDP  
               
               
               
PRINT_DEC_BCD PROC NEAR ;ROUTINE FOR PRINTING DECIMAL NUMBER IN BCD FORMAT
    MOV CX,0
DIGIT:
    MOV DX,0
    MOV BX,10D
    DIV BX
    PUSH DX
    INC CX
    CMP AX,0
    JNE DIGIT
TIGID:
    POP DX
    MPRINT_DEC
    LOOP TIGID 
    
    RET   

PRINT_DEC_BCD ENDP 



CODE ENDS  
;---------------------------------------------------

END MAIN    