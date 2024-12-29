#! /bin/bash

#
# $1 acme.json path
# $2 domain to extract the certificates
# $3 output path
#


readonly acmefile="${1}"
readonly targetdomain="${2}"
readonly certdir="${3%/}"
jq=$(command -v jq)
priv=$(${jq} -e -r '.[].Account.PrivateKey' "${acmefile}")

mkdir -p ${certdir}

for domain in $(jq -r '.[].Certificates[].domain.main' ${acmefile}); do
  if [ "$domain" = "$targetdomain" ]; then
    cert=$(jq -e -r --arg domain "$domain" '.[].Certificates[] |
            select (.domain.main == $domain )| .certificate' ${acmefile}) || bad_acme
    echo "${cert}" | base64 -d > "${certdir}/${domain}.crt"

    key=$(jq -e -r --arg domain "$domain" '.[].Certificates[] |
      select (.domain.main == $domain )| .key' ${acmefile}) || bad_acme
    echo "${key}" | base64 -d > "${certdir}/${domain}.key"
  fi
done