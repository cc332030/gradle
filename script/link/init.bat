@echo off

echo.
set /p newApp=请选择 gradle 解压路径：

setx /M GRADLE_HOME "%userprofile%\.gradle\app"

set gradle_data=%~dp0data

call link-dir "%newApp%" "%gradle_data%\app"
call link-dir "%gradle_data%" "%userprofile%\.gradle"

pause >nul
