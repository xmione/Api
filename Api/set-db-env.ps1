$env:DB_SERVER = "localhost,14344"
$env:DB_NAME = "master"
$env:DB_USER = "sa"
$env:DB_PASS = "P@ssw0rd123"

# PowerShell script to set environment variables

# Database credentials
$dbServer = "localhost,14344"
$dbName = "master"
$dbUser = "sa"
$dbPass = "P@ssw0rd123"

# Set environment variables
[Environment]::SetEnvironmentVariable("DB_SERVER", $dbServer, "Machine")
[Environment]::SetEnvironmentVariable("DB_NAME", $dbName, "Machine")
[Environment]::SetEnvironmentVariable("DB_USER", $dbUser, "Machine")
[Environment]::SetEnvironmentVariable("DB_PASS", $dbPass, "Machine")

# Print out the values to verify they've been set
Write-Output "DB_SERVER: $env:DB_SERVER"
Write-Output "DB_NAME: $env:DB_NAME"
Write-Output "DB_USER: $env:DB_USER"
Write-Output "DB_PASS: $env:DB_PASS"
