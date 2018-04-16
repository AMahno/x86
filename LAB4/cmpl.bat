echo off
echo Let the hacking begin
c:\asmed\asm\tasm\bin\tasm.exe lab41.asm
c:\asmed\asm\tasm\bin\tasm.exe time_m.asm
c:\asmed\asm\tasm\bin\tlink.exe lab41.obj time_m.obj
pause
c:\asmed\asm\tasm\bin\td.exe