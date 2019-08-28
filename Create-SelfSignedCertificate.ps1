# create root CA
$params = @{
  DnsName = "Our Own Root Cert For Self-Signing"
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(10)
  CertStoreLocation = 'Cert:\LocalMachine\My'
  KeyUsage = 'CertSign','CRLSign' #fixes invalid cert error
}
$rootCA = New-SelfSignedCertificate @params

# create server certificate signed by root above
$params = @{
  DnsName = "<add your own here, eg. xxxx.westeurope.azurecontainer.io"
  Signer = $rootCA
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-date).AddYears(5)
  CertStoreLocation = 'Cert:\LocalMachine\My'
}
$serverCert = New-SelfSignedCertificate @params

# ensure we have a certs directory
# notes: that's where we will store the certificates/keys etc.
#        you can remove the directory after you created the keys/certificates.
$path = "C:\certs"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

# add self-signed root to trusted root certificate store of current windows client
# Extra step needed since self-signed cannot be directly shipped to trusted root CA store
# if you want to silence the cert warnings on other systems you'll need to import the rootCA.crt on them too
Export-Certificate -Cert $rootCA -FilePath "C:\certs\rootCA.crt"
Import-Certificate -CertStoreLocation 'Cert:\LocalMachine\Root' -FilePath "C:\certs\rootCA.crt"

# export server certificate as .pfx and .crt
Export-PfxCertificate -Cert $serverCert -FilePath 'C:\certs\key_for_amls.pfx' -Password (ConvertTo-SecureString -AsPlainText 'securepw' -Force)
Export-Certificate -Cert $serverCert -FilePath "C:\certs\certificate_for_amls.crt"

# --- now open a BASH shell by running the bash command in a cmd window

# extract server private key from .pfx to convert .crt to .pem
# enter bash session from cmd as admin and cd to directory containing key_for_amls.pfx etc.
cd /mnt/c/certs

# convert root ca certificate to pem format
openssl x509 -inform DER -in rootCA.crt -out rootCA.pem

# export server private key to pem format
openssl pkcs12 -in key_for_amls.pfx -nocerts -nodes -out private_key_for_amls.pem

# convert server certificate to pem format
openssl x509 -inform DER -in certificate_for_amls.crt -out certificate_for_amls.pem
