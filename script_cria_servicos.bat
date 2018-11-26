@echo off

:again
set location=%~dp0
set /p user= Informe o usuario que ira iniciar os servicos (ex: domain\user):
set /p password= Informe a senha do usuario que ira iniciar os servicos:
set /p auditor= Tem auditor (1-sim / 2-nao):
set /p agendador= Tem agendador (1-sim / 2-nao):
set /p ishom= E servico de homologacao (1-sim / 2-nao):
set displayhom=

if %ishom%==1 (
		set displayhom=_Hom
)


if %auditor%==1 (
	sc create "GovAudService%displayhom%" displayname="GovAudService%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Auditor\AuditorService\AuditorService.exe"
	sc description GovAudService%displayhom% "Governanca Fiscal - Servico de Auditorias"
	sc create "GovAudCalendar%displayhom%" displayname="GovAudCalendar%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Auditor\CalendarService\AuditorCalendarService.exe"
	sc description GovAudCalendar%displayhom% "Governanca Fiscal - Servico de Controle de Calendario"
)
if %agendador%==1 (
	sc create "GovAudAgendador%displayhom%" displayname="GovAudAgendador%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Ferramentas\Agendador\AgendadorService.exe"
	sc description GovAudAgendador%displayhom% "Governanca Fiscal - Servico de Auditor Diario"
)
sc create "GovDFeCopy%displayhom%" displayname="GovDFeCopy%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Receiver\QuiriusCopyService\QuiriusCopyService.exe"
sc description GovDFeCopy%displayhom% "Governanca Fiscal - Servico de Copia entre ferramentas"
sc create "GovDFeImport%displayhom%" displayname="GovDFeImport%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Receiver\QuiriusImportService\QuiriusImportService.exe"
sc description GovDFeImport%displayhom% "Governanca Fiscal - Servico de Importacao de documentos"
sc create "GovDFeNfeUtil%displayhom%" displayname="GovDFeNfeUtil%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Receiver\QuiriusNfeUtilService\QuiriusNfeUtilService.exe"
sc description GovDFeNfeUtil%displayhom% "Governanca Fiscal - Servico Monitoramenta da SEFAZ"
sc create "GovDFeNfse%displayhom%" displayname="GovDFeNfse%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Receiver\QuiriusNfseService\QuiriusNfseService.exe"
sc description GovDFeNfse%displayhom% "Governanca Fiscal - Servico de Controle NFSe"
sc create "GovDFeVerify%displayhom%" displayname="GovDFeVerify%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Receiver\QuiriusVerifyService\QuiriusVerify.exe"
sc description GovDFeVerify%displayhom% "Governanca Fiscal - Servico Verificacao de Documentos"
sc create "GovDFeEmail%displayhom%" displayname="GovDFeEmail%displayhom%" type=own error=severe start=auto obj="%user%" password=%password% binpath= "%location%Servicos\Receiver\QuiriusWinService\QuiriusWinService.exe"
sc description GovDFeEmail%displayhom% "Governanca Fiscal - Servico Leitura de Emails"

pause
