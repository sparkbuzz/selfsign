```             
                                            | |/ _|   (_)            
                                    ___  ___| | |_ ___ _  __ _ _ __  
                                   / __|/ _ \ |  _/ __| |/ _` | '_ \ 
                                   \__ \  __/ | | \__ \ | (_| | | | |
                                   |___/\___|_|_| |___/_|\__, |_| |_|
                                                          __/ |      
                                                         |___/       
```

This is a simple shell script utility that uses [OpenSSL](https://www.openssl.org/) to generate self signed 
certificates. These certificates are intended purely for development purposes.

![alt text](https://raw.githubusercontent.com/sparkbuzz/selfsign/master/images/screengrab.gif "How to use selfsign")

# Installation

Ensure you have OpenSSL installed. Simply run 

`brew install openssl` 

on MacOS. Checkout this repository and symlink
[./bin/selfsign](https://github.com/sparkbuzz/selfsign/blob/master/bin/selfsign) using 

`ln -nfs /usr/local/bin/selfsign <your_path>/selfsign/bin/selfsign`

# Usage

For usage information run

`selfsign --help`

To generate a certificate run 

`selfsign mysitename.localhost --out /path/to/output`

This will generate three files in the given path:
  - mysitename.localhost.csr
  - mysitename.localhost.cer
  - mysitename.localhost.key

