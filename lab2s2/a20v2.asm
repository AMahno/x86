                .MODEL  SMALL         
                .STACK  
                .DATA    
hello           DB      "hello", 0Dh, 0Ah, '$'   
                .CODE    
                .386     
                ORG     100H                               ; ???-?????????
START           PROC    NEAR                             
                MOV     AX, 03h                                  
                INT     10h     

                MOV     AX, @DATA
                MOV     ES, AX

                MOV     EDI, 0B80000h         
                LEA     ESI, hello            
                MOV     CX, 8                 
                REP     MOVSB                 


                MOV     EDX, 0B80000h
                MOV     AH, 09h 
                INT     21h     


exit:                   

                MOV     AH, 08h                          
                INT     21h                              
                ret      

start           ENDP     


                end     start                            