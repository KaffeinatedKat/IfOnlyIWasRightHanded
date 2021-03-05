# IfOnlyIWasRightHanded
A dynamic keyboard binding switcher for left handed gamers

Uses ckb-next to switch keyboard layouts to one that rebinds default game bindings such as WASD to your custom ones if you are left handed and use your mouse on the other side of the keyboard.

# Requirements:
ckb-next (and a keyboard that supports it)

xdotool

# How to use

Make 2 keyboard modes for your keyboard in ckb-next

Make the mode you use for normal typing the first mode and the one you custom bound your buttons on the second

Put the window names of all your games in the GameList.txt file

Run IfOnlyIWasRightHanded.sh 

### Shebangs

Shebangs are a GameList argument you can use if a games window title changes a lot (Terraria for example)

If you put a '::' at the end of a games name in the GameList.txt file it will Shebang it and if the current window in focus contains that shebanged name game mode will activate (Eg. Put 'Terraria::' in the GameList.txt file)

### Debug Mode

Debug mode prints the current window name, the current keyboard layout mode when a new window is put in focus

If the GameList.txt file is updated and debug mode is on the new Gamelist will be printed to the console and then it will print the list of games with a shebang and without a shebang

You can enable debug mode by putting "debug" as a command line argument for the bash script

# What currently does and doesn't work
Dynamically switching modes if game is in focus: Working

File of game names to switch modes if name is list is the current window: Working

Updateable GameList file while program is running: Working

Animated lighting with ckb-next: Not working


# Future Plans

Solution for in game text chat

xmodmap solution for rebinding keys if ckb-next doesn't support your keyboard

More gamelist arguments such as ["TypingKey", "Wildcard", "CursorCheck", "Refreshrate"]

Windows Support 

GUI
