@echo off

set JDK_HOME=%userprofile%\.gradle\jdks

setx /m JAVA_HOME %JDK_HOME%\ibm_semeru-17-x64-openj9-windows
setx /m JAVA_HOME_8 %JDK_HOME%\ibm_semeru-8-x64-openj9-windows
