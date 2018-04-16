;  Лекция 2
;  Считывание даты и времени напрямую из регистров CMOS
;

                DATAS   segment  'Data'
; Текстовые сообщения
Txt1            DB      "СЧИТЫВАНИЕ ДАТЫ И ВРЕМЕНИ ИЗ CMOS", 10, 13
                DB      "ТЕКУЩАЯ ДАТА И ВРЕМЯ:", '$'
; Указания оператору
change          DB      10, 13, "Задайте способ счета и формат времени"
                DB      10, 13, "0 - bcd&12"
                DB      10, 13, "1 - bcd&24"
                DB      10, 13, "2 - bin&12"
                DB      10, 13, "3 - bin&24"
                DB      10, 13, "<space>- не изменять"
                DB      10, 13, "Q - Exit", '$'
; Шаблон даты и времени
Date_Time       DB      10, 13, "00.00.0000  00:00:00   ", '$'
; Значение даты в CMOS
CMOS_Century    DB      ?                                  ; reg 32h
CMOS_Year    DB ?
CMOS_Month   DB ?
CMOS_Day     DB ?
; Значение времени в CMOS
CMOS_Hour    DB ?
CMOS_Minute  DB ?
CMOS_Second  DB ?
; Флаги и маски способа счета и формата времени
BIN_BCD_Flag DB 0
_24_12_Flag  DB 0
AM_PM        DW '  '
MASKA        DB ?
prochod      DB 0
DATAS ENDS

stacks  segment para stack 'STACK'
        DB 20h DUP(?)
stacks ENDS
hour24  equ       2
bin     equ       4

CmosRead          MACRO   MEM
;; AL = regCmos
        out    70h,al
        nop
        in      al,71h
        mov     MEM,al
                  ENDM
                  
schowBcdBinByte   MACRO   date
LOCAL  bcd,bin,ASCII
;; Подготовить к выводу al(packetBCD|BIN) => AX(ASCII)
;; STORE ES:DI,DI+1
        xor     ax,ax
        mov     al,date        ;;al=xy
        cmp     BIN_BCD_Flag,1
        je      bin
bcd:
        shl     ax,4
        shr     al,4           ;; ax = 0x0y
        jmp     ASCII

bin:
        aam                    ;; ax = unpack BCD
ASCII:
        or     ax,3030h
        xchg   ah,al
        stosw
        ENDM

Convert macro Hour
LOCAL   _am,_pm,done
        xor     ax,ax
        mov     al,Hour
        cmp _24_12_Flag,1        ;24 mode?
        je  done

        test    al,80h           ;am/pm?
        jz     _am
_pm:                             ; pm = post meridiem (пополудни)
        and     al,7Fh          ; clear al.7
        mov     AM_PM,'mp'
        jmp     done
_am:                             ; am = ante meridiem (до полудня)
        mov     AM_PM,'ma'
done:                         ; al = converted Hour
        mov    Hour,al
        ENDM


CODES  segment 'code'
.386
;*****************************
;* Основной модуль программы *
;*****************************
        ASSUME SS:STACKS, DS:DATAS, CS:CODES
Start:
        mov     AX,DATAS
        mov     DS,AX
        mov     ES,AX
; Установить текстовый режим и очистить экран
        mov     AX,3
        int     10h
; Вывести заголовок на экран
        lea dx,Txt1
        mov ah,09
        int 21h

 NEXT:
        inc byte ptr prochod      ; первый проход
; Запретить прерывания
        cli
; Проверить флаг обновления состояния
@@TestUIP:
        mov     AL,0Ah    ;регистр состояния A
        out     70h,AL
        nop
        in      AL,71h
        test    AL,80h
        jnz     @@TestUIP ;повторить опрос
; Чтение времени из CMOS
        mov     AL,00h    ;регистр секунд
        CmosRead   CMOS_Second
        mov     AL,02h    ;регистр минут
        CmosRead   CMOS_Minute
        mov     AL,04h    ;регистр часов
        CmosRead   CMOS_Hour
; Проверить флаг обновления состояния
        mov     AL,0Ah    ;регистр состояния A
        out     70h,AL
        nop
        in      AL,71h
        test    AL,80h
        jnz     @@TestUIP ;повторить опрос
; Чтение даты из CMOS
        mov     AL,07h    ;номер дня месяца
        CmosRead   CMOS_Day
        mov     AL,08h    ;номер месяца
        CmosRead   CMOS_Month
        mov     AL,09h    ;номер года в столетии
        CmosRead   CMOS_Year
        mov     AL,32h    ;номер столетия
        CmosRead   CMOS_Century
; Проверить флаг обновления состояния
        mov     AL,0Ah    ;регистр состояния A
        out     70h,AL
        in      AL,71h
        test    AL,80h
        jnz     @@TestUIP ;повторить опрос
; Разрешить прерывания
        sti

; Определить способ счета и формат представления времени
        mov     al,0Bh
        out     70h,al
        nop
        in      al,71h

;         00000000b
;         ||||||||___ 1-Enable summer time
;         |||||||____ 0-12/1-24 hour format
;         ||||||_____ 0-bcd/1-bin data
;         |||||______ reserved
;         ||||_______ 1-Enable int when updating time
;         |||________ 1-Enable int watchdog
;         ||_________ 1-Enable period int
;         |__________ 1-Enable write time /

        mov       byte ptr _24_12_Flag,0
        mov       byte ptr BIN_BCD_Flag,0
        mov     AM_PM,'  '
        test      al,hour24
        SETNZ     _24_12_Flag           ; см. [Зубков С.В., стр.47]
        test      al,bin
        SETNZ     BIN_BCD_Flag


; Подготовить к выводу дату  dd.mm.YYYY
        mov     DI,offset Date_Time+2
schowBcdBinByte CMOS_Day
        inc  DI
schowBcdBinByte CMOS_Month
        inc  DI
schowBcdBinByte CMOS_Century
schowBcdBinByte CMOS_Year
        inc  DI
        inc  DI

; Подготовить к выводу время  hh:mm:ss [am|pm]
convert   CMOS_Hour
schowBcdBinByte CMOS_Hour
        inc  DI
schowBcdBinByte CMOS_Minute
        inc  DI
schowBcdBinByte CMOS_Second
        inc  DI
        mov  ax,AM_PM
        stosw
; Вывод сообщения
        mov  DX, offset Date_Time
        mov  ah,09
        int  21h

; изменить способ счета и формат времени

        cmp byte ptr prochod, 1
        jne  continue
        mov  DX, offset change
        mov  ah,09
        int  21h
continue:
        mov  ah,6
        mov  dl,' '
        int 21h
        mov  ah,01
        int  21h
        cmp  al,'Q'
        je  exit
        cmp al,' '
        je   NEXT
        and al,0fh
        
        irp char,<0,1,2,3>
        cmp  al,char
        jne  L&char
        mov al,char
L&char:
        nop
        endm

        shl al,1
        mov MASKA,al
;; change RTC reg0B
        mov  al,0Bh
        out  70h,al
        in   al,71h
        and  al,11111001b
        or   al,MASKA
        out  71h,al
 more:  jmp NEXT
 exit:

; Переустановить текстовый режим (очистить экран)
        mov     ax,3
        int     10h
; Выход в DOS
        mov     AH,4Ch
        int     21h

ENDS

END Start