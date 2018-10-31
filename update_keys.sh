#!/bin/bash
KEYBASE_USER=pveronneau
KEYBASE_PROXY=socks5://localhost:10700
KEYBASE_KEYNAME=id_rsa.pub
CHECKSUM="4f641ad19e710860ac12d90bf3e13833729d93f77641807e06c7ad9cab82f31ba2e193da8169ab82d09e2a4720e4afa406a78453f1adc33dd89463963e2a348f authorized_keys"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

if curl -s --fail -m 5 -X GET https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > /dev/null; then
	curl -s https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > ~/.ssh/authorized_keys && echo -e "\e[92mupdated keys\e[0m" || echo -e "\e[31mfailed to update keys\e[0m"
	echo "Verifying the expected sha512 checksum on ~/.ssh/authorized_keys"
	if cd ~/.ssh/ && echo $CHECKSUM | sha512sum --quiet -c -; then
		echo -e "\e[92mChecksum valid\e[0m"
	else
		echo -e "\e[31mChecksum $CHECKSUM is invalid, purging the entry\e[0m"
		rm ~/.ssh/authorized_keys
		exit 1
	fi;
	exit 0
else
    echo -e "\e[33mfailed to connect directly, adding proxy\e[0m"
    export https_proxy=$KEYBASE_PROXY
    if curl -s --fail  -m 5 -X GET https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > /dev/null; then
	    curl -s https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > ~/.ssh/authorized_keys && echo -e "\e[92mupdated keys with proxy\e[0m" || echo -e "\e[31mfailed to update keys with proxy\e[0m"
	    unset https_proxy
		echo "Verifying the expected sha512 checksum on ~/.ssh/authorized_keys"
		if cd ~/.ssh/ && echo $CHECKSUM | sha512sum --quiet -c -; then
			echo -e "\e[92mChecksum valid\e[0m"
		else
			echo -e "\e[31mChecksum $CHECKSUM is invalid, purging the entry\e[0m"
			rm ~/.ssh/authorized_keys
			exit 1
		fi;
		exit 0
	else
	    echo -e "\e[31mfailed to connect with proxy\e[0m"
	    unset https_proxy
	fi;
fi;

if curl -s -k --fail  -m 5 -X GET https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > /dev/null; then
	curl -s -k https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > ~/.ssh/authorized_keys && echo -e "\e[33mupdated keys insecurely\e[0m" || echo -e "\e[31mfailed to update keys insecurely\e[0m"
else
    echo -e "\e[33mfailed to connect directly with insecure, adding proxy\e[0m"
    export https_proxy=KEYBASE_PROXY
    if curl -s --fail -m 5 -X GET https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > /dev/null; then
	    curl -s https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > ~/.ssh/authorized_keys && echo -e "\e[33mupdated keys with proxy insecurely\e[0m" || echo -e "\e[31mfailed to update keys with proxy insecurely\e[0m"
	    unset https_proxy
	else
	    echo -e "\e[31mfailed to connect with proxy insecurely\e[0m"
	    unset https_proxy
	fi;
fi;

#Verify the file
echo "Verifying the expected sha512 checksum on ~/.ssh/authorized_keys"
if cd ~/.ssh/ && echo $CHECKSUM | sha512sum --quiet -c -; then
	echo -e "\e[92mChecksum Valid\e[0m"
else
	echo -e "\e[31mChecksum $CHECKSUM is invalid, purging the entry\e[0m"
	rm ~/.ssh/authorized_keys
	exit 1
fi;