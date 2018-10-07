#!/bin/bash
KEYBASE_USER=pveronneau
KEYBASE_PROXY=socks5://localhost:10700
KEYBASE_KEYNAME=id_rsa.pub

touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

if curl -s --fail -m 5 -X GET https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > /dev/null; then
	curl -s https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > ~/.ssh/authorized_keys && echo -e "\e[92mupdated keys\e[0m" && exit 0 || echo -e "\e[31mfailed to update keys\e[0m"
else
    echo -e "\e[33mfailed to connect directly, adding proxy\e[0m"
    export https_proxy=$KEYBASE_PROXY
    if curl -s --fail  -m 5 -X GET https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > /dev/null; then
	    curl -s https://$KEYBASE_USER.keybase.pub/$KEYBASE_KEYNAME > ~/.ssh/authorized_keys && echo -e "\e[92mupdated keys with proxy\e[0m" && exit 0 || echo -e "\e[31mfailed to update keys with proxy\e[0m"
	    unset https_proxy
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