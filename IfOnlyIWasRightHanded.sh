#!/bin/bash

mapfile -t config < $(dirname $(readlink -f $0))/KeyMapper/.KeyMapper-config
keyboard="${config[1]}"

GameList=$(dirname $(readlink -f $0))/GameList.txt #Assign the location of the GameList.txt file to $GameList, this will create the file if it does not already exist

wd=$(dirname $(readlink -f $0))/ #Assign the directory this file is in to $wd

#Get title of current window in focus and put it into a string and an array
Window=`xdotool getactivewindow getwindowname`;
WindowArray=($Window)

while getopts ":d:m:" arg; do #Define GetOpts 
  case $arg in
    d) debug=$OPTARG #Define the -d (debug) argument
      if [[ $debug != "all" ]]; then
        echo "Invalid -d OPTARG {$OPTARG}";
        exit 1;
      fi;;
    m) mode=$OPTARG #Define the -m (mode) argument
      if [[ $mode != "ckb" ]]; then
        echo "Invalid -m OPTARG {$OPTARG}";
        exit 1;
      fi;;
  esac
done

Normal () { #Sets the keyboad layout to "Normal"
  if [[ $mode == "ckb" ]]; then #Change with ckb-next
    echo "ckb-next mode"
    echo mode 1 switch > /dev/input/ckb1/cmd;
  elif [[ $current != 'normal' ]]; then #Change with key-mapper
    echo "${keyboard}"
    key-mapper-control --command start --device "${config[1]}" --preset 'Normal'
    current='normal'
  fi

  if [[ $debug == "all" ]]; then
    echo $mode
    echo Normal;
  fi
}

Game () { #Sets the keyboard layout to "Game"
  if [[ $mode == "ckb" ]]; then #Change with ckb-next
    echo "ckb-next mode"
    echo mode 2 switch > /dev/input/ckb1/cmd;
  elif [[ $current != "game" ]]; then #Change with key-mapper
    key-mapper-control --command start --device "${config[1]}" --preset 'Game'
    current='game'
  fi

  if [[ $debug == "all" ]]; then
    echo Game;
  fi
}

function replace-line-in-file() {
    local file="$1"
    local line_num="$2"
    local replacement="$3"

    # Escape backslash, forward slash and ampersand for use as a sed replacement.
    replacement_escaped=$( echo "$replacement" | sed -e 's/[\/&]/\\&/g' )

    sed -i "${line_num}s/.*/$replacement_escaped/" "$file"
}


ChangeLayout () { #Look for current window title in GameList 
  Layout="unset" 
  Window=`xdotool getactivewindow getwindowname`;
  WindowArray=($Window)

  if [[ -n "$Window" ]]; then

    for x in "${ShabangedList[@]}"; do #Compare all Shebanged games with window title
  		if echo "${WindowArray[@]}" | fgrep --word-regexp "$x"; then
  			Game;
  			Layout="set"
  		fi
  	done

    for x in "${UnShabangedList[@]}"; do #Compare all non-shebanged games with window title
      if [[ "$x" == "${WindowArray[@]}" ]]; then
        Game;
        Layout="set";
      fi
    done

  	if [[ $Layout == "set" ]]; then
  		: #If the layout was set by one of the functions above do nothing
  	else
  		Normal; #If the layout was not set change to "Normal"
  	fi
  else
    Normal;
  fi

  if [[ $1 == "all" ]]; then #echo debug info if set
    echo "Window has changed"
    echo """Current Window: ${Window}
-------------------------------------------------->""";
  fi

  if [[ $2 == "ckb" ]]; then
    echo "Using ckb-next mode"
  fi
}

UpdateGameList () { #Put the contents of GameList.txt into the Shabanged and UnShabanged arrays
    ShabangedList=()
    UnShabangedList=()

    mapfile -t GameListArray < $GameList #Update the gamelist variable

    Start=`cat $GameList` || touch $(dirname $(readlink -f $0))/GameList.txt && Start=`cat $GameList` #cat the GameList, if it doesnt exists create it then cat it

    #Add the games into either games with or without a shebang
    for x in "${GameListArray[@]}"; do
        if [[ $x == *:: ]]; then
            ShabangedList+=("${x%??}") #Add games with :: at the end
        else
            UnShabangedList+=("${x}") #Add everything else
        fi
    done

    if [[ $1 == "all" ]]; then #Output debug info
        echo "GameList updated:"
        echo "Games with a Shebang: ${ShabangedList[@]}"
        echo "Games without a Shebang: ${UnShabangedList[@]}"
    fi

    ChangeLayout $debug $mode; #Run ChangeLayout with the updated GameList
}


Setup () {
  zenity --info --no-wrap --text  "Select your keyboard from the dropdown, set your custom bindings for games and name the preset 'Game', then close the Key Mapper window\n <b>Do not forget to save the preset before closing the Key Mapper window</b>\n\nIf your 'Game' preset already exists with your bindings just close the Key Mapper window"
  key-mapper-gtk
  replace-line-in-file "${wd}KeyMapper/.KeyMapper-config" 1 'Setup Game Profile: yes'
  devices=$(python3 "${wd}KeyMapper/GetDevices.py")
  IFS=',' read -r -a array <<< "$devices"
  number=-1
  for i in "${array[@]}"; do
    number=$((number+1))
    echo $number: $i
  done
  read -p "Which keyboard is yours? " board
  replace-line-in-file "${wd}KeyMapper/.KeyMapper-config" 2 "${array[$board]:2}"
  mapfile -t config < $(dirname $(readlink -f $0))/.KeyMapper-config
  cp "${wd}KeyMapper/Normal.json" $HOME/.config/key-mapper/presets/"${config[1]}"
}



if [[ $mode == "ckb" ]]; then
  #Close ckb-next, enter active mode on the deamon, then switch to the normal layout
  killall ckb-next;
  sleep 0.2;
  echo active > /dev/input/ckb1/cmd;
else
  if ! command -v key-mapper-control &> /dev/null; then #Check if key-mapper is installed
    read -p "key-mapper does not appear to be installed, would you like to install it now? (y/n) " -n 1 -r #if not ask if you want the script to install it
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit
    fi

    cd #Installing key-mapper(debain) from github
    sudo apt install git python3-setuptools
    git clone https://github.com/sezanzeb/key-mapper.git
    cd key-mapper; ./scripts/build.sh
    sudo apt install ./dist/key-mapper-0.7.0.deb
    cd $wd

  fi
fi


echo "${config[0]}"
if [[ "${config[0]}" == "Setup Game Profile: yes" ]] && [[ "${config[1]}" != "[insert yet another line here]" ]] && [[ "${config[1]}" != "" ]]; then
  :
else
  echo """[insert line here]
[insert yet another line here]""" > "${wd}KeyMapper/.KeyMapper-config"
  Setup;
fi


mapfile -t config < $(dirname $(readlink -f $0))/KeyMapper/.KeyMapper-config
Normal;
keyboard="${config[1]}"
UpdateGameList $debug $mode;

while [ true ];
do

	if [[ $Start != `cat $GameList` ]]; then #If the GameList file has been modified re-assign the GameList arrays
		UpdateGameList $debug $mode;
	fi

	#If the title of the current window changes check it with the GameList arrays
	if [[ $Window != `xdotool getactivewindow getwindowname` ]]; then
		ChangeLayout $debug $mode;
	fi
done
