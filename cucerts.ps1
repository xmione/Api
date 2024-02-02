#============================================================================================================
# FileName	: cucerts.ps1 - Copy and update CA certificates.
# Created By: Solomio S. Sisante
# Created On: January 17,2024
#============================================================================================================

Write-Output "#============================================================================================================"
Write-Output "# FileName  : cucerts.ps1 - Copy and update CA certificates."
Write-Output "# Created By: Solomio S. Sisante"
Write-Output "# Created On: January 17,2024"
Write-Output "#============================================================================================================"

 
 Write-Output "Copying api certificates from /src/ to /usr/local/share/ca-certificates/"
 docker exec api /bin/bash -c "cp /src/*.pfx /usr/local/share/ca-certificates/"
 docker exec api /bin/bash -c "cp /src/*.crt /usr/local/share/ca-certificates/"
 docker exec api /bin/bash -c "cp /src/*.key /usr/local/share/ca-certificates/"

 Write-Output "Updating accsol.api certificates"
 docker exec api /bin/bash -c "update-ca-certificates"

 Write-Output "ls -la /etc/ssl/certs/ca-certificates.crt"
 docker exec api /bin/bash -c "ls -la /etc/ssl/certs/ca-certificates.crt"

 <#
 docker exec accsol /bin/bash -c "cat /etc/ssl/certs/ca-certificates.crt"
 docker exec accsol.api /bin/bash -c "cat /etc/ssl/certs/ca-certificates.crt"


 docker exec accsol /bin/bash -c "openssl x509 -in /usr/local/share/ca-certificates/ca-certificates.crt -text -noout"  > accsol-usr.txt
 docker exec accsol.api /bin/bash -c "openssl x509 -in /usr/local/share/ca-certificates/ca-certificates.crt -text -noout" > accsol.api-usr.txt

 docker exec accsol /bin/bash -c "openssl x509 -in /etc/ssl/certs/ca-certificates.crt -text -noout" > accsol-etc.txt
 docker exec accsol.api /bin/bash -c "openssl x509 -in /etc/ssl/certs/ca-certificates.crt -text -noout" > accsol.api-etc.txt

 docker exec accsol.api /bin/bash -c "openssl crl2pkcs7 -nocrl -certfile /etc/ssl/certs/ca-certificates.crt | openssl pkcs7 -print_certs -text -noout" > accsol.api.txt

 certutil -user -store -v My > certs.log
 certutil -store -v My > certs.log
 notepad certs.log

 # Write an index.html file at the /app folder
 docker exec accsol /bin/bash -c "echo 'Testing if index.html in /app works!!!' > /app/index.html"

 # Display the contents of /app/index.html file
 docker exec accsol /bin/bash -c "cat /app/index.html"

 docker top accsol
 
 
 
 #>
 
 