:: =============================================
:: Full Microsoft Teams Cache Clear
:: =============================================
:: This script completely clears all Microsoft Teams cache and login data to fix lag,
:: crashes, and stubborn issues that Microsoft does not provide an option for.
::
:: Requires: Run as the current user
::

@RD /S /Q "%LocalAppData%\Packages\MSTeams_8wekyb3d8bbwe"
@RD /S /Q "%LocalAppData%\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
@RD /S /Q "%LocalAppData%\Microsoft\OneAuth"
@RD /S /Q "%LocalAppData%\Microsoft\TokenBroker"
@RD /S /Q "%LocalAppData%\Microsoft\IdentityCache"
@RD /S /Q "%appdata%\Microsoft\teams\application cache\cache"
@RD /S /Q "%appdata%\Microsoft\teams\blob_storage"
@RD /S /Q "%appdata%\Microsoft\teams\databases"
@RD /S /Q "%appdata%\Microsoft\teams\GPUcache"
@RD /S /Q "%appdata%\Microsoft\teams\IndexedDB"
@RD /S /Q "%appdata%\Microsoft\teams\Local Storage"
@RD /S /Q "%appdata%\Microsoft\teams\tmp"
@RD /S /Q "%appdata%\Microsoft\teams\Cache"