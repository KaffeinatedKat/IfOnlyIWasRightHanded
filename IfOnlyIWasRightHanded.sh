#!/bin/bash

#Check if the GameList.txt file exists in the users home directory, if not create one
if [[ `ls -l $HOME/GameList.txt` == *"No such file or directory"* ]]; then
  touch $HOME/GameList.txt
fi

#GameList file
GameList=$HOME/GameList.txt

#Get title of current window in focus and put it into a string and an array
Window=`xdotool getactivewindow getwindowname`;
WindowArray=($Window)


#Set keyboard to 'Normal' layout
Normal () {
	echo mode 1 switch > /dev/input/ckb1/cmd;

  if [[ $1 == "all" ]]; then
    echo Normal;
  fi
}

#Set keyboard to 'Game' layout
Game () {
	echo mode 2 switch > /dev/input/ckb1/cmd;

  if [[ $1 == "all" ]]; then
    echo Game;
  fi
}

#Look at the current window title and compare it to the GameList and update the Layout acoordingly
ChangeLayout () {
  Layout="unset"
	Window=`xdotool getactivewindow getwindowname`;
	WindowArray=($Window)
	for x in "${ShabangedList[@]}"; do
		if echo "${WindowArray[@]}" | fgrep --word-regexp "$x"; then
			Game;
			Layout="set"
		fi
	done

  for x in "${UnShabangedList[@]}"; do
    if [[ "$x" == "${WindowArray[@]}" ]]; then
      Game;
      Layout="set";
    fi
  done

	if [[ $Layout == "set" ]]; then
		:
  elif [[ $Window == "" ]]; then #Prevents windows with no title from triggering game mode such as steam setting dropdowns
       Normal;
	else
		Normal;
	fi

  if [[ $1 == "all" ]]; then
    echo "Window has changed:"
    echo """Current Window: ${Window}
-------------------------------------------------->""";
    fi
}

#Update the GameList Variable if the file is changed
UpdateGameList () {

    #Define the vars
    ShabangedList=()
    UnShabangedList=()

    #Update the window title it checks to see if it has changed
    Start=`cat $GameList`;

    #Put the game list file into an array
    mapfile -t shabanged < $GameList

    #Add the games into either games with or without a shebang
    for x in "${shabanged[@]}"; do
        if [[ $x == *:: ]]; then
            ShabangedList+=("${x%??}")
        else
            UnShabangedList+=("${x}")
        fi
    done

    if [[ $1 == "all" ]]; then
        echo "GameList updated:"
        echo "Games with a Shebang: ${ShabangedList[@]}"
        echo "Games without a Shebang: ${UnShabangedList[@]}"
    fi

    ChangeLayout $debug;

}

#Close ckb-next, enter active mode on the deamon, then switch to the normal layout
killall ckb-next;
sleep 0.2;
echo active > /dev/input/ckb1/cmd;
Normal;

while getopts ":d:" arg; do
  case $arg in
    d) debug=$OPTARG;;
  esac
done

echo $debug;
if [[ $debug == "" ]]; then
  :
elif [[ $debug != "all" ]]; then
  echo "Invalid -d OPTARG";
  exit 1;
fi

UpdateGameList $debug;

while [ true ];
do

	#Check if the GameList file has updated, if so update the array with the new list
	if [[ $Start != `cat $GameList` ]]; then
		UpdateGameList $debug;
	fi

	#Get the name of the current window in focus, then update the keyboard layout accordingly
	if [[ $Window != `xdotool getactivewindow getwindowname` ]]; then
		ChangeLayout $debug;
	fi
done
