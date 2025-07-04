:: =============================================
:: Clear Microsoft Teams Login Cache
:: =============================================
:: This script deletes all folders that cache your last logins in Microsoft Teams,
:: ensuring that nobody can access your account without entering a password.
::
:: Requires: Run as the current user
::
@echo off
@RD /S /Q "%LocalAppData%\Packages\MSTeams_8wekyb3d8bbwe"
@RD /S /Q "%LocalAppData%\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
@RD /S /Q "%LocalAppData%\Microsoft\OneAuth"
@RD /S /Q "%LocalAppData%\Microsoft\TokenBroker"
@RD /S /Q "%LocalAppData%\Microsoft\IdentityCache"