#!python3
import pathlib, time, threading, os, subprocess, arguments, sys
from pynput.keyboard import Key, Listener
global debug

class Keypress (threading.Thread): #Thread for TypingKey Check
   def __init__(self, threadID, name):
      threading.Thread.__init__(self)
      self.name = name
   def run(self):
      print("Started " + self.name)

      with Listener(on_press = lambda event: KeypressRun(event)) as listener:
          listener.join()

      print("Exiting " + self.name)

class Cycle (threading.Thread): #Thread for while loop
   def __init__(self, threadID, name, StartFile, GameList):
      threading.Thread.__init__(self)
      self.name = name
   def run(self):
      print("Started " + self.name)

      CycleRun(Timer, TimerValue, StartFile, GameList)

      print("Exiting " + self.name)

def CycleRun(Timer, TimerValue, StartFile, GameList):
    global WindowName
    while True:
        Timer -= 1
        time.sleep(0.2)
        if Timer == 0:
            Timer = TimerValue

            if StartFile != sh("cat {0}".format(GameList)):
                UpdateGameList(GameList, AbPath)

            if sh("xdotool getactivewindow getwindowname") != WindowName: #If last known window title is not current update the string
                WindowName = sh("xdotool getactivewindow getwindowname")
                if debug == True:
                    print("Window Changed\nNew Window: {0}".format(WindowName))

                ChangeLayout(WindowName)


def KeypressRun(key):
    global Mode
    if key == Key.enter:
        if debug == True:
            print("Enter Key has been pressed")

        if Mode == 2:
            Mode = 3
            ModeSwitch("GameType")

        elif Mode == 3:
            Mode = 2
            ModeSwitch("Game")


    if key == Key.delete:
        # Stop listener
        return False

def ModeSwitch(mode):
    if mode == "Game":
        os.system("echo mode 2 switch > /dev/input/ckb1/cmd;")
    elif mode == "Normal":
        os.system("echo mode 1 switch > /dev/input/ckb1/cmd;")
    elif mode == "GameType":
        os.system("echo mode 3 switch > /dev/input/ckb1/cmd;")

    if debug == True:
        print("Mode Switched to: {0}".format(mode))

def UpdateGameList(GameList, AbPath):
    global ShebangedList, UnShebangedList
    GameList = str(AbPath) + "/GameList.txt" #Look at the current version of the GameList.txt file
    f = open(GameList, "r")

    ShebangedList, UnShebangedList = [], [] #Clear the prior GameList Arrays

    for x in f.read().splitlines(): #Split the GameList file via linebreak
        if x.endswith("::"):
            ShebangedList += [x[:-2]] #Add game to shebang list if it has a shebang
        else:
            UnShebangedList += [x] #If a game does not have a shebang add it to the normal list

    if debug == True:
        print(ShebangedList)
        print(UnShebangedList)

def ChangeLayout(WindowName):
    global Mode
    Layout = 0

    for x in ShebangedList:
        if x in WindowName: #If shebanged gamename is in the window title
            Mode, Layout = 2, 1
            ModeSwitch("Game")

    for x in UnShebangedList: #If window title in GameList
        if x == WindowName:
            Mode, Layout = 2, 1
            ModeSwitch("Game")

    if Layout == 0:
        Mode = 1
        ModeSwitch("Normal")

def sh(cmd, input=""):
    rst = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, input=input.encode("utf-8"))
    assert rst.returncode == 0, rst.stderr.decode("utf-8")
    return rst.stdout.decode("utf-8")[:-1]

ShebangedList, UnShebangedList = [], []

debug = False

Mode = 1
TimerValue = 4
Timer = 4

WindowName = sh("xdotool getactivewindow getwindowname")

AbPath = pathlib.Path(__file__).parent.resolve()
GameList = str(AbPath) + "/GameList.txt"

StartFile = sh("cat {0}".format(GameList))

if __name__ == "__main__":
    UpdateGameList(GameList, AbPath)

    try:
        if str(sys.argv[1]) == "debug":
            print("Debug mode enabled")
            debug = True
    except:
        None

    Keypress = Keypress(1, "Keypress")
    Cycle = Cycle(2, "Cycle", StartFile, GameList)
    Keypress.start()
    Cycle.start()
