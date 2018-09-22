:loop
@echo Clearing Server Cache Files
timeout /t 3
cd C:\Users\Administrator\Documents\FiveM_Server
rd /s /q cache
start C:\Users\Administrator\Documents\FiveM_Server\run.cmd +exec server_esx.cfg