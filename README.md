# NetMonitor
## What it does
PowerShell script that runs a ping to a host and stores the result in an SQLite database. Can be run periodically, e.g. using Windows Task Scheduler.

`powershell -ExecutionPolicy Bypass -Command C:\Path\to\NetMonitor\NetMonitor.ps1`

I wrote this to check how often my internet connection is down.

## Parameters
.\NetMonitor.ps1 -Hostname `some.host` -Database `C:\Full\Path\to\SQLite.db`

## Requirements
* [PowerShell](https://github.com/PowerShell/PowerShell)
* [PSSQLite](https://github.com/RamblingCookieMonster/PSSQLite)
