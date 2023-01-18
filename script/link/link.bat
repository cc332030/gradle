@echo off
chcp 65001 > nul

rem link app dir

echo.
set /p newApp=请选择 gradle 解压路径：
::set newApp=%~dp0data\wrapper\dists\gradle-6.8.3-bin\7ykxq50lst7lb7wx1nijpicxn\gradle-6.8.3

set target="%~dp0data\app"
set source="%newApp%"
call %~dp0data\link-dir-prompt.bat

rem link data dir
set gradle_data=%~dp0data
set gradle_data_cache=F:\build\gradle
mkdir %gradle_data_cache%

set target="%userprofile%\.gradle"
set source="%gradle_data_cache%"
call %~dp0data\link-dir-prompt.bat

set target="%gradle_data_cache%\jdks"
set source="%gradle_data%\jdks"
call %~dp0data\link-dir-prompt.bat

set target="%gradle_data_cache%\wrapper"
set source="%gradle_data%\wrapper"
call %~dp0data\link-dir-prompt.bat


rem link file
set target="%gradle_data_cache%\"
set source="%gradle_data%\"

set targetFileName="gradle.properties"
call %~dp0data\link-file.bat

pause >nul
