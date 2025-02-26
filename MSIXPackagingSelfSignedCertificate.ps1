New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -Subject "CN=MSIXPackagingCert" -Type CodeSigningCert -KeyAlgorithm RSA -KeyLength 2048 -HashAlgorithm SHA256 -NotAfter (Get-Date).AddYears(2) -FriendlyName "MSIX Packaging Signing Certificate"
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -eq "CN=MSIXPackagingCert" }
$certPassword = ConvertTo-SecureString -String "Parola" -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath "C:\cert\MSIXPackagingCert.pfx" -Password $certPassword
