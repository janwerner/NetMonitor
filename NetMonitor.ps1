# Parameters
param(
[string]$Hostname = "8.8.8.8"
)

# Set $PSScriptRoot for PS < 3.0
$PSScriptRoot = split-path -parent $MyInvocation.MyCommand.Definition

echo $PSScriptRoot

# Check for PSSQlite module
if (-not (Get-Module -Name "PSSQLite")) {
    Write-Host -ForegroundColor Red "Module 'PSSQLite' is missing!"; Exit
}

# Import PSSQlite module
Import-Module PSSQLite

Write-Host -NoNewLine -ForegroundColor Cyan "`nTesting network connection and calculating round trip time ... "

$Result = Test-NetConnection -ComputerName "$Hostname" `
    | select @{n = 'TimeStamp'; e = {([DateTimeOffset](Get-Date)).ToUnixTimeSeconds()}}, `
    RemoteAddress, `
    InterfaceAlias, `
    PingSucceeded, `
    @{n = 'RoundTripTime'; e = {$_.PingReplyDetails.RoundTripTime.ToString() + " ms"}} `

$DateTime = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Result.TimeStamp))

Write-Host -ForegroundColor Cyan "done."

Write-Host -ForegroundColor Green -NoNewLine "`nTimestamp: "; Write-Host $DateTime;
Write-Host -ForegroundColor Green -NoNewLine "Interface: "; Write-Host $Result.InterfaceAlias
Write-Host -ForegroundColor Green -NoNewLine "Remote Address: "; Write-Host $Result.RemoteAddress
Write-Host -ForegroundColor Green -NoNewline "Result: "; If($Result.PingSucceeded) {Write-Host "Ok"} Else {Write-Host "Error"}
Write-Host -ForegroundColor Green -NoNewLine "Round Trip Time: "; Write-Host $Result.RoundTripTime

Write-Host -NoNewline -ForegroundColor Cyan "`nWriting results to SQLite database ... "

$Database = "C:\tools\NetMonitor\NetMonitor.db"
$Query = "INSERT INTO NetMonitor (TimeStamp, RemoteAddress, InterfaceAlias, PingSucceeded, RoundTripTime) VALUES (@TimeStamp, @RemoteAddress, @InterfaceAlias, @PingSucceeded, @RoundTripTime)"

Invoke-SqliteQuery -Database $Database -Query $Query -SqlParameters @{
    TimeStamp = $Result.TimeStamp
    RemoteAddress = $Result.RemoteAddress
    InterfaceAlias = $Result.InterfaceAlias
    PingSucceeded = $Result.PingSucceeded
    RoundTripTime = $Result.RoundTripTime
}

Write-Host -ForegroundColor Cyan "done."

