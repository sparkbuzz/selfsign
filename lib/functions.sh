#!/usr/bin/env sh

# Asserts the given file exists, otherwise exits the script
# $1 -> Filename to assert
#
function assert_file {
  if [ ! -f "$1" ]; then
    printf "${RED}✗${NC}\n"
    exit 1
  else
    printf "${GREEN}✓${NC}\n"
  fi
}

# Outputs basic info for the given certificate
# $1 -> certificate filename
#
function certificate_info {
  openssl x509 -text -noout -in $1 | \
    grep -E 'Subject:|DNS:' | \
    sed 's|^[ \t]*| |g' | \
    sed "s|Subject:|$(echo $GREEN' Subject :'$GRAY)|" | \
    sed "s|DNS:|$(echo $GREEN' DNS     :'$GRAY) |"
}

# Generates an RSA private key
# $1 -> output path
# $2 -> domain name
#
function generate_rsa_key {
  printf "${WHITE}⦿${NC} Generating RSA private key "
  openssl genrsa -out $1/$2/privkey.pem 1024 > /dev/null 2>&1
  assert_file "$1/$2/privkey.pem"
}

# Create Certificate Signing Request
# $1 -> output path
# $2 -> domain name
#
function generate_csr {
  printf "${WHITE}⦿${NC} Generating Certificate Signing Request ";
  openssl req \
    -new \
    -key $1/$2/privkey.pem \
    -out $1/$2/cert.csr \
    -subj "/C=$COUNTRY_CODE/ST=$STATE/L=$LOCALITY/O=$COMPANY/CN=$2" \
      > /dev/null 2>&1

  assert_file "$1/$2/cert.csr"
}

# Generates the certificate
# $1 -> output path
# $2 -> domain name
#
function generate_certificate {
  # Create temp file with configuration
  local TMP_OPENSSL_CONFIG=$(mktemp)
  cat /etc/ssl/openssl.cnf > $TMP_OPENSSL_CONFIG
  printf "[SAN]\nsubjectAltName=DNS:$2 " >> $TMP_OPENSSL_CONFIG

  # Generate the certificate
  printf "${WHITE}⦿${NC} Generating certificate "
  openssl req \
    -newkey rsa:2048 \
    -x509 \
    -nodes \
    -keyout $1/$2/privkey.pem \
    -new \
    -out $1/$2/cert.pem \
    -subj "/C=$COUNTRY_CODE/ST=$STATE/L=$LOCALITY/O=$COMPANY/CN=$2" \
    -reqexts SAN \
    -extensions SAN \
    -config $TMP_OPENSSL_CONFIG \
    -sha256 \
    -days 365 \
      > /dev/null 2>&1

  # Remove the temporary config file
  rm $TMP_OPENSSL_CONFIG

  assert_file "$1/$2/cert.pem"
}

# Lists file permissions for files generated
# $1 -> List of files to check
# Example: list_permissions "/tmp/one.txt /tmp/two.txt"
#
function list_permissions {
  chmod 400 $1
  printf "${WHITE}⦿${NC} Updated file permissions \n"
  ls -l $1 | \
    awk -v nc=$NC -v gray=$GRAY '{print gray"  [" $1n "]"nc, $9}'
}

# Show usage information
#
function usage {
  echo 'Usage: ./selfsign <domain_name>';
  exit 0;
}
