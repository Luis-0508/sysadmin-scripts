:: clears all folders that cache your last logins in ms teams so that nobody can login to your account without a password
@RD /S /Q "%LocalAppData%\Packages\MSTeams_8wekyb3d8bbwe"
@RD /S /Q "%LocalAppData%\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
@RD /S /Q "%LocalAppData%\Microsoft\OneAuth"
@RD /S /Q "%LocalAppData%\Microsoft\TokenBroker"
@RD /S /Q "%LocalAppData%\Microsoft\IdentityCache"