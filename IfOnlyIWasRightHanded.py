#!python3
import pathlib, time, threading, os, subprocess
from pynput.keyboard import Key, Listener


class Keypress (threading.Thread):
   def __init__(self, threadID, name):
      threading.Thread.__init__(self)
      self.name = name
   def run(self):
      print("Starting " + self.name)

      with Listener(on_press = lambda event: KeypressRun(event)) as listener:
          listener.join()

      print("Exiting " + self.name)

class Cycle (threading.Thread):
   def __init__(self, threadID, name):
      threading.Thread.__init__(self)
      self.name = name
   def run(self):
      print("Starting " + self.name)

      CycleRun(Timer, TimerValue)

      print("Exiting " + self.name)

def CycleRun(Timer, TimerValue):
    global WindowName
    while True:
        Timer -= 1
        time.sleep(0.2)
        print(Timer)
        if Timer == 0:
            Timer = TimerValue

            UpdateGameList(GameList, AbPath)

            if sh("xdotool getactivewindow getwindowname") != WindowName:
                WindowName = sh("xdotool getactivewindow getwindowname")
                print(WindowName)
                ChangeLayout(WindowName)


def KeypressRun(key):
    global Mode
    if key == Key.enter:
        print("Enta")
        if Mode == 2:
            Mode = 3
            GameType()

        elif Mode == 3:
            Mode = 2
            Game()


    if key == Key.delete:
        # Stop listener
        return False

def Game():
    print("Game")
    os.system("echo mode 2 switch > /dev/input/ckb1/cmd;")

def Normal():
    print("Normal")
    os.system("echo mode 1 switch > /dev/input/ckb1/cmd;")

def GameType():
    print("GameType")
    os.system("echo mode 3 switch > /dev/input/ckb1/cmd;")

def UpdateGameList(GameList, AbPath):
    global ShebangedList, UnShebangedList
    GameList = str(AbPath) + "/GameList.txt" #Look at the current version of the GameList.txt file
    f = open(GameList, "r")

    ShebangedList, UnShebangedList = [], [] #Clear the prior GameList Arrays


    #print(f.read().splitlines())

    for x in f.read().splitlines(): #Split the GameList file via linebreak
        if x.endswith("::"):
            ShebangedList += [x[:-2]] #Add game to shebang list if it has a shebang
        else:
            UnShebangedList += [x] #If a game does not have a shebang add it to the normal list

    print(ShebangedList)
    print(UnShebangedList)

def ChangeLayout(WindowName):
    global Mode
    Layout = 0

    for x in ShebangedList:
        print(x)
        if x == WindowName:
            Mode, Layout = 2, 1
            Game()

    for x in UnShebangedList:
        print(x)
        if x == WindowName:
            Mode, Layout = 2, 1
            Game()

    if Layout == 0:
        Mode = 1
        Normal()

def sh(cmd, input=""):
    rst = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, input=input.encode("utf-8"))
    assert rst.returncode == 0, rst.stderr.decode("utf-8")
    return rst.stdout.decode("utf-8")[:-1]


WindowName = sh("xdotool getactivewindow getwindowname")

AbPath = pathlib.Path(__file__).parent.resolve()

ShebangedList, UnShebangedList = [], []

GameList = str(AbPath) + "/GameList.txt"
UpdateGameList(GameList, AbPath)

print(AbPath)

TimerValue = 4
Timer = 4

Mode = 1





Keypress = Keypress(1, "Keypress")
Cycle = Cycle(2, "Cycle")
Keypress.start()
Cycle.start()

#with Listener(on_press = lambda event: show(event)) as listener:
#    listener.join()
