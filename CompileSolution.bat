@ECHO OFF

SET MSBuildCmd_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsMSBuildCmd.bat"

SET DOTNET_DIR=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
SET MSBUILD=%DOTNET_DIR%msbuild.exe
SET DOTNET_PLATFORM="Any CPU"
SET CPP_PLATFORM=x86
SET MINARY_SOLUTION_FILE=Minary\Minary.sln
SET PLUGINS_SOLUTION_FILE=Plugins\Plugins.sln
SET TOOLS_SOLUTION_FILE=Tools\Tools.sln
SET LIBS_SOLUTION_FILE=Libs\Libs.sln
SET ATTACKSERVICES_SOLUTION_FILE=AttackServices\AttackServices.sln
SET ROOT_DIR="%cd%"
SET SOLUTIONCONFIG=%1

IF "%~1" == "" GOTO :EXITUSAGE

CLS

IF NOT EXIST %MSBuildCmd_PATH% (
  ECHO[
  ECHO[
  ECHO OOOPS!!  You must set the variable MSBuildCmd_Path to the right location!!
  ECHO          Open this file in a text editor and customize the variable manually.
  ECHO[
  ECHO[
  GOTO :END
)

ECHO Load MSBuild command environment
CALL %MSBuildCmd_PATH% 
cd %ROOT_DIR%

ECHO Check .NET directory : %DOTNET_DIR%
IF NOT EXIST "%DOTNET_DIR%" (
  ECHO The .Net directory %DOTNET_DIR% does not exist!
  ECHO You need to customize to make this script work properly.
  GOTO :ERROR
)

IF not exist "%MINARY_SOLUTION_FILE%" (
  ECHO The file %MINARY_SOLUTION_FILE% does not exist!
  GOTO :ERROR
)


ECHO Start building Tools solution
ECHO msbuild %TOOLS_SOLUTION_FILE% /t:Clean,Rebuild /p:Configuration=%SOLUTIONCONFIG% /property:Platform=%CPP_PLATFORM% /p:WarningLevel=0 /verbosity:m
msbuild %TOOLS_SOLUTION_FILE% /t:Clean,Rebuild /p:Configuration=%SOLUTIONCONFIG% /property:Platform=%CPP_PLATFORM% /p:WarningLevel=0 /verbosity:m
IF %ERRORLEVEL% NEQ 0 GOTO :ERROR


ECHO Start building Libs solution
msbuild %LIBS_SOLUTION_FILE% /t:Clean,Rebuild /p:Configuration=%SOLUTIONCONFIG% /property:Platform=%CPP_PLATFORM% /p:WarningLevel=0 /verbosity:m
IF %ERRORLEVEL% NEQ 0 GOTO :ERROR




ECHO Start building AttackServices solution
msbuild %ATTACKSERVICES_SOLUTION_FILE% /t:Clean,Rebuild /p:Configuration=%SOLUTIONCONFIG% /property:Platform=%DOTNET_PLATFORM% /p:WarningLevel=0 /verbosity:m
IF %ERRORLEVEL% NEQ 0 GOTO :ERROR


ECHO Start building Minary solution
msbuild %MINARY_SOLUTION_FILE% /t:Clean,Rebuild /p:Configuration=%SOLUTIONCONFIG% /property:Platform=%DOTNET_PLATFORM% /p:WarningLevel=0 /verbosity:m
IF %ERRORLEVEL% NEQ 0 GOTO :ERROR


ECHO Start building Plugins solution
msbuild %PLUGINS_SOLUTION_FILE% /t:Clean,Rebuild /p:Configuration=%SOLUTIONCONFIG% /property:Platform=%DOTNET_PLATFORM% /p:WarningLevel=0 /verbosity:m
IF %ERRORLEVEL% NEQ 0 GOTO :ERROR


ECHO Build finished successfully !!
GOTO :END


:ERROR
ECHO[
ECHO[
ECHO[
ECHO OOPS!! The last command failed!
ECHO[
ECHO[
EXIT /B 1


:EXITUSAGE
ECHO[
ECHO[
ECHO[
ECHO Usage: CompileSolution.bat DEBUG/RELEASE
ECHO[
ECHO[
EXIT /B 1

:END

