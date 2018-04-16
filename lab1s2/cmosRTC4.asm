                .MODEL  TINY         
                .DATA    
POST_MSG        DB      "RTC POWER VIA POST: $" 
RTC_MSG         DB      "RTC POWER VIA STATUS REG: $"  
ERROR_MSG       DB      "ERROR!", 0Dh, 0Ah, "$"
OK_MSG          DB      "OK", 0Dh, 0Ah, "$"                
                .CODE    
                .186     
                ORG     100H                               
START           PROC    NEAR                             
                MOV     AX, 03h                                  
                INT     10h                              


                MOV     AL, 0Dh                          
                OUT     70h, AL                          
                NOP      
                IN      AL, 71h                          

                LEA     DX, RTC_MSG                    
                MOV     AH, 09h                                         
                INT     21h           

                TEST    AL, 10000000B                    
                JNZ     RTC_ERR       
    
                LEA     DX, OK_MSG                    
                MOV     AH, 09h                                         
                INT     21h
    JZ   RTC_OK
    
RTC_ERR:                
                LEA     DX, ERROR_MSG
                MOV     AH, 09h                                         
                INT     21h

RTC_OK:

                MOV     AL, 0Eh
                OUT     70h, AL
                NOP      
                IN      AL, 71h

                LEA     DX, POST_MSG                    
                MOV     AH, 09h                                         
                INT     21h 

                TEST    AL, 10000000B
                JNZ     POST_ERR

                LEA     DX, OK_MSG                    
                MOV     AH, 09h                                         
                INT     21h  
    JZ POST_OK

POST_ERR:               
                LEA     DX, ERROR_MSG                  
                MOV     AH, 09h                                         
                INT     21h                              
POST_OK:

                MOV     AH, 08h                          
                INT     21h                              
                ret      

start           ENDP     
                end     start                            