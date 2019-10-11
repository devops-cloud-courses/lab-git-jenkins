#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

for name in $(cat ${SCRIPTPATH}/logins.list)
do 
	password=$(openssl rand -base64 5)
	echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"${name}\", \"${password}\")" >> jenkins-create-user.groovy
	echo "${name}:${password}" >> ${SCRIPTPATH}//jenkinscred.list
done
