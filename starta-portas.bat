@echo off
echo Liberando portas do FiveM...

:: Porta principal FiveM
netsh advfirewall firewall add rule name="FiveM TCP 8080" dir=in action=allow protocol=TCP localport=30125
netsh advfirewall firewall add rule name="FiveM UDP 8080" dir=in action=allow protocol=UDP localport=30125

:: Liberando outbound tambem
netsh advfirewall firewall add rule name="FiveM TCP 8080 OUT" dir=out action=allow protocol=TCP localport=30125
netsh advfirewall firewall add rule name="FiveM UDP 8080 OUT" dir=out action=allow protocol=UDP localport=30125

echo Portas liberadas com sucesso!
pause