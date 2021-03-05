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
  echo Normal;
	echo mode 1 switch > /dev/input/ckb1/cmd;
}

#Set keyboard to 'Game' layout
Game () {
  echo Game;
	echo mode 2 switch > /dev/input/ckb1/cmd;
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
    elif [[ $Window == "" ]]; then
       Normal;
	else
		Normal;
	fi

    if [[ $1 == "debug" || $debug == "true" ]]; then
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

    if [[ $1 == "debug" || $debug == "true" ]]; then
        echo "GameList updated:"
        echo "Games with a Shebang: ${ShabangedList[@]}"
        echo "Games without a Shebang: ${UnShabangedList[@]}"
        ChangeLayout debug;
    else
        ChangeLayout;
    fi
}

#Close ckb-next, enter active mode on the deamon, then switch to the normal layout
killall ckb-next;
sleep 0.2;
echo active > /dev/input/ckb1/cmd;
Normal;

if [[ $1 == "debug" ]]; then
    debug="true";
    UpdateGameList debug;
else
    UpdateGameList;
fi


while [ true ];
do

	#Check if the GameList file has updated, if so update the array with the new list
	if [[ $Start != `cat $GameList` ]]; then
		UpdateGameList;
	fi

	#Get the name of the current window in focus, then update the keyboard layout accordingly
	if [[ $Window != `xdotool getactivewindow getwindowname` ]]; then
		ChangeLayout;
	fi
done
