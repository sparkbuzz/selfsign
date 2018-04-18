#!/usr/bin/env sh

# Asserts the given file exists, otherwise exits the script
function assert_file {
  if [ ! -f "$1" ]; then
    printf "${RED}✗${NC}\n"
    exit 1
  else
    printf "${GREEN}✓${NC}\n"
  fi
}

# Outputs basic info for the given certificate
function certificate_info {
  openssl x509 -text -noout -in $1 | \
    grep -E 'Subject:|DNS:' | \
    sed 's|^[ \t]*|  |g' | \
    sed "s|Subject:|$(echo $GREEN'Subject:'$GRAY) |" | \
    sed "s|DNS:|$(echo $GREEN'DNS:'$GRAY) |"
}

# Lists file permissions for files generated
function list_permissions {
  chmod 400 $1
  printf "${WHITE}⦿${NC} Updated file permissions \n"
  ls -l $1 | \
    awk -v nc=$NC -v gray=$GRAY '{print gray"  [" $1n "]"nc, $9}'
}