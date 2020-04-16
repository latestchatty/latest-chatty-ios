#  How to Create APNS Certificates for Woggle Push Notification Service

## Production

- Create new `Apple Push Notification service SSL (Sandbox & Production)` certificate in Apple Developer portal

- Generate CSR in Keychain Access  
  Enter email address, use `LatestChatty Push Key` as common name, save to disk, then upload to Apple

- Download certificate

- Open certificate into Keychain Access

- Export the certificate and private key to p12 with filename `LatestChatty_Push_Prod.p12` and standard Woggle password (*redacted from source control*)

- Run following command in Terminal:  
  `openssl pkcs12 -in LatestChatty_Push_Prod.p12 -out LatestChatty_Push_Prod.pem`  
  *enter password 3 times*

- Send certificates & passwords to bradsh to be installed on Woggle

## Development

- Repeat same steps above but create a new `Apple Push Notification service SSL (Sandbox)` certificate in Apple Developer portal
- Use same standard Woggle password (*redacted from source control*)
- Use `LatestChatty_Push_Dev.p12` as exported certificate filename and generated pem filename
