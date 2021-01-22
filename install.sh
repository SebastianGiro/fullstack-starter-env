#!/bin/bash
readonly VERSION=0.1

readonly NC='\033[0m' # No Color
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'

# INSTALL VARIABLES
I_AUTO=false

I_U_EXTRAS=true
I_GIT=true
I_YARN=true
I_TERM=true
I_VSCODE=true
I_DOCKER=true

I_CHROME=true
I_OPERA=true

# SET simple os var
if [ "$OSTYPE" == "linux-gnu" ]; then
    # Linux
    OS="linux"
elif [[ "$OSTYPE" == "darwin" ]]; then
    # Mac OSX
    OS="osx"
fi


ask_for_install() {
    # ask_for_install "GIT"

    if [ "$OS" == "linux" ]; then
        if ask_for "Ubuntu Extras"; then I_U_EXTRAS=false; else I_U_EXTRAS=true; fi
    fi

    if ask_for "GIT"; then I_GIT=false; else I_GIT=true; fi
    if ask_for "Yarn"; then I_YARN=false; else I_YARN=true; fi
    if ask_for "Terminator/ITerm2"; then I_TERM=false; else I_TERM=true; fi
    if ask_for "VS Code"; then I_VSCODE=false; else I_VSCODE=true; fi
    if ask_for "Docker & Compose"; then I_DOCKER=false; else I_DOCKER=true; fi

    if ask_for "Chrome"; then I_CHROME=false; else I_CHROME=true; fi
    if ask_for "Opera"; then I_OPERA=false; else I_OPERA=true; fi
}

# spin() {
#     total=0
#     while [ "$total" -ne 100 ]; do
#         load_update $total
#         let "total = total + 10"
#         sleep .1
#     done
# }

# load_update() {
#     max_asterisks=20
#     asterisks=''
#     percent=$1

#     if [ -z "$1" ]; then
#         percent=0
#     fi
#     let "n_asterisks = $percent * $max_asterisks / 100"
#     let "n_spaces = $max_asterisks - $n_asterisks"

#     for i in $(seq $max_asterisks); do
#         if [ "$i" -le $n_asterisks ]; then
#             asterisks+='#'
#         else
#             asterisks+=' '
#         fi
#     done
#     echo -ne "[$RED$asterisks$NC] ($percent%)\r"
# }

# showSelect() {
#   PS3='Install opera?'
#   option1="Opera"
#   options=($option1 "Option 2" "Option 3" "Quit")

#   select opt in "${options[@]}"
#   do
#     case $opt in
#         "Opera")
#             echo "Add opera"
#             option1="Tessttttt"
#             ;;
#         "Option 1")
#             echo "you chose choice 1"
#             ;;
#         "Option 2")
#             echo "you chose choice 2"
#             ;;
#         "Option 3")
#             echo "you chose choice $REPLY which is $opt"
#             ;;
#         "Quit")
#             break
#             ;;
#         *) echo "invalid option $REPLY";;
#         esac
#     done
# }

ask_for() {
    while true; do
        echo -ne "Do you wish to install ${YELLOW}$1${NC}? ${GREEN}y${NC}/${RED}n${NC} "
        read yn
        case $yn in
            [Yy]* ) return 1; exit;;
            [Nn]* ) return 0; exit;;
            * ) echo -e "Please answer ${GREEN}yes${NC} or ${RED}no${NC}.";;
        esac
    done
}

####################################################################################
###### MAIN CODE ###################################################################
####################################################################################
echo -e "${YELLOW}######################################################${NC}"
echo -e "Version: ${GREEN}$VERSION${NC}"
echo -e "Running on ${RED}$OS${NC}"
echo -e "${YELLOW}######################################################${NC}"

# ASK to install recommended or manual select
if ask_for "RECOMMENDED?"; then I_AUTO=false; else I_AUTO=true; fi
if [ "$I_AUTO" = false ]; then
    # Ask for every software to be installed
    ask_for_install
fi


if [ "$OS" == "linux" ]; then
    sudo apt-get update
    sudo apt-get install curl
    sudo apt-get install wget

    if $I_U_EXTRAS; then
        sudo add-apt-repository multiverse
        sudo apt-get update
        sudo apt-get install ubuntu-restricted-extras
    fi
    if $I_GIT; then
        sudo apt-get install git-all
    fi
    if $I_YARN; then
        npm i -g yarn
    fi
    if $I_TERM; then
        sudo apt-get install terminator
    fi
    if $I_VSCODE; then
        # sudo snap install --classic code
        # Alternative without snap
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        # sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        echo 'deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main' | sudo tee /etc/apt/sources.list.d/vscode.list
        sudo apt-get install apt-transport-https
        sudo apt-get update
        sudo apt-get install code # or code-insiders
        rm packages.microsoft.gpg
    fi
    if $I_DOCKER; then
        sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
        sudo apt-get update
        apt-cache policy docker-ce
        sudo apt-get install docker-ce
        sudo usermod -aG docker ${USER}
        # su - ${USER}

        # Get latest compose
        COMPOSE_URL=`curl https://github.com/docker/compose/releases/latest`
        COMPOSE_VER=${COMPOSE_URL%\"*}
        COMPOSE_VER=${COMPOSE_VER##*/}

        sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    if $I_CHROME; then
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
        sudo apt-get update
        sudo apt-get install google-chrome-stable
    fi
    if $I_OPERA; then
        wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
        sudo add-apt-repository "deb [arch=i386,amd64] https://deb.opera.com/opera-stable/ stable non-free"
        sudo apt-get install opera-stable
        # Patch opera to latest ffmpeg video codecs
        URL=`curl https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/latest`
        FFMPEGVER=${URL%\"*}
        FFMPEGVER=${FFMPEGVER##*/}
        FFMPEGZIP=${FFMPEGVER}-linux-x64.zip

        # download library
        curl -L -O https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/download/${FFMPEGVER}/${FFMPEGZIP}
        unzip ${FFMPEGZIP}
        rm ${FFMPEGZIP}

        # overwrite opera libffmpeg
        sudo mkdir /usr/lib/x86_64-linux-gnu/opera/lib_extra
        sudo mv libffmpeg.so /usr/lib/x86_64-linux-gnu/opera/lib_extra
    fi

    sudo apt-get autoremove
fi

# spin
