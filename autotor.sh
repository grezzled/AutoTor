#!/bin/bash
VERSION="v1.0.2"
NAME="AutoTor"
# Escape Sequences
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
NOCOLOR="\033[0m"

#PATHS
TORCCSIMPLE="/usr/local/etc/tor/torrc.sample"
TORCC="/usr/local/etc/tor/torrc"
#///////////////////
clear

echo -e "  _____  _____   ______  ______ ______ _       ______  _____  
 / ____||  __ \ |  ____||___  /|___  /| |     |  ____||  __ \ 
| |  __ | |__) || |__      / /    / / | |     | |__   | |  | |
| | |_ ||  _  / |  __|    / /    / /  | |     |  __|  | |  | |
| |__| || | \ \ | |____  / /__  / /__ | |____ | |____ | |__| |
 \_____||_|  \_\|______|/_____|/_____||______||______||_____/  

    ${GREEN} $NAME ${NOCOLOR}- ${YELLOW} $VERSION ${NOCOLOR} by ${GREEN}${YELLOW}(Grezzled) ${NOCOLOR}"
echo ""
echo -e "${YELLOW}>>>${NOCOLOR} initialisation.."
echo -e "${YELLOW}>>>${NOCOLOR} Tor Installation Check.."
if hash tor 2>/dev/null; then
	echo -e "${GREEN}>>> Tor is Installed ${NOCOLOR}";
	if [[ -f "$TORCCSIMPLE" ]]; then
		 echo -e "${GREEN}>>>${NOCOLOR} torrc.sample located successfully${NOCOLOR}";
		 echo -e "${YELLOW}>>>${NOCOLOR} Making torrc file effective${NOCOLOR}";
		 mv "$TORCCSIMPLE" "$TORCC" || "${RED}Cannot Rename torrc.simple";
		 echo -e "${GREEN}>>>${NOCOLOR} torrc.simple renamed to torrc successfully${NOCOLOR}";
	elif [[ -f "$TORCC" ]]; then
		 echo -e "${GREEN}>>>${NOCOLOR} torrc file located successfully${NOCOLOR}";
	else
		echo -e "${RED}Oops! torrc file not found ${YELLOW}◕_◕ ${NOCOLOR}";
		exit;
	fi
else
	echo -e "${RED}Tor not Found ${YELLOW}◕_◕${NOCOLOR}";
	echo -e "${NOCOLOR}Press [ENTER] to install or any other key to abort";
	read -s -n 1 key 
	if [[ $key = "" ]]; then
		echo -e "${GREEN}>>>${NOCOLOR}HomeBrew Installation check..";
		if hash brew 2>/dev/null; then
			brew install tor
		else
			echo -e "${RED}HomeBrew not Found ${YELLOW}◕_◕ ${NOCOLOR}";
			echo -e "${NOCOLOR}Press [ENTER] to install or any other key to abort";
			read -s -n 1 key
			if [[ $key = "" ]]; then
				echo -e "${NOCOLOR}Installing brew";
				/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)";
			else
				echo -e "${YELLOW}process cancelled.${NOCOLOR}"
				exit;
			fi
		fi
	else
		echo -e "${YELLOW}process cancelled.${NOCOLOR}"
		exit;
	fi
fi

TOR_STATUS="false"

function torStatus {
	echo -e "${YELLOW}>>>${NOCOLOR} service status.."
	STR=$(brew services list | grep tor | xargs)
	if [[ $STR == *"started"* ]]; then
		TOR_STATUS="true"
		echo -e "${YELLOW}>>>${NOCOLOR} Running";
	elif [[ $STR == *"stopped"* ]]; then
		TOR_STATUS="false"
		echo -e "${GREEN}>>>${NOCOLOR} not Running";
	fi
}

torStatus 

echo "Set Duration (in seconds) to change the IP Address :"
read TimeInSeconds

echo "IP will change every ${TimeInSeconds} seconds"

if [[ $TOR_STATUS == "false" ]]; then
	echo -e "${YELLOW}>>>${NOCOLOR} Starting tor service..";
	brew services start tor
elif [[ $TOR_STATUS == "true" ]]; then
	echo -e "${YELLOW}>>>${NOCOLOR} Restarting tor service..";
	brew services restart tor
fi

echo -e "${YELLOW}>>>${NOCOLOR}Enabling Proxy 127.0.0.1 9050"

networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 9050

function ip {
	echo -e "${YELLOW}>>>${NOCOLOR}Fetch new IP address"
	IP=$(curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s http://checkip.amazonaws.com/ | cat | xargs )
	
	echo -e "${YELLOW}IP Address${NOCOLOR} : ${GREEN}$IP${NOCOLOR}"
}

ip


trap break INT
while true; do
	sleep $TimeInSeconds;
	echo ""
	echo -e "${YELLOW}>>>${NOCOLOR} Restarting tor service..";
	brew services restart tor
	ip
	echo "IP will be changed every ${TimeInSeconds} seconds"
	echo "Precc CTRL-C to Quit"
done
trap - INT
echo ""
echo -e "${YELLOW}>>>${NOCOLOR}Terminating proxy 127.0.0.1 9050"
networksetup -setsocksfirewallproxystate Wi-Fi off;
echo -e "${GREEN}>>>${NOCOLOR}Proxy terminated successfully"
brew services stop tor
echo -e "See yaa ${YELLOW}(｡◕‿◕｡)${NOCOLOR}"

