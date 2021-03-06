# IfOnlyIWasRightHanded
A dynamic keyboard binding switcher for left handed gamers

Uses ckb-next or key-mapper to switch keyboard layouts to one that rebinds default game bindings such as WASD to your custom ones if you are left handed and use your mouse on the other side of the keyboard.

# Requirements:
[key-mapper](https://github.com/sezanzeb/key-mapper "key-mapper")


or

[ckb-next](https://github.com/ckb-next/ckb-next "ckb-next")

xdotool

your current user needs to be in the "input" group if you are using key-mapper

# How to use

### with ckb-next

Make 2 keyboard modes for your keyboard in ckb-next

Make the mode you use for normal typing the first mode and the one you custom bound your buttons on the second

Put the window names of all your games in the GameList.txt file

Run IfOnlyIWasRightHanded.sh with "-m ckb"

### with key-mapper (the default)

add your current user to the 'input' group if not already

Put the window names of all your games in the GameList.txt file

Run IfOnlyIWasRightHanded.sh and follow the setup 

**The script will ask if you want to install key-mapper if it is not currently installed, the installer only works on Debian based systems, for other distros reference the [readme](https://github.com/sezanzeb/key-mapper#installation "readme")**

### Shebangs

Shebangs are a GameList argument you can use if a games window title changes a lot (Terraria for example)

If you put a '::' at the end of a games name in the GameList.txt file it will Shebang it and if the current window in focus contains that shebanged name game mode will activate (Eg. Put 'Terraria::' in the GameList.txt file)

### Debug Mode

Debug mode prints the current window name, the current keyboard layout mode when a new window is put in focus to the console

If the GameList.txt file is updated and debug mode is on the new Gamelist will be printed to the console and then it will print the list of games with a shebang and without a shebang

You can enable debug mode by running the script with "-d all"

### ckb-next mode

ckb-next mode runs the program with ckb-next as the keyboard layout switcher instead of the defualt key-mapper, only use this if you have a keyboard that supports ckb-next

You can enable ckb-next mode by running the script with "-m ckb"

# What currently does and doesn't work
ckb-next and key-mapper support: Working

Dynamically switching modes if game is in focus: Working

File of game names to switch modes if name is list is the current window: Working

Updateable GameList file while program is running: Working

Animated lighting with ckb-next: Not Working

# Future Plans

Solution for in game text boxes

key-mapper autoinstall options for other distros

Better ckb-next support (aka AutoMapping Modes, working animations)

More gamelist arguments such as ["TypingKey", "Wildcard", "CursorCheck", "Refreshrate"]

Windows Support

GUI
