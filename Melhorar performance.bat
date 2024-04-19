::Criar um ponto de restauração.

Enable-ComputerRestore -Drive C:\  ::Hablita a função de criação de pontos de restauração.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v RPLimitPercent /t REG_DWORD /d 7 /f ::Defini com 7% do disco pode ser usado para criar ponto de restauração.
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command Checkpoint-Computer -Description "Antes_Melhoramento_de_Performance"  ::Cria o ponto de restauração.

::Modo aprimorado de energia.
for /f "delims=" %%a in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do set resposta=%%a
:: Essa linha duplica um esquema de energia e nomea como "desemepenho maximo", também armazena a resposta que o comando gera dentro da variavel "resposta".

set intervalo=%resposta:~28,36%
::Extrai um valor de de dentro da variavel resposta.

powercfg /s %intervalo%
::Esse defini o GUI armazenado na valriavel "intervalo" como padrão.

:: Limpa erros do Windows.
@echo off
sfc /scannow
dism /online /cleanup-image /CheckHealth
dism /online /cleanup-image /restorehealth


:: Utilitario de limpeza de disco.
::Adiciona as chaves necessárias no registro do Windows para executar o comando sagerun.

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache" /v StateFlags1997 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\D3D Shader Cache" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Delivery Optimization Files" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Diagnostic Data Viewer database files" /v StateFlags1997 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Language Pack" /v StateFlags1997 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v StateFlags1997 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags1997 /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions" /v StateFlags1997 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\StateFlags1997" /v StateFlags1997 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags1997 /t REG_DWORD /d 0 /f

cleanmgr /sagerun:1997 

::https://learn.microsoft.com/pt-br/windows-server/administration/windows-commands/cleanmgr

::Realize limpeza de configurações de conexão.

ipconfig /release
ipconfig /renew
ipconfig /flushdns
netsh winsock reset

::Desabilitar processos desnecessários.
sc config AdobeARMservice start=disabled
sc config GameInputSvc start=disabled
sc config XblAuthManager start=disabled
sc config XboxGipSvc start=disabled

::Edita alguns registros

::Disable Diagnostics Telemetry Services

::Disable Connected User Experiences and Telemetry
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" /v Start /t REG_DWORD /d 4 /f

::Disable dmwappushservice
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v Start /t REG_DWORD /d 4 /f

::Disable Diagnostic Execution Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\diagsvc" /v Start /t REG_DWORD /d 4 /f

::Disable Diagnostic Policy Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DPS" /v Start /t REG_DWORD /d 4 /f

::Disable Microsoft (R) Diagnostics Hub Standard Collector Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v Start /t REG_DWORD /d 4 /f

::Disable Diagnostic Service Host
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdiServiceHost" /v Start /t REG_DWORD /d 4 /f

::Disable Diagnostic System Host
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdiSystemHost" /v Start /t REG_DWORD /d 4 /f

::Disable Windows Biometric Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v Start /t REG_DWORD /d 4 /f

::Disable Windows Font Cache Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v Start /t REG_DWORD /d 4 /f

::Disable Windows Image Acquisition (WIA)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\stisvc" /v Start /t REG_DWORD /d 4 /f

::Disable Windows Error Reporting Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WerSvc" /v Start /t REG_DWORD /d 4 /f

::Disable Program Compatibility Assistant Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PcaSvc" /v Start /t REG_DWORD /d 4 /f

::Disable Windows Event Collector
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wecsvc" /v Start /t REG_DWORD /d 4 /f


::OPTIONAL Disable Download Maps Manager
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MapsBroker" /v Start /t REG_DWORD /d 4 /f

::Disable Xbox Live Game Save
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XblGameSave" /v Start /t REG_DWORD /d 4 /f

::Disable Xbox Live Networking Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v Start /t REG_DWORD /d 4 /f

::Disable Xbox Accessory Management Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v Start /t REG_DWORD /d 4 /f

::Disable Xbox Live Auth Manager
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v Start /t REG_DWORD /d 4 /f

::Personalization Tab - Disable Transparency
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f

::Disable Game Bar & Game DVR
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v Value /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f

::Enable Game Mode
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f

::Disable Variable Refresh Rate
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalSettings /t REG_SZ /d "VRROptimizeEnable=0;" /f

::Ease of Access Tab ( Disable Ease Of Access Features )
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\MouseKeys" /v Flags /t REG_SZ /d "0" /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "0" /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d "0" /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d "0" /f

::General Tab
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f

::Speech Tab
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v HasAccepted /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f

::Diagnostics & Feedback Tab
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v ShowedToastAtLevel /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" /v EnableEventTranscript /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" /v PeriodInNanoSeconds /t REG_DWORD /d 0 /f

::Activity History Tab
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f

::App Permissions Tab
::Disable Notifications - Location - App Diagnostics - Account Info Access
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v Value /t REG_SZ /d "Deny" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d "Deny" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v Value /t REG_SZ /d "Deny" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v Value /t REG_SZ /d "Deny" /f

::Disable Let Unnecessary Apps Run In The Background
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f


::Exclui arquivos temporarios.

echo Batch File By Lucas Vassoler
RD /S /Q %temp%
MKDIR %temp%
takeown /f "%temp%" /r /d y
takeown /f "C:\Windows\Temp" /r /d y
RD /S /Q C:\Windows\Temp
MKDIR C:\Windows\Temp
takeown /f "C:\Windows\Temp" /r /d y
takeown /f %temp% /r /d y


