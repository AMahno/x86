                STACK_SEG SEGMENT PARA STACK 'STACK'       
                DB      100 DUP(?)                         
                STACK_SEG ENDS                             

                DATA_SEG SEGMENT                               
HELLO           DB      "Hello, $"                             
WORLD           DB      15, 15 DUP(' '), '$'                   
                DATA_SEG ENDS                                  

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:DATA_SEG, ES:DATA_SEG

BEG_:                   
                PUSH    DS
                XOR     AX, AX
                PUSH    AX

                MOV     AX, DATA_SEG                             
                MOV     DS, AX                                   

                MOV     AX, 03h                                  
                INT     10h                                      

                LEA     DX, WORLD                            
                MOV     AH, 0Ah                              
                INT     21h                                  

                XOR     BX, BX                               
                MOV     BL, WORLD[1]                         
                MOV     WORLD[BX+2], '$'                     

											
                MOV     AH, 09h                              
                INT     21h                                  

                LEA     DX, WORLD+2                          
                INT     21h                                  

                MOV     AH, 08h                              
                INT     21h                                  


                RETF     
                                                           ;MOV     AH, 4Ch                            
                                                           ;INT     21h                                

                _TEXT   ENDS                               
                END     BEG_                               