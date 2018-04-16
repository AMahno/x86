;Программирование PIC
;Перехват прерывания от клавиатуры
;Печать скан-кодов нажатия и отпускания клавиш
;Возврат системного обработчика
                stack_s segment para stack 'stack'
                stack_s ends

                data_s  segment 'data'

old_09          dd      0

                data_s  ends
                code_s  segment 'code'

                .386     
main            proc    far

                assume  cs:code_s, ds:data_s, ss:stack_s
                mov     ax, data_s
                mov     ds, ax
 mov  es,ax

 
;-----запоминание старого обработчика Int 09h
 mov ax,3509h
 int 21h
 mov word ptr old_09,bx
 mov word ptr old_09 + 2,es

;------установка нового обработчика
 cli ;блокирование прерываний

 mov ax,2509h
 mov dx,seg kb_int
 mov ds,dx
 mov dx,offset kb_int
 int 21h
        sti ;разрешение прерываний


int_wait:  ;зацикливание ("ожидание прерывания")
   ; вывод скан кода 
 cmp dh,1 ;esc ?
 ;да - выход
 jnz int_wait
 


;------восстановление старого обработчика
exit:
 mov ax,2509h
 mov dx,word ptr old_09 +2
 mov ds,dx
 mov dx,word ptr old_09
 int 21h

;-----выход
 mov ax,4c00h
 int 21h

main endp


kb_int proc 
 
;возвращает в dh скан код нажатой или отжатой клавиши
; и выводит его на экран
 cli
 in al,60h ;получаем сканкод
 mov dh,al
 ;подтверждение ввода
 in al,61h
 or al,080h
 out 61h,al
 and al,7fh
 out 61h,al
        ;вывод скан-кода на экран
        push dx
        mov al,dh
 call print_al
; пробел 
        mov ah,02h
 mov dl,20h
 int 21h
        pop dx
  
 sti
 mov al,20h         ;EOI
 out   20h, al
 
        iret

kb_int endp

; Процедура print_al.
; выводит на экран число в регистре AL в шестнадцатеричном формате
; модифицирует значения регистров AX и DX


print_al proc
 mov dh,al
 and dh,0Fh  ; DH - младшие 4 бита
 shr al,4  ; AL - старшие
 call print_nibble ; вывести старшую цифру
 mov al,dh  ; теперь AL содержит младшие 4 бита
print_nibble:  ; процедура вывода 4 бит (шестнадцатеричной цифры)
 cmp al,10  ; три команды, переводящие цифру в AL
 sbb al,69h  ; в соответствующий ASCII-код
 das   ; (см. описание команды DAS)

 mov dl,al  ; код символа в DL
 mov ah,2  ; номер функции DOS в AH
 int 21h  ; вывод символа
 ret  ; этот RET работает два раза - один раз для возврата из
; процедуры print_nibble, вызванной для старшей цифры,
; и второй раз - для возврата из print_al
print_al endp


code_s ends
END  MAIN