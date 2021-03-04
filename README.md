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

# What currently does and doesn't work
Dynamically switching modes if game is in focus: Working

File of game names to switch modes if name is list is the current window: Working

Updateable GameList file while program is running: Working

Animated lighting with ckb-next: Not working


# Planned features for 1.0
Solution for in game text chat

xmodmap solution for rebinding keys if ckb-next doesn't support your keyboard

More pergame options with the gamelist file ["TypingKey", "Wildcard", "CursorCheck", "Refreshrate"]

# Future Plans
Windows Support 

GUI
