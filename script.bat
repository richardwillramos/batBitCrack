@echo off
setlocal enabledelayedexpansion

rem Caminho para o cuBitCrack.exe
set exe=cuBitCrack.exe

rem Endereço Bitcoin alvo
set address=1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9

rem Arquivo de saída para chaves encontradas
set output=achado.txt

rem Intervalo de tempo em segundos (8 minutos)
set /a timeLimit=480

rem Loop principal
:loop

rem Gera um novo range aleatório entre 40000000000000000 e 7ffffffffffffffff
for /f %%a in ('powershell -command "[convert]::toString((Get-Random -minimum 0x4000000000000000 -maximum 0x7FFFFFFFFFFFFFFF),16)"') do set start_key=%%a
for /f %%b in ('powershell -command "[convert]::toString((Get-Random -minimum 0x4000000000000000 -maximum 0x7FFFFFFFFFFFFFFF),16)"') do set end_key=%%b

rem Garante que o end_key é maior que o start_key
if !end_key! lss !start_key! (
    set temp=!start_key!
    set start_key=!end_key!
    set end_key=!temp!
)

rem Nome do arquivo de progresso
set continue_file=progresso/ultima_!start_key!_!end_key!.txt

rem Executa o cuBitCrack com o intervalo gerado
start "" /b %exe% -b 52 -p 512 -t 512 --keyspace !start_key!:!end_key! --continue !continue_file! -o %output% %address%

rem Aguarda por 8 minutos (480 segundos) ou até 5 bilhões de chaves geradas
timeout /t %timeLimit% /nobreak

rem Para o processo
taskkill /im cuBitCrack.exe /f

rem Volta para o loop para gerar um novo range
goto loop
