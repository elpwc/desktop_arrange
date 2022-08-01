@echo off
title Desktop Clean
setlocal enabledelayedexpansion
set root=%temp%\desktop_clean_root_folder
cd /d %temp%
if not exist desktop_clean_root_folder (
    md desktop_clean_root_folder
)
set folderlist="图片,视频,音频,摸鱼,文档,开发,网页,其他"
set imglist="jpg,png,jpeg,gif,bmp,psd,svg,webp,jfif"
set videolist="mp4,mov,3gp,flv,rmvb,swf,ogg,mvb"
set medialist="mp3,amw,mid,wav"
set paintlist="sai,sai2"
set doclist="doc,xls,pdf,ppt,docx,xlsx,pptx,rtf,txt,wps"
set develist="c,cpp,cs,bat,vbs,py,java,asm,e"
set pagelist="html,htm,xhtml,js,php,asp,aspx,css"

echo Press ENTER to clean desktop.
pause>nul
cls

cd /d %userprofile%\Desktop


::time
::set time_r=
set date_r=
::for /f "tokens=1,2 delims=:" %%i in ('time /t') do (set time_r=%%i%%j)
for /f "tokens=1 delims= " %%i in ('date /t') do (
    echo %%i>%root%\crt_date
    for /f "tokens=1,2,3 delims=/" %%i in (%root%\crt_date) do set date_r=%%i%%j%%k
)
set current_time=%date_r%
::%time_r%


::create folders
set array_each=
call :forArray %folderlist% "," "array_each","foreach_array1"


::cut files
set array_each=
call :forArray %imglist% "," "array_each","foreach_array_img"
call :forArray %videolist% "," "array_each","foreach_array_video"
call :forArray %medialist% "," "array_each","foreach_array_media"
call :forArray %paintlist% "," "array_each","foreach_array_paint"
call :forArray %doclist% "," "array_each","foreach_array_doc"
call :forArray %develist% "," "array_each","foreach_array_deve"
call :forArray %pagelist% "," "array_each","foreach_array_page"


echo Finish.

pause
exit


::foreach

:foreach_array1
if not exist !array_each!_%current_time% (
    md !array_each!_%current_time%||echo Create folder !array_each!_%current_time% fail.&exit /b 1
	echo Create folder !array_each!_%current_time% successfully.
)
exit /b 0

:foreach_array_img
move /-y *.!array_each! 图片_%current_time%\
exit /b 0

:foreach_array_video
move /-y *.!array_each! 视频_%current_time%\
exit /b 0

:foreach_array_media
move /-y *.!array_each! 音频_%current_time%\
exit /b 0

:foreach_array_paint
move /-y *.!array_each! 摸鱼_%current_time%\
exit /b 0

:foreach_array_doc
move /-y *.!array_each! 文档_%current_time%\
exit /b 0

:foreach_array_deve
move /-y *.!array_each! 开发_%current_time%\
exit /b 0

:foreach_array_page
move /-y *.!array_each! 网页_%current_time%\
exit /b 0



::ArrayFunctions

::FUNC getLength str
:getLength
set "str_gl=%~1"
set i_gl=0
goto loop_gl
:loop_gl
if "!str_gl:~%i_gl%,1!" NEQ "" (
    set /a i_gl+=1
    goto loop_gl
) else (
    exit /b %i_gl%
)

::FUNC getAmountOfChar str chr
:getAmountOfChar
set "str_gaoc=%~1"
set "chr_gaoc=%~2"
set r_gaoc=0
call :getLength "%str_gaoc%"
set strlen_gaoc=%errorlevel%
set /a strlen_gaoc-=1
for /l %%i in (0,1,%strlen_gaoc%) do (
    if "!str_gaoc:~%%i,1!" EQU "%chr_gaoc%" (
        set /a r_gaoc+=1
    )
)
exit /b %r_gaoc%

::FUNC getArrayLen arr splitChr
:getArrayLen
set "arr_gal=%~1"
set "splitChr_gal=%~2"
call :getAmountOfChar "%arr_gal%" "%splitChr_gal%"
set r_gal=%errorlevel%
set /a r_gal+=1
exit /b %r_gal%

::FUNC changeSplitChar arr formerSplitChr newSplitChr
:changeSplitChar
set "arr_csc=%~1"
set "formerSplitChr_csc=%~2"
set "newSplitChr_csc=%~3"
set "out_csc=%~4"
set array_each_csc=
call :getArrayLen "%arr_csc%" "%formerSplitChr_csc%"
set array_len_csc=%errorlevel%
::set /a array_len_csc-=1
set i_csc=0
call :forArray "%arr_csc%" "%formerSplitChr_csc%" "array_each_csc" "forarray_csc"
set r_csc=
:forarray_csc
set /a i_csc+=1
set "r_csc=!r_csc!%array_each_csc%"
if %i_csc% LSS %array_len_csc% (
	set "r_csc=!r_csc!!newSplitChr_csc!"
) else if %i_csc% EQU %array_len_csc% (
	goto end_csc
) else (
	goto end2_csc
)
exit /b 0
:end_csc
set %out_csc%=!r_csc!
exit /b 0
:end2_csc
exit /b 0

::FUNC forArray arr splitChr each func
:forArray
set "arr_fa=%~1"
set "splitChr_fa=%~2"
set "each_fa=%~3"
set "func_fa=%~4"
set tt_fa=
set r_fa=0
call :getLength "%arr_fa%"
set chrlen_fa=%errorlevel%
set /a chrlen_fa-=1
for /l %%i in (0,1,%chrlen_fa%) do (
    if "!arr_fa:~%%i,1!" EQU "%splitChr_fa%" (
		set %each_fa%=!tt_fa!
        call :%func_fa%
        set /a r_fa+=1
        set tt_fa=
    ) else (
        set "tt_fa=!tt_fa!!arr_fa:~%%i,1!"
    )
)
set %each_fa%=!tt_fa!
call :%func_fa%
exit /b 0
