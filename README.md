# Scripts for provisioning devices for Google Cloud IoT Core

These scripts will be run on one of two machines. Each step below notes where it should be run.
* workstation: Your development machine.
* device: The device you're provisioning so that it can talk to Cloud IoT Core.

1. [run on workstation] Use `make_ca.sh` to set up a certificate authority. It will be used to sign devices' certs. When you set up the registry on Cloud IoT Core, supply the CA cert. This is done only once.
2. [run on device] Run `make_device_key_and_csr.sh` on the device that you are provisioning. This is important! You should not generate a private key on some other machine (e.g. workstation) and then `scp` it to the device. The private key should only ever exist on the device. This will make a `.pem` file (the private key) and a `.csr` file (the certificate signing request). **NOTE:** The device ID you provide here **MUST** be the same as the device ID you enter in the Cloud IoT Core registry.
3. [run on workstation] `scp` the certificate signing request (the `.csr` file) to your workstation. Use `sign_csr.sh` to sign it. The cert will be placed alongside the original `.csr` file, and it will have the extension `.x509`. When you add the device to the Cloud IoT core registry, supply the cert. You can also `scp` the cert back to the device if you like.
