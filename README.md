# IfOnlyIWasRightHanded
A dynamic keyboard binding switcher for left handed gamers

This program uses ckb-next to switch keyboard modes depending on the window currently in focus

I designed this program because I am left handed and I hate having to rebind all my in game controls to accommodate for the fact that my mouse is the on left of my keyboard. Now I can just rebind the entire keyboard once, and itl work across games. Hence the name

# Requirements:
[ckb-next](https://github.com/ckb-next/ckb-next "ckb-next")

[xdotool](https://github.com/jordansissel/xdotool)

[pynput](https://pypi.org/project/pynput/)

<<<<<<< HEAD
[arguments](https://pypi.org/project/arguments/)

=======
>>>>>>> eed43fb7384c37aa288e0655f23bebf208b82c9a
# How to use

Create 3 different mode in ckb-next


The first one will be your default mode

The second will be the mode with the custom bindings

The third will be for typing while on a game window (can be a duplicate of the first mode)


Set all of your custom bindings on the second mode, and preferably add a certain color profile to this mode so you know which mode the board is in at all times

Run 'IfOnlyIWasRightHanded.py'

**There is currently a bug with either this program or the ckb-deamon where when it tries to switch modes via the deamon is switches to an empty mode. To work around this launch ckb-next, and select each mode once. This will enable the deamon to be able to switch to it via this script**

### Shebangs

Shebangs are a GameList argument you can use if a games window title is dynamic (Terraria for example)

If you put a '::' at the end of a games name in the GameList.txt file it will Shebang it and if the current window in focus contains the word that was shebanged it will switch modes, regardless of what else is in the title

### Arguments

`--debug`
Outputs debug information such as when it sees a window change, when it switches modes, when the GameList file is updated/changed


By default, pressing the Super key switches the mode to Normal. This is so if you open the app search while tabbed into a game it't switch to normal so you can type. You can disable this with `-ds` or `--DisableSuper`

# Future Plans

Better ckb-next support (aka AutoMapping Modes, working animations)

More gamelist arguments such as ["TypingKey", "Wildcard", "CursorCheck"]

Windows Support

GUI
