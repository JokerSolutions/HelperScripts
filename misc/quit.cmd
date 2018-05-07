:: This is quite an ugly script, but I wanted something that would delete all traces of the new paths
:: but since it's normally called from the working directory (a subst really) it would stop working the instant the subst drive got deleted,
:: So I created this workaround that clones the script to a local temp directory runs it from there and then deletes itself as the penultimate step.
@Echo on
:start_script
:: Check if we are running from temp or not.
if "%~dp0"=="%tmp%\" (
	goto :run_me
) else (
	goto :clone_me
)
:clone_me
@Echo Cloning script ...
copy "%~f0" "%tmp%\%~nx0"
goto :call_clone
:call_clone
@Echo Starting cloned script
call "%tmp%\%~nx0"
goto :done
:run_me
@Echo Closing down environment
if /I %DevEnv%==VisualStudio32 call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" -clean_env
if /I %DevEnv%==VisualStudio64 call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" -clean_env
pushd %tmp%
subst %SubstDrive% /D
popd
:: Now cleanup paths
set PATH=%_oldPath%
set "_oldPath="
set "SubstDrive="
set "SubstDir="
set "DevEnv="
@Echo Deleting clone and exiting ...
del %~f0&exit
goto :done
:error
REM We should add a link here
echo [ERROR:~nx0] Error in script usage.
pause
goto :start_script
:done
@Echo We should NEVER reach this!!
pushd
exit /B