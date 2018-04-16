                STACK_SEG SEGMENT PARA STACK 'STACK'       
                DB      100 DUP(?)                         
                STACK_SEG ENDS  

                ENTRY   STRUC                    
_NAME           DB      20 DUP (' ')             
SPORT           DB      20 DUP (' ')             
_GROUP          DB      20 DUP (' ')             
ADRESS          DB      20 DUP (' ')             
                ENTRY   ENDS                     

                DATA_SEG SEGMENT                 
PATH            DB      "C:\ASMED\DB\DB.TXT", 00h
FILH            DW      ?                        
AREA            DB      "Name", ";", "Sport", ";", "Group", ";", "Adress", ";", 10, 13
                STUDENT ENTRY 1 DUP (<"Vasya$;", "Boxing$;", "DK-51$;", "Yangelya$;">, \
                <"Petya$;", "Football$;", "DK-52$;", "Pobedy$;">,  \
                <"Vitya$;", "Running$;", "DK-41$;", "Borshaga$;">,  \
                <"Kesha$;", "Tennis$;", "DK-42$;", "Polytech$;">,  \
                <"Vanya$;", "Tourism$;", "DK-31$;", "Yangelya$;">)       

CRLF            DB      0Dh, 0Ah

                DATA_SEG ENDS                                                   

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:DATA_SEG, ES:DATA_SEG

WRITE_F         PROC    NEAR            
                MOV     AH, 40h                                         
                MOV     BX, FILH                                        
                INT     21h                                
                JC      EXIT_                                           
                                                           ;CMP     AX, 1Ah                                         
                                                           ;JNE     EXIT_
                RET      
                ENDP     

BEG_:                   

                MOV     AX, DATA_SEG                                    
                MOV     DS, AX                                          

                MOV     AX, 03h                                         
                INT     10h                                             

                MOV     AH, 3Ch                            ; create file                                         
                MOV     CX, 00                                          
                LEA     DX, PATH                                        
                INT     21h                                             
                JC      EXIT_                                           
                MOV     FILH, AX                                        

                LEA     DX, AREA                           ; write a header
                MOV     CX, 1Ah                            
                CALL    WRITE_F                            

                LEA     DI, STUDENT                        
                MOV     BX, SIZE ENTRY                     
                MOV     CX, 5
WRITE_CYCLE:            
                PUSH    CX      
                PUSH    BX 

                LEA     DX, [DI]                           
                MOV     CX, BX          
                CALL    WRITE_F                           

                LEA     DX, CRLF                          
                MOV     CX, 2                             
                CALL    WRITE_F                           

                POP     BX     
                POP     CX     
                ADD     DI, BX          
                LOOP    WRITE_CYCLE     
                                                           ;LEA     DX, ENTRY1              
                                                           ;MOV     CX, TYPE ENTRY1
                                                           ;CALL    WRITE_F        
                                                           ;LEA     DX, ENTRY1._NAME
                                                           ;MOV     AH, 09h   
                                                           ;INT     21h       

                MOV     AH, 08h                              
                INT     21h                                  

EXIT_:                  
                MOV     AH, 4Ch                            
                INT     21h                                

                _TEXT   ENDS                               
                END     BEG_                               