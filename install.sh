#!/bin/bash
readonly NC='\033[0m' # No Color
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'

# INSTALL VARIABLES
I_AUTO=false
I_GIT=true
I_TERM=true
I_VSCODE=true
I_U_EXTRAS=true

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
    if ask_for "Terminator/ITerm2"; then I_TERM=false; else I_TERM=true; fi
    if ask_for "VS Code"; then I_VSCODE=false; else I_VSCODE=true; fi
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

echo -e "Running on ${RED}$OS${NC}"

# ASK to install recommended or manual select
if ask_for "RECOMMENDED?"; then I_AUTO=false; else I_AUTO=true; fi
if [ "$I_AUTO" = false ]; then
    # Ask for every software to be installed
    ask_for_install
fi


if [ "$OS" == "linux" ]; then
    sudo apt-get update

    if $I_U_EXTRAS; then
        sudo add-apt-repository multiverse
        sudo apt-get install ubuntu-restricted-extras
    fi
    if $I_GIT; then
        sudo apt-get install git-all
    fi
    if $I_TERM; then
        sudo apt-get install terminator
    fi
fi

# spin
