                .MODEL  TINY         
                .DATA    
set             DB      "A20 is set", 0Dh, 0Ah, '$'
not_set         DB      "A20 is not set", 0Dh, 0Ah, '$'
                .CODE    
                .386     
                ORG     100H                               ; ???-?????????
START           PROC    NEAR                             
                MOV     AX, 03h                                  
                INT     10h     

                mov     edi, 112345h                       ;odd megabyte address.
                mov     esi, 012345h                       ;even megabyte address.
                mov     [esi], esi                         ;making sure that both addresses contain diffrent values.
                mov     [edi], edi                         ;(if A20 line is cleared the two pointers would point to the address 0x012345 that would contain 0x112345 (edi)) 
                cmpsd                                      ;compare addresses to see if the're equivalent.   
                jne     A20_on                             ;if not equivalent , A20 line is set.

                LEA     DX, not_set                        ; print string
                MOV     AH, 09h                                         
                INT     21h                                           ;if equivalent , the A20 line is cleared.
    
    jmp exit

A20_on:                 
                LEA     DX, set                          ; print string
                MOV     AH, 09h                                         
                INT     21h     
exit:         
    
                MOV     AH, 08h                          
                INT     21h                              
                ret      

start           ENDP     


                end     start                            