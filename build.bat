@ECHO OFF &SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
::
::===========
:: Build script used to kick off the build servers for macOS builds.  This can also be used to build directly
:: in a developer environment.
::
:: ----------------------
:: USAGE
:: ----------------------
:: You can specify one (or both) of "Debug" and/or "Release" to the script to specify building debug or release
:: builds.  Default is to build both debug and release.  You can also specify to build on (or both) of "Win32" 
:: and/or "x64" platforms.  Default is to build both.  All specified configurations will be built for all specified
:: platforms.
::
:: NOTE: Running this script with build server variables set will *FULLY CLEAN* any previous build and all cached
:: intermediates.  To do this on a non-build server build, add the option of "--clean"
::
:: ----------------------
:: ENVIRONMENT VARIABLES
:: ----------------------
:: The following environment variables are honored by the build system.  Most of these should ONLY be set by the
:: official build server:
::
:: MSBUILD=c:\Path\To\MSBuild\Version
::   Default: c:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0
::
:: BUILD_SCHEME="scheme-to-build"
::   Default: unit-tests
::
:: The following variable is used by the macOS script but is documented here for completeness
::
:: XCODE=/Path/To/Xcode.app
::   Default: /Applications/Xcode.app
::
SET ROOT_DIR=%~dp0

IF "%MSBUILD%"=="" SET MSBUILD=c:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0
IF "%PROJ_NAME%"=="" SET PROJ_NAME=__qp_template__
IF "%BUILD_SCHEME%"=="" SET BUILD_SCHEME=unit-tests
SET DOCLEAN=no

SET PLATS=
SET CONFS=
SET CLEANONLY=no
FOR %%a IN (%*) DO (
    IF /I "%%a"=="--clean" SET DOCLEAN=yes
    IF /I "%%a"=="x86_64" SET PLATS=%PLATS% x64
    IF /I "%%a"=="x64" SET PLATS=%PLATS% x64
    IF /I "%%a"=="i386" SET PLATS=%PLATS% Win32
    IF /I "%%a"=="Win32" SET PLATS=%PLATS% Win32
    IF /I "%%a"=="Debug" SET CONFS=%CONFS% Debug
    IF /I "%%a"=="Release" SET CONFS=%CONFS% Release
    IF /I "%%a"=="Clean" (
        SET DOCLEAN=yes
        SET CLEANONLY=yes
    )
)
IF "%CONFS%"=="" SET CONFS= Debug Release
IF "%PLATS%"=="" SET PLATS= x64 Win32

PUSHD "%ROOT_DIR%%PROJ_NAME%_vs2017" || exit /B 1

IF "%DOCLEAN%"=="yes" (
	ECHO ====================
	ECHO Cleaning previous builds...
    rmdir /Q /S "%ROOT_DIR%build" 2>nul
    ECHO.
)

IF "%CLEANONLY%"=="yes" (
    exit /B 0
)

echo ====================
echo Building platforms (%PLATS% ) configurations (%CONFS% ) with %MSBUILD%...
FOR %%P IN (%PLATS%) DO (
    FOR %%T IN (%CONFS%) DO (
        "%MSBUILD%\Bin\MSBuild" %PROJ_NAME%.sln /t:"%BUILD_SCHEME%" ^
                                                /p:Configuration=%%T ^
                                                /p:Platform=%%P ^
                                                /m:%NUMBER_OF_PROCESSORS% || (
            POPD
            exit /B 1
        )
    )
)

POPD
