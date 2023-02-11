@echo off

rem link app dir

echo.
set /p newApp=请选择 gradle 解压路径：
::set newApp=%~dp0data\wrapper\dists\gradle-6.8.3-bin\7ykxq50lst7lb7wx1nijpicxn\gradle-6.8.3

rem link data dir
set gradle_data=%~dp0data
set gradle_data_cache=F:\data\gradle
mkdir %gradle_data_cache% >nul 2>&1

call link-dir "%newApp%" "%gradle_data_cache%\app"
call link-dir "%gradle_data_cache%" "%userprofile%\.gradle"
call link-dir "%gradle_data%\jdks" "%gradle_data_cache%\jdks"
call link-dir "%gradle_data%\wrapper" "%gradle_data_cache%\wrapper"

rem link file
call link-file "%gradle_data%" "%gradle_data_cache%" "gradle.properties"

pause >nul
