@echo off

set location=%~dp0
set /p ishom= E servico de homologacao(1-sim / 2-nao):
set port=600
set hostname=%COMPUTERNAME%

if %ishom%==1 (
		set port=700
)
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusCopyService" --fileMask "QuiriusCopyService.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\GIT\SUITE-FISCAL\Governanca\Servicos\Receiver\QuiriusCopy\QuiriusCopyService\Admin" --replace "protectedKeyFilename=""%location%Servicos\Receiver\QuiriusCopyService\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusImportService" --fileMask "QuiriusImportService.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\GIT\SUITE-FISCAL\Governanca\Servicos\Receiver\QuiriusImportService\Admin" --replace "protectedKeyFilename=""%location%Servicos\Receiver\QuiriusImportService\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusNfeUtilService" --fileMask "QuiriusNfeUtilService.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\GIT\SUITE-FISCAL\Governanca\Servicos\Receiver\QuiriusNfeUtilService\Admin" --replace "protectedKeyFilename=""%location%Servicos\Receiver\QuiriusNfeUtilService\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusNfseService" --fileMask "QuiriusNfseService.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\GIT\SUITE-FISCAL\Governanca\Servicos\Receiver\QuiriusNfse\QuiriusNfseService\Admin" --replace "protectedKeyFilename=""%location%Servicos\Receiver\QuiriusNfseService\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusNfseService" --fileMask "QuiriusNfseService.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "maxBufferSize=""65536" --replace "maxBufferSize=""6553600" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusNfseService" --fileMask "QuiriusNfseService.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "maxReceivedMessageSize=""65536" --replace "maxReceivedMessageSize=""6553600" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusSyncService" --fileMask "QuiriusSync.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\GIT\SUITE-FISCAL\Governanca\Servicos\Receiver\QuiriusSync\Admin" --replace "protectedKeyFilename=""%location%Servicos\Receiver\QuiriusSyncService\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusVerifyService" --fileMask "QuiriusVerify.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\GIT\SUITE-FISCAL\Governanca\Servicos\Receiver\QuiriusVerify\Admin" --replace "protectedKeyFilename=""%location%Servicos\Receiver\QuiriusVerifyService\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Servicos\Receiver\QuiriusWinService" --fileMask "QuiriusWinService.exe.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\GIT\SUITE-FISCAL\Governanca\Servicos\Receiver\QuiriusWinService\Admin" --replace "protectedKeyFilename=""%location%Servicos\Receiver\QuiriusWinService\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Aplicacao" --fileMask "web.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "protectedKeyFilename=""C:\git\SUITE-FISCAL\Governanca\Aplicacao\Governanca\Admin" --replace "protectedKeyFilename=""%location%Aplicacao\Admin" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Aplicacao" --fileMask "web.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "C:\inetpub\wwwroot\Auditor\Application" --replace "%location%Aplicacao" && echo --------OK-------- || echo Failed
"%location%fnr.exe" --cl --dir "%location%Aplicacao" --fileMask "web.config" --excludeFileMask "*.dll, *.exe" --includeSubDirectories --find "key=""SiteUrl"" value=""http://localhost:25800/""" --replace "key=""SiteUrl"" value=""http://%hostname%:%port%/""" && echo --------OK-------- || echo Failed

pause
