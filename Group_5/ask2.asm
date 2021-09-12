;EXERCISE 2 / 5TH GROUP 

INCLUDE "macros_lib.asm"

;---------------------------------------------------
DATA SEGMENT
    STR_Z DB "Z = $"         
    STR_W DB "W = $" 
    SUM DB "Z + W = $"
    SUBS DB "Z - W = $"  
    
    Z1 DB 0
    Z2 DB 0 
   
    W1 DB 0
    W2 DB 0                     
       
DATA ENDS
;---------------------------------------------------

;COMMENT:
; Z -> [ Z1 Z2 ]
; W -> [ W1 W2 ]



;---------------------------------------------------
CODE SEGMENT
         
    ASSUME CS:CODE,DS:DATA         
    
    MAIN PROC FAR
        
    START:
    
        MOV AX,DATA
        MOV DS,AX
        
        PRINT_STR STR_Z
        READ  ;READ THE FIRST ASCII NUMBER
        PRINT AL
        
        SUB AL,30H ;MAKE IT DECIMAL               
        MOV Z1,AL   
        
        READ ;READ THE SECOND ASCII NUMBER
        PRINT AL
         
        SUB AL,30H;MAKE IT DECIMAL     
        MOV Z2,AL
        
        PRINT ' '  
        
        PRINT_STR STR_W
        READ ;READ THE THIRD ASCII NUMBER 
        PRINT AL  
        
        SUB AL,30H ;MAKE IT DECIMAL                 
        MOV W1,AL 
        
        READ ;READ THE LAST ASCII NUMBER
        PRINT AL  
           
        SUB AL,30H;MAKE IT DECIMAL  
        MOV W2,AL        
 
                 
        PRINT_LN 
        PRINT_STR SUM  
        
        MOV AL,Z1
        MOV BL,10
        MUL BL
        MOV Z1,AL ; Z1 = 10*Z1  
        
        MOV AL,W1 ; W1 = 10*W1  
        MOV BL,10
        MUL BL
        MOV W1,AL 
        
        MOV AL,Z1
        ADD AL,Z2  
        MOV Z2,AL  ;MAKE THE NUMBER 10*Z1 + Z2
        
        MOV BL,W1
        ADD BL,W2
        MOV W2,BL  ;MAKE THE NUMBER 10*W1 + W2
        
        ADD AL,BL ;CALCULATE Z + W   
        
        MOV BL,AL  


        AND AL,0F0H ;START PRINTING THE NUMBER Z+W
        CMP AL,0 ;CHECK IF THE FIRST HEXADECIMAL IS ZERO
        JE L4     ; AND SKIP IT
        MOV CL,4
        RCR AL,CL
        MOV DL,AL 
        
        CALL PRINT_HEX  ;PRINT FIRST DIGIT
     L4:
        MOV AL,BL
        AND AL,0FH
        MOV DL,AL
        CALL PRINT_HEX ;PRINT SECOND DIGIT
        
        PRINT ' '  
        PRINT_STR SUBS
         
        MOV AL,Z2
        SUB AL,W2 ;CALCULATE Z - W 
        MOV BL,AL
        
        CMP AL,0  ;IF THE RESULT IT'S NEGATIVE
        JGE CON
        PRINT '-'   ;PRINT THE MINUS
        
        NEG AL       
        MOV BL,AL
        
             
             
             
   CON:   
        AND AL,0F0H
        CMP AL,0   ;CHECK IF THE FIRST HEXADECIMAL IS ZERO
        JE  L1     ; AND SKIP IT
        MOV CL,4
        RCR AL,CL
        MOV DL,AL
        CALL PRINT_HEX ;PRINT FIRST DIGIT
     L1:   
        MOV AL,BL
        AND AL,0FH
        MOV DL,AL
        CALL PRINT_HEX ;PRINT SECOND DIGIT
        
        PRINT_LN 
        PRINT_LN  
             
        JMP START    
             
    MAIN ENDP
         


PRINT_HEX PROC NEAR
    CMP DL, 9 
    JG ADDR1 
    ADD DL, 30H
    JMP L2

ADDR1:
    ADD DL, 37H 
L2: 

    PRINT DL
    RET
PRINT_HEX ENDP

 
CODE ENDS
;---------------------------------------------------
    
END MAIN 

