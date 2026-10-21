@echo off
rem prlminer - Pearl (PRL). Fill in WALLET, WORKER and POOL below, then double-click this file.
rem POOL needs its scheme, e.g. stratum+ssl://prl-eu.kryptex.network:8048
set WALLET=YOUR_WALLET
set WORKER=worker
set POOL=YOUR_POOL

:loop
"%~dp0prlminer.exe" -o %POOL% -u %WALLET% -w %WORKER%
rem A clean exit (code 0) is a deliberate stop (Ctrl-C): leave it stopped. Anything else is a
rem crash, and the launcher brings the miner back.
if not errorlevel 1 goto end
echo prlminer exited, restarting in 10 s...
timeout /t 10 /nobreak >nul
goto loop

:end
