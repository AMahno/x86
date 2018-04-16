                STACK_SEG SEGMENT PARA STACK 'STACK'       
                DB      100 DUP(?)                         
                STACK_SEG ENDS     

                ENTRY   STRUC                    
_NAME           DB      20 DUP (' ')             
SPORT           DB      20 DUP (' ')             
_GROUP          DB      20 DUP (' ')             
ADRESS          DB      20 DUP (' ')
CRLF            DB      2 DUP (' ')
                ENTRY   ENDS                     

                DATA_SEG SEGMENT                 
PATH            DB      "C:\ASMED\DB\DB.TXT", 00h
FILH            DW      ?                
CARRY           DB      0Ah, 0DH, 24h    
QUESTION        DB      "ENTER SPORT TYPE: $"
REPL_QUEST      DB      "ENTER NEW SPORT: $"
FOUND           DB      "FOUND!$"        
INSPORT         DB      20, 19 DUP (' '), '$'
NEWSPORT        DB      20, 19 DUP (' '), '$' 
FOUND_INDEX     DW      0DEADh                
                DATABASE ENTRY 5 DUP (<>)     
                DATA_SEG ENDS                                                   

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:DATA_SEG, ES:DATA_SEG 

REPLACE         PROC    NEAR                  
                LEA     DI, DATABASE                       
                MOV     BX, SIZE ENTRY                     
                MOV     CX, FOUND_INDEX       

INDEX_CYCLE:            
                ADD     DI, BX                
                LOOP    INDEX_CYCLE           

                LEA     DI, [DI].SPORT        
                LEA     SI, NEWSPORT          
                ADD     SI, 2h                
                MOV     CX, 19                
                REP     MOVSB                 

                MOV     BX, FILH
                MOV     AH, 42h
                MOV     CX, 00h
                MOV     DX, 00h
                MOV     AL, 0
                INT     21h

                LEA     DX, DATABASE
                MOV     CX, 19Ah
                MOV     AH, 40h
                MOV     BX, FILH
                INT     21h

                RET      
                ENDP     


FIND            PROC    NEAR                               
                LEA     DI, DATABASE                       
                MOV     BX, SIZE ENTRY                     
                MOV     CX, LENGTH DATABASE                
                XOR     DX, DX
FIND_CYCLE:             
                LEA     SI, [DI].SPORT                     
                PUSH    DI                                 
                LEA     DI, INSPORT                        
                ADD     DI, 2h                             
                CLD      
                PUSH    CX                                 
                MOV     CX, 19                             
                REPE    CMPSB                              
                JNE     NOT_EQUALS                         
                MOV     FOUND_INDEX, DX
                CALL    DISPLAY_LINE                       
                                                           ;LEA     DX, FOUND                          
                                                           ;MOV     AH, 09h                            
                                                           ;INT     21h 
NOT_EQUALS:             
                POP     CX                                 
                POP     DI                                 
                ADD     DI, BX   
                INC     DX       
                LOOP    FIND_CYCLE                         

                RET      
                ENDP     

DISPLAY_LINE    PROC    NEAR                  
                LEA     DI, DATABASE
                MOV     BX, SIZE ENTRY
ADD_CYCLE:              
                CMP     DX, 0000h
                JZ      DSPL    
                ADD     DI, BX
                DEC     DX  
                JMP     ADD_CYCLE
DSPL:                   

                PUSH    DX             

                LEA     DX, [DI]._NAME   
                MOV     AH, 09h                            
                INT     21h           

                LEA     DX, [DI].SPORT
                MOV     AH, 09h
                INT     21h                   

                LEA     DX, [DI]._GROUP                       
                MOV     AH, 09h                               
                INT     21h                                   

                LEA     DX, [DI].ADRESS                       
                MOV     AH, 09h                               
                INT     21h                                   

                LEA     DX, CARRY                             
                MOV     AH, 09h                               
                INT     21h                                   
                POP     DX                                    

                RET      
                ENDP     

DISPLAY_DB      PROC    NEAR                                  
                LEA     DI, DATABASE                          
                MOV     BX, SIZE ENTRY                        
                MOV     CX, LENGTH DATABASE

CYCLE:                  
                LEA     DX, [DI]._NAME   
                MOV     AH, 09h
                INT     21h           

                LEA     DX, [DI].SPORT
                MOV     AH, 09h
                INT     21h           

                LEA     DX, [DI]._GROUP
                MOV     AH, 09h
                INT     21h                                

                LEA     DX, [DI].ADRESS
                MOV     AH, 09h
                INT     21h        
                                                              
                LEA     DX, CARRY                         
                MOV     AH, 09h
                INT     21h                               

                ADD     DI, BX        
                LOOP    CYCLE         
                RET      
                ENDP     
BEG_:                   

                MOV     AX, DATA_SEG                                    
                MOV     DS, AX
                MOV     ES, AX

                MOV     AX, 03h                                         
                INT     10h                                             

                MOV     AH, 3Dh                            ;OPEN FILE       
                MOV     AL, 02h                            ;RW
                LEA     DX, PATH                    
                INT     21h                         
                JC      EXIT_                       
                MOV     FILH, AX                    

                MOV     AH, 3Fh                            ;READ DB
                MOV     BX, FILH                           
                MOV     CX, 19Ah                           
                LEA     DX, DATABASE                       
                INT     21h                                
                JC      EXIT_                              

                CALL    DISPLAY_DB           
                                                           ;MOV     CX, 0001h
                                                           ;CALL    DISPLAY_LINE                     

                MOV     AH, 09h              
                LEA     DX, QUESTION         
                INT     21h                                   

                LEA     DX, INSPORT    
                MOV     AH, 0Ah        
                INT     21h            

                XOR     BX, BX          
                MOV     BL, INSPORT[1]   
                MOV     INSPORT[BX+2], ' '

                MOV     AH, 09h        
                LEA     DX, CARRY
                INT     21h      

                CALL    FIND  

                MOV     AH, 09h
                LEA     DX, REPL_QUEST
                INT     21h   

                LEA     DX, NEWSPORT
                MOV     AH, 0Ah
                INT     21h   

                XOR     BX, BX
                MOV     BL, NEWSPORT[1]
                MOV     NEWSPORT[BX+2], ' '

                MOV     AH, 09h
                LEA     DX, CARRY
                INT     21h

                CALL    REPLACE

                CALL    DISPLAY_DB



                MOV     AH, 08h                              
                INT     21h                                  

EXIT_:                  
                MOV     AH, 4Ch                            
                INT     21h                                

                _TEXT   ENDS                               
                END     BEG_                               