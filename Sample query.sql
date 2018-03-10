SELECT
	DATETIME(`TimeStamp`,'unixepoch','localtime') AS 'Date/Time', 
	`RemoteAddress`, `InterfaceAlias`, 
	CASE WHEN `PingSucceeded` = '0' THEN 'FALSE' ELSE 'TRUE' END AS `PingSucceeded`, 
	`RoundTripTime` 
FROM NetMonitor
ORDER BY `Date/Time` DESC
