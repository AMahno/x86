                STACK_SEG SEGMENT PARA STACK 'STACK'       
                DB      100 DUP(?)                         
                STACK_SEG ENDS                             

                DATA_SEG SEGMENT 
DE              DB      0deh  
AD              DB      0adh  
;HELLO           DB      "Hello, $"                             
;WORLD          DB      15, 15 DUP(' '), '$'                   
                DATA_SEG ENDS                                  

                AMYSEG  SEGMENT WORD                 
HELLO           DB      "HELLO, $"               
                AMYSEG  ENDS                         

                BMYSEG  SEGMENT WORD                     
WORLD           DB      15, 15 DUP(' '), '$'         
BE              DB      0beh                         
EF              DB      0efh                         
                BMYSEG  ENDS                         

                GROUP   MYGROUP AMYSEG, BMYSEG       

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:MYGROUP, ES:DATA_SEG

BEG_:                   
                PUSH    DS                           
                XOR     AX, AX                       
                PUSH    AX                           

                MOV     AX, MYGROUP                             
                MOV     DS, AX                                   

                MOV     AX, 03h                                  
                INT     10h                                      

                LEA     DX, WORLD                            
                MOV     AH, 0Ah                              
                INT     21h                                  

                XOR     BX, BX                               
                MOV     BL, WORLD[1]                         
                MOV     WORLD[BX+2], '$'                     

                LEA     DX, HELLO                            
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