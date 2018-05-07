@Echo off
::Change this accordingly to your external storage structure
::My external hdd (z:) has a directory called "work", in which all sort of portable apps sit
::such as emacs, php, conemu, eclipse and so forth
set "SubstDir=z:\work"
::Which will get subst'ed to a drive of your choice like w:
set "SubstDrive=W:"
::Find the bitness of the (Windows) OS and store it in env var AddressWidth
for /f "skip=1 delims=" %%x in ('wmic cpu get addresswidth') do if not defined AddressWidth set AddressWidth=%%x
::Get the content of dev.env file and set Development Environment accordingly
::Unless Command Line Parameter is given, this will override the devenv variable
if [%1]==[] (
	set /p DevEnv=<"%~dp0dev.env"
	) else (
	set DevEnv=%1
	)
::Backup old paths so we're not overwriting anything further down the line, hopefully avoiding reboots
set "_oldPath=%path%"
:: Either the user has selected one of 
::	[vs32] VisualStudio 32 bit environment
::	[vs64] VisualStudio 64 bit environment
::	[php56] PHP 5.6 environment
::	[php72] PHP 7.2 environment
::	[bb] Barebones environment
:: or the user has NOT selected anything (no dev.env file)
:: and gets the Barebones environment
if /I %DevEnv%==vs32 (
	@Echo Creating 32bit work environment in w: with VisualStudio 2017 support
	goto :VisualStudio32
) 
if /I %DevEnv%==vs64 (
	@Echo Creating 64bit work environment in w: with VisualStudio 2017 support
	goto :VisualStudio64
)
if /I %DevEnv%==php56 (
	@Echo Creating PHP 5.6 work environment in %SubstDrive%
	goto :php56
)
if /I %DevEnv%==php72 (
	@Echo Creating PHP 7.2 work environment in %SubstDrive%
	goto :php72
)
set "_bb="
if /I %DevEnv%==bb set _bb=1
if %DevEnv%==[] set _bb=1
if not defined %DevEnv% set _bb=1
if %_bb% equ 1 (
	@Echo Creating BareBones work environment in %SubstDrive%
	SET DevEnv=BareBones
	set "_bb="
	goto :continue
)
:VisualStudio32
if %AddressWidth%==64 (
  @Echo Initializing Visual Studio environment on 64bit OS for 32bit compilers
  call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
  goto :continue
) else (
  @Echo Initializing Visual Studio environment on 32bit OS for 32bit compilers
  call "C:\Program Files\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
  goto :continue
)
:VisualStudio64
if %AddressWidth%==64 (
  @Echo Initializing Visual Studio environment on 64bit OS with 64bit compilers
  call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
  goto :continue
) else (
  @Echo Initializing Visual Studio environment on 32bit OS with 64bit compilers
  call "C:\Program Files\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
  goto :continue
)
:php56
set PATH=%SubstDrive%\php\56;%path%
goto :continue
:php72
set PATH=%SubstDrive%\php\72;%path%
goto :continue
:continue
@Echo Setting paths
subst %SubstDrive% %SubstDir%
set PATH=%SubstDrive%\misc;%path%
%SubstDrive%
Echo:%DevEnv% Development environment ready. Type 'quit' to CLEANLY close down the environment