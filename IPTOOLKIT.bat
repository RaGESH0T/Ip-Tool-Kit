@echo off
REM ============================================================
REM   IPTOOLKIT v2.0
REM   Network Recon & Information Toolkit
REM   ~by RaGESH0T
REM ============================================================
setlocal EnableExtensions
title IPTOOLKIT  ~by RaGESH0T
mode con: cols=82 lines=36
chcp 65001 >nul
color 0A

rem --- Run from script folder, then into \files if present ---
cd /d "%~dp0"
if exist "files" (
    cd /d "files"
) else (
    echo.
    echo   [!] "files" folder not found next to this script.
    echo       Some tools ^(PortScanner.exe, arpspoof.exe, etc.^)
    echo       may not be available.
    echo.
    ping -n 3 127.0.0.1 >nul
)

:menu
cls
call :banner
echo.
echo   ==============================================================
echo     PUBLIC IP TOOLS                LOCAL IP TOOLS
echo     ---------------                --------------
echo       [1] Geolocate                  [5] Trace MAC Address
echo       [2] Trace DNS                  [6] Port Scan
echo       [3] Port Scan                  [7] ARP Spoof ^(DOS^)
echo       [4] DDOS                       [8] RPC Dump
echo   ==============================================================
echo       [9] About / Credits            [0] Exit
echo   ==============================================================
echo.
set "input="
set /p "input=    ^> Select an option: "

if /I "%input%"=="1" goto geolocate
if /I "%input%"=="2" goto tracedns
if /I "%input%"=="3" goto portscan
if /I "%input%"=="4" goto ddos
if /I "%input%"=="5" goto macaddr
if /I "%input%"=="6" goto portscan
if /I "%input%"=="7" goto arpspoof
if /I "%input%"=="8" goto rpcdump
if /I "%input%"=="9" goto about
if /I "%input%"=="0" goto quit
echo.
echo   [!] Invalid option - try again.
ping -n 3 127.0.0.1 >nul
goto menu

REM ============================================================
REM  TOOLS
REM ============================================================

:geolocate
cls
call :banner
echo.
set "ip="
set /p "ip=    [?] Enter IP Address: "
if not defined ip goto menu
cls
call :banner
echo.
echo   [*] Looking up %ip% ...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { $r = Invoke-RestMethod 'https://ipinfo.io/%ip%/json' -TimeoutSec 10; '   IP:        ' + $r.ip; '   Hostname:  ' + $r.hostname; '   ISP:       ' + $r.org; '   City:      ' + $r.city; '   State:     ' + $r.region; '   Country:   ' + $r.country; '   Postal:    ' + $r.postal; '   Location:  ' + $r.loc; '   Timezone:  ' + $r.timezone } catch { '   [!] Lookup failed: ' + $_.Exception.Message }"
echo.
pause
goto menu

:tracedns
cls
call :banner
echo.
set "ip="
set /p "ip=    [?] Enter IP Address or Domain: "
if not defined ip goto menu
cls
call :banner
echo.
echo   [*] Resolving %ip% ...
echo.
set "dns="
for /f "tokens=2 delims=: " %%a in ('nslookup %ip% 2^>nul ^| findstr /i /c:"Name:"') do if not defined dns set "dns=%%a"
if defined dns (
    echo   Domain Name: %dns%
) else (
    echo   [!] No domain name found for %ip%.
)
echo.
pause
goto menu

:portscan
cls
call :banner
echo.
set "ip="
set /p "ip=    [?] Target IP: "
if not defined ip goto menu
set "ports="
set /p "ports=    [?] Ports ^(e.g. 21,22,23^): "
if not defined ports goto menu
if not exist "PortScanner.exe" (
    echo.
    echo   [!] PortScanner.exe not found in "%CD%".
    echo.
    pause
    goto menu
)
cls
call :banner
echo.
echo   [*] Scanning %ip% on ports %ports% ...
echo.
if exist "portscan.txt" del "portscan.txt" >nul 2>&1
start "PortScan" cmd /c "mode 55,15 & title Port Scanner & PortScanner.exe hosts=%ip% ports=%ports% >> portscan.txt"
ping -n 7 127.0.0.1 >nul
taskkill /im PortScanner.exe /f >nul 2>&1
echo   ----- Scan Results -----
if exist "portscan.txt" (
    type "portscan.txt"
) else (
    echo   [!] No results file was produced.
)
echo   ------------------------
echo.
pause
if exist "portscan.txt" del "portscan.txt" >nul 2>&1
goto menu

:macaddr
cls
call :banner
echo.
set "ip="
set /p "ip=    [?] Enter IP Address: "
if not defined ip goto menu
cls
call :banner
echo.
echo   [*] Resolving MAC address for %ip% ...
ping -n 1 -w 1000 %ip% >nul 2>&1
set "macaddr="
for /f "tokens=2 delims= " %%a in ('arp -a ^| findstr /c:"%ip% "') do if not defined macaddr set "macaddr=%%a"
if not defined macaddr (
    echo.
    echo   [!] Could not find a MAC address for %ip%.
    echo.
    pause
    goto menu
)
set "upper="
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "'%macaddr%'.ToUpper()"`) do set "upper=%%~I"
echo.
echo   MAC Address: %upper%
echo.
pause
goto menu

:arpspoof
cls
call :banner
echo.
echo   [!] WARNING: ARP spoofing is for authorized testing only.
echo.
set "ip="
set /p "ip=    [?] Target IP: "
if not defined ip goto menu
if not exist "arpspoof.exe" (
    echo.
    echo   [!] arpspoof.exe not found in "%CD%".
    echo.
    pause
    goto menu
)
start "ARP Spoof" cmd /c "mode 87,10 & title Spoofing %ip%... & echo. & arpspoof.exe %ip% & pause"
goto menu

:rpcdump
cls
call :banner
echo.
set "ip="
set /p "ip=    [?] Target IP: "
if not defined ip goto menu
cls
call :banner
echo.
echo   [*] Running RPC dump against %ip% ...
echo.
where rpcdump.exe >nul 2>&1
if errorlevel 1 (
    echo   [!] rpcdump.exe was not found in PATH or the current folder.
) else (
    rpcdump %ip%
)
echo.
pause
goto menu

:ddos
cls
call :banner
echo.
echo   ==============================================================
echo     STRESSER / DDOS LINKS
echo   ==============================================================
echo       [1] https://freestresser.so/
echo       [2] https://hardstresser.com/
echo       [3] https://stresser.net/
echo       [4] https://str3ssed.co/
echo       [5] https://projectdeltastress.com/
echo       [6] Back to main menu
echo   ==============================================================
echo.
set "ddosinput="
set /p "ddosinput=    ^> Select: "
if /I "%ddosinput%"=="1" (start "" "https://freestresser.so/" & goto menu)
if /I "%ddosinput%"=="2" (start "" "https://hardstresser.com/" & goto menu)
if /I "%ddosinput%"=="3" (start "" "https://stresser.net/" & goto menu)
if /I "%ddosinput%"=="4" (start "" "https://str3ssed.co/" & goto menu)
if /I "%ddosinput%"=="5" (start "" "https://projectdeltastress.com/" & goto menu)
if /I "%ddosinput%"=="6" goto menu
echo.
echo   [!] Invalid option - try again.
ping -n 3 127.0.0.1 >nul
goto ddos

:about
cls
call :banner
echo.
echo   IPTOOLKIT v2.0
echo   A batch-based network information ^& recon toolkit.
echo.
echo   Credits:  ~by RaGESH0T
echo.
echo   Disclaimer:
echo     Use this tool only on networks and systems you own
echo     or have explicit written permission to test.
echo.
pause
goto menu

:quit
cls
call :banner
echo.
echo   Thanks for using IPTOOLKIT  ~by RaGESH0T
echo.
ping -n 3 127.0.0.1 >nul
endlocal
exit /b 0

REM ============================================================
REM  BANNER  (uses banner.txt if present, otherwise built-in)
REM ============================================================
:banner
echo.
echo   ==============================================================
if not exist "banner.txt" goto banner_builtin
type "banner.txt"
goto banner_credit
:banner_builtin
echo █▀▀▀█ █▀▀▀▀▀▀▀▀▀▀  █▀▀▀▀▀▀▀▀▀▀▀█ █▀▀▀▀▀▀▀▀▀▀  █▀▀▀▀▀▀▀▀▀▀  █▀▀▀         █▀▀▀█  █▀▀▀  █▀▀▀█ █▀▀▀▀▀▀▀▀▀▀▀█
echo █▓▒▓█ █▓▒▓▄▄▄▄▓▒▓  █▓▓▓▓▓▒▓▓▓▓▓█ █▓▒▓▄▄▄▄▓▒▓  █▓▒▓▄▄▄▄▓▒▓  █▓▒▓         █▓▒▓█  █▓▒▓  █▓▒▓█ █▓▓▓▓▓▒▓▓▓▓▓█
echo █▄▄▄█ █▒░▒█  █▒░▒  ▀▀▀▀█▒░▒ ▀▀▀▀ █▒░▒█  █▒░▒  █▒░▒█  █▒░▒  █▒░▒         █▒░▒█ ▐▌▒░▒  █▄▄▄█ ▀▀▀▀█▒░▒ ▀▀▀▀
echo       █░ ░▀▀▀▀░ ░      █░ ░      █░ ░█  █░ ░  █░ ░█  █░ ░  █░ ░         █░ ░▀▀▀░ ░ ▀           █░ ░     
echo █▀▀▀█ █▄▄▄▄▄▄▄▄▄▄      █         █▄▄▄█  █     █▄▄▄█  █     █▄▄▄         █▄▄▄▄▄▄  ▐▌  █▀▀▀█     █        
echo █░ ░                   █░ ░             █░ ░         █░ ░                     █░ ░ ▄ █░ ░      █░ ░     
echo █▒░▒  █▀▀▀█            █▒░▒      █▀▀▀▀▀▀▀▒░▒  █▀▀▀▀▀▀▀▒░▒  █▀▀▀▀▀▀▀▀▀▀  █▀▀▀█ ▐▌▒░▒  █▒░▒      █▒░▒     
echo █▓▒▓█ █▓▒▓█            █▓▒▓      █▓▓▓▒▓▓▓▓▒▓  █▓▓▓▒▓▓▓▓▒▓  █▓▓▓▒▓▓▓▓▒▓  █▓▒▓█  █▓▒▓  █▓▒▓█     █▓▒▓     
echo █▄▄▄█ █▄▄▄█            █▄▄▄      █▄▄▄▄▄▄▄▄▄▄  █▄▄▄▄▄▄▄▄▄▄  █▄▄▄▄▄▄▄▄▄▄  █▄▄▄█  █▄▄▄  █▄▄▄█     █▄▄▄
echo.
echo            I P T O O L K I T   v2.0
echo         Network Recon ^& Info Toolkit
:banner_credit
echo                    ~by RaGESH0T
echo   ==============================================================
goto :eof