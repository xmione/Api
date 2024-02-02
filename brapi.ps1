#===============================================================================================================
# FileName	: brapi.ps1 - Build and Run api docker container using docker compose. Includes certificate imports.
# Created By: Solomio S. Sisante
# Created On: January 22,2024
#===============================================================================================================

function Check-IfAdmin {
    # Get the current user's identity
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    # Create a new principal for the current user
    $p = New-Object System.Security.Principal.WindowsPrincipal($id)

    # Check if the user is in the Administrator role and return the result
    return $p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Call the function and store the result
$isAdmin = Check-IfAdmin

# 1. Change Directory from Docker folder to Solution root

$curDir = Get-Location

# 2. Declare variables for certificates:
$certPassword = ConvertTo-SecureString -String "P@ssw0rd123" -Force -AsPlainText
$securePassword = $certPassword | ConvertFrom-SecureString

$certPath_Api = "API.pfx"

$subjApi = "/C=PH/ST=CAVITE/L=BACOOR/O=ACCSOL/OU=IT/CN=localhost"

# 3. Generate certificates for linux docker container from windows 11 host machine:
# Check if OpenSSL is installed
try {
    $opensslVersion = openssl version
    Write-Host "OpenSSL is installed. Version: $opensslVersion"
} catch {
    Write-Host "OpenSSL is not installed."
    # Check if chocolatey is installed
    try {
        $chocoVersion = choco -v
        Write-Host "Chocolatey is installed. Version: $chocoVersion"
    } catch {
        Write-Host "Chocolatey is not installed. Installing now..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }

    choco install openssl -y --force
}

# Generate the RSA key
openssl genrsa -out .\API.key 4096

# Generate a new X.509 certificate using the private key
openssl req -new -x509 -text -key .\API.key -out .\API.crt -subj $subjApi

# Convert the certificate to PKCS#12 format
openssl pkcs12 -export -out .\API.pfx -inkey .\API.key -in .\API.crt -password pass:P@ssw0rd123

# 4. Import the certificate into the Windows certificate store
# Check if the certificate files exist
if (Test-Path $certPath_Api) {

    # Output the result
    if ($isAdmin) {
        Write-Output "The current user is an administrator."
        # Run the script as an administrator
        # Start-Process -FilePath "powershell" -ArgumentList "-Command & {Import-PfxCertificate -FilePath $certPath_Web -CertStoreLocation Cert:\LocalMachine\My -Password $certPassword}"
        # Start-Process -FilePath "powershell" -ArgumentList "-Command & {Import-PfxCertificate -FilePath $certPath_Api -CertStoreLocation Cert:\LocalMachine\My -Password $certPassword}"
        # Start-Process -FilePath "powershell" -ArgumentList "-Command & {Import-PfxCertificate -FilePath $certPath_Localhost -CertStoreLocation Cert:\LocalMachine\My -Password $certPassword}"

        Import-PfxCertificate -FilePath $curDir\$certPath_Api -CertStoreLocation Cert:\LocalMachine\My -Password $certPassword

    } else {
        Write-Output "The current user is not an administrator."
        # Run the script as an administrator
        
        Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList " -NoExit -Command & {Import-PfxCertificate -FilePath $curDir\$certPath_Api -CertStoreLocation Cert:\LocalMachine\My -Password (ConvertTo-SecureString $securePassword) }"
    }
    
} else {
    Write-Host "Certificate files not found. Please check the file paths."
}

# 5. Bring down the containers first.
  docker-compose down

# 6. Build and Run docker containers by running docker compose file:
  docker-compose --verbose up --build -d
 # docker-compose --verbose -f apidc.yml up --build 

# 7. Manually run this powershell script file to copy certificate files to the container and register/trust them.
 .\cucerts.ps1