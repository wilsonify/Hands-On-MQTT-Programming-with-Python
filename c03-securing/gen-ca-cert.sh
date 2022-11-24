# Generating a private certificate authority to use TLS with Mosquitto
# So far,
# we have been working with a Mosquitto server with its default configuration,

# which listens on port 1883 and uses plain TCP as the transport protocol.
# The data sent between each MQTT client and the
# MQTT server isn't encrypted. 
# There are no restrictions on subscribers or publishers. 
# If we open firewall ports and redirect ports in the router,
# or we configure port securities for a cloud-based virtual machine in which the MQTT server is running,
# any MQTT client that has the IP address or host name for the MQTT server can publish
# to any topic and can subscribe to any topic.
# In our examples in Chapter 2,
# Using Command-Line and GUI Tools to Learn How MQTT Works,
# we haven't made any changes in our configurations to allow incoming connections to port 1883,
# and therefore we haven't opened our Mosquitto server to the internet.
# We want to use TLS with MQTT and Mosquitto in our development environment.
# This way,
# we will make sure that we can trust the MQTT server because we have confidence it is who it says it is,
# our data will be private because it will be encrypted,
# and it will have integrity because it won't be altered.
# If you have experience with the HTTP protocol,
# you'll recognize that we make the same shift we do when we move from using HTTP to HTTPS.
#
# Websites purchase certificates from major certificate authorities.
# If we want to use a purchased certificate for the server,
# we don't need to generate our own certificates.
# In fact,
# it is the most convenient option when we have an MQTT server made public and we move to a production environment.
#
# In this case,
# we will use the free OpenSSL utility to generate the necessary certificates for the server
# to enable TLS with Mosquitto for our development environment.
# It is very important to notice that we won't generate a production-ready configuration and
# we are focusing on a secure development environment that will mimic a secure production environment.
# OpenSSL is already installed in macOS and
# most modern Linux distributions.
# In Windows,
# we have already installed OpenSSL as one of the prerequisites for Mosquitto.
# The use of the OpenSSL utility deserves an entire book,
# and therefore we will just focus on generating the certificate we need with the most common options.
# If you have specific security needs,
# make sure you explore the necessary options to achieve your goals with OpenSSL.
# Specifically,
# we will generate an X.509 digital certificate that uses the X.509 PKI (short for public key infrastructure) standard.
# This digital certificate allows us to confirm that a specific public key belongs to the subject included within the certificate.
# There is an identity that issues the certificate and its details are also included in the certificate.
#
# The digital certificate is valid only within a specific period,
# and therefore we must take into account that a digital certificate will expire some day and we will
# have to provide a new certificate to replace the expired one.
#
# There are specific data requirements for certificates based on the specific X.509 version that we use.
# According to the version and to the options we use to generate the certificates,
# we might need to provide specific data.
# We will be running commands to generate different X.509
# digital certificates and we will provide all the necessary details that will be included in the certificate.
# We will understand all the data that the certificate will have when we create it.
# We will create our own private certificate authority,
# also known as a CA.
# We will create a root certificate and then we will generate the server key.
# Check the directory or folder in which you installed OpenSSL.
# On macOS,
# OpenSSL is installed in /usr/bin/openssl.
# However,
# it is an old version and
# it is necessary to install a newer version before running the commands.
# It is possible to install the new version with the homebrew package manager and you will be able to run the new version in another directory.
# For example,
# the path for version 1.0.2n,
# installed with homebrew,
# will be in /usr/local/Cellar/openssl/1.0.2n/bin/openssl.
# Make sure you don't use the default old version.
# In Windows,
# the OpenSSL version we installed as a prerequisite for Mosquitto, in Chapter 2,
# Using Command-Line and GUI Tools to Learn How MQTT Works,
# s the openssl. exe executable file in the default C:\OpenSSL-Win32\bin folder.
# If you are working with Windows,
# you can use either the Command Prompt or Windows PowerShell.
# In any operating system,
# use the full path to the appropriate OpenSSL version in each of the next commands that start with openssl.
# Create a new directory named mosquitto_certificates and change the necessary permissions for
mkdir -p mosquitto_certificates
# this directory to make sure that you can only access its contents.
# Open a Terminal in macOS or Linux,
# or a Command Prompt in Windows,
# and go to the previously created directory, mosquitto_certificates.
cd mosquitto_certificates
# Run the following command to create a 2,048-bit root key and save it in the ca.key file:
openssl genrsa -out ca.key 2048

#The following lines show sample output generated by the previous command:
# Generating RSA private key,
# 2048 bit long modulus e is 65537 (0x010001)
# The previous command will generate the private root key in the ca.key file.
# Make sure you keep this file private because anybody that has this file will be able to generate certificates.
# It is also possible to password-
# protect this file by using other options with openssl.
# However, as previously explained,
# we will follow the necessary steps to use TLS and you can explore additional options related to OpenSSL and certificates.
# Go to the Terminal in macOS or Linux,
# or the Command Prompt in Windows.
# Run the following command to self-sign the root certificate.
# The next command uses the previously created 2,048-bit private key
# saved in the ca.key file and generates a ca.crt file with the self-signed X.509 digital certificate.
# The command makes the self-signed certificate valid for 3650 days.
# The value is specified after the -days option:
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt

#In this case, we specified the -sha256 option to use SHA-256 hash functions.
# If we want increased security,
# we can use the -sha512 instead option of -sha256 in all cases in which
# we are using -sha256.
# This way,
# we will use SHA-512 hash functions.
# However,
# we must take into account that SHA-512 might not be appropriate for certain power-constrained IoT devices.
# After you enter the previous command,
# OpenSSL asks for information that will be incorporated into the certificate.
# You have to enter the information and press Enter.
# If you don't want to enter specific information,
# just enter a dot (.) and press Enter.
# It is possible to pass all the values as arguments for the openssl command,
# but it makes it a bit difficult to understand what we are doing.
# In fact,
# it is also possible to use fewer calls to the openssl command to perform the previous tasks.
# However,
# we run a few more steps to understand what we are doing.
# The following lines show sample output and questions with sample answers.
# Remember that we are generating our private certificate authority:
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.

#-----
#Country Name (2 letter code) [AU]:US
#State or Province Name (full name) [Some-State]:NEW YORK CITY
#Locality Name (eg,  city) []:NEW YORK
#Organization Name (eg, company) [Internet Widgits Pty Ltd]:MOSQUITTO CERTIFICATE AUTHORITY
#Organizational Unit Name (eg, section) []:
#Common Name (e.g. server FQDN or YOUR name) []:MOSQUITTO CERTIFICATE AUTHORITY
#Email Address []:mosquittoca@example.com

#Run the following command to display the data and details for the recently generated certificate authority certificate file:
# Certificate:
# Data:
# Version: 3 (0x2)
# Serial Number: 96:f6:f6:36:ad:63:b2:1f
# Signature Algorithm: sha256WithRSAEncryption
# Issuer: C = US,
# ST = NEW YORK,
# L = NEW YORK,
# O = MOSQUITTO CERTIFICATE AUTHORITY,
# CN = MOSQUITTO CERTIFICATE AUTHORITY,
# emailAddress = mosquittoca@example.com
# Validity
# Not Before: Mar 22 15:43:23 2018 GMT
# Not After : Mar 19 15:43:23 2028 GMT
# Subject: C = US,
# ST = NEW YORK,
# L = NEW YORK,
# O = MOSQUITTO CERTIFICATE AUTHORITY,
# CN = MOSQUITTO CERTIFICATE AUTHORITY,
# emailAddress = mosquittoca@example.com
# Subject Public Key Info:
# Public Key Algorithm: rsaEncryption
# Public-Key: (2048 bit)
# Modulus:
# 00:c0:45:aa:43:d4:76:e7:dc:58:9b:19:85:5d:35:
# 54:2f:58:61:72:6a:42:81:f9:64:1b:51:18:e1:95:
# ...
# Exponent: 65537 (0x10001)
# X509v3 extensions:
# X509v3 Subject Key Identifier: F7:C7:9E:9D:D9:F2:9D:38:2F:7C:A6:8F:C5:07:56:57:48:7D:07:35
# X509v3 Authority Key Identifier:
# keyid:F7:C7:9E:9D:D9:F2:9D:38:2F:7C:A6:8F:C5:07:56:57:48:7D:07:35
# X509v3 Basic Constraints: critical
# CA:TRUE
# Signature Algorithm: sha256WithRSAEncryption
# a2:64:5d:7b:f4:85:81:f7:d0:30:8b:8d:7c:83:83:63:2c:4e:
# a8:56:fb:fc:f0:4f:d4:d8:9c:cd:ac:c7:e9:bc:4b:b5:87:9e:
#
# After running the previous commands,
# we will have the following two files in the mqtt_certificates directory:
# ca.key: Certificate authority key
# ca.crt: Certificate authority certificate file
# The certificate authority certificate file is in the PEM (short for privacy enhanced mail) format.
# We must remember this format because some MQTT utilities will require us to
# specify whether the certificate is in PEM format or not.
# A wrong value in this option won't allow the MQTT client to establish a
# connection with an MQTT server that uses a certificate in PEM format.
