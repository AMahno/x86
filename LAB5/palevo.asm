                STACK_SEG SEGMENT STACK 'STACK'
                DW      32 DUP(?)
                STACK_SEG ENDS

                DATA_SEG SEGMENT 
astr            DB      ' |--|--|---|', 13, 10, '$' 
bstr            DB      ' |-A|-B|-Y-|', 13, 10, '$'
cstr            DB      ' |--|--|---|', 13, 10, '$'  
estr            DB      '/|  |  |   |', 13, 10, '$'
fstr            DB      ' |--|--|---|', 13, 10, '$' 

maxdiv          db      3                 
realdiv         db      ?         
divs            db      2 DUP ('0')    

maxa            DB      3                                               
reala           DB      ?                 
numa            Db      2 DUP ('x')       
maxb            DB      2                                               
realb           DB      ?                 
numb            Db      1 DUP ('y')      



                DATA_SEG ENDS

                CODE_SEG SEGMENT 'CODE'
START:                  
                ASSUME  CS:CODE_SEG, SS:STACK_SEG, DS:DATA_SEG

                MOV     AX, DATA_SEG                           
                MOV     DS, AX                              
                MOV     ES, AX 

                CALL    CLEARSCREEN

                MOV     DX, 0000H
                CALL    KURSOR

                CALL    TBL

                MOV     DX, 0302H
                CALL    KURSOR

                MOV     AH, 0AH                            
                LEA     DX, maxa                            
                INT     21H

                XOR     BH, BH                            
                MOV     BL, reala 
                MOV     [numa+BX], '$'   

                MOV     DX, 0302H
                CALL    KURSOR

                MOV     AH, 09H                            
                LEA     DX, numa                            
                INT     21H

                MOV     DX, 0305H
                CALL    KURSOR

                MOV     AH, 0AH
                LEA     DX, maxb
                INT     21H

                XOR     BH, BH                            
                MOV     BL, realb 
                MOV     [numb+BX], '$'   

                MOV     DX, 0305H
                CALL    KURSOR

                MOV     AH, 09H                            
                LEA     DX, numb                            
                INT     21H


                                                           ;DIV_______________________________________________-

                MOV     CX, 02
                SUB     AH, AH

                AND     numb, 0Fh

                LEA     SI, numa
                LEA     DI, divs

A3:                     
                LODSB    
                AND     AL, 0Fh

                AAD      
                DIV     numb
                STOSB    
                LOOP    A3


                LEA     BX, divs
                MOV     CX, 02
A4:                     
                OR      BYTE PTR[BX], 30H

                INC     BX
                LOOP    A4

                MOV     [divs+2], '$' 
                MOV     DX, 0308h
                CALL    KURSOR

                MOV     AH, 09H
                LEA     DX, divs
                INT     21H
;EXIT_________________________________________________
                mov     ah, 08h             
                int     21h       
                mov     ax, 4c00h 
                int     21h 

;FUNCTIONS______________________________________________________
CLEARSCREEN     PROC     
                MOV     AH, 06H                            ;CLEAR SCREEN    
                MOV     AL, 00H                            ; SHOULDER ON 0 STRING UP 
                MOV     BH, 07H                            ;PARAMETERS SCREEN NORMAL (80*25), BLACK&WHITE
                MOV     CX, 0000H                          ;FIRST COORD 0, 0
                MOV     DX, 184FH                          ;END COORD 24, 79
                INT     10H
                RET     
CLEARSCREEN     ENDP    

TBL             PROC    
                MOV     AH, 09H      
                LEA     DX, astr    
                INT     21H
                LEA     DX, bstr    
                INT     21H   
                LEA     DX, cstr    
                INT     21H  
                LEA     DX, estr    
                INT     21H  
                LEA     DX, fstr    
                INT     21H  

                RET     
TBL             ENDP    

KURSOR          PROC    
                MOV     AH, 02H
                MOV     BH, 00
                INT     10H
                RET     
KURSOR          ENDP    

ASC_BCD         PROC                                       ;перетворення ASCII-коду в неупакований BCD-формат    
                lea     bx, numa+1    
                mov     cx, 02   
r2:                     
                and     byte ptr[bx], 0Fh            
                dec     bx                           
                loop    r2         

                RET      
ASC_BCD         ENDP     

                CODE_SEG ENDS
                END     START