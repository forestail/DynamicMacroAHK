# DynamicMacroAHK

This is an AutoHotKey implementation of [Toshiyuki Masui Ph.D](https://github.com/masui) 's "Dynamic Macro" written by Emacs lisp.
This AHK script allows to execute Dynamic Macro function at all application on Windows.

Reference: http://www.pitecan.com/DynamicMacro/


## How to use
### Requirement
* [AutoHotKey](https://www.autohotkey.com/) must be installed.

* The script cannot be compiled because it uses `KeyHistory` of AutoHotKey.

### Startup and Operation
* Double-click `DynamicMacro.ahk` to run it.
* When you press the hotkey assigned by `InvokeHotKey` (default is `Ctrl+T`) in the following configuration, the macro will find a repetition from the keystrokes up to that point and execute it.
* If a repetition is not found, the macro looks for one based on predicted keystrokes.
  * First, it searches for <img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BX%7D%5Cmathbf%7BY%7D%5Cmathbf%7BX%7D" 
alt="\mathbf{X}\mathbf{Y}\mathbf{X}"> from keystrokes and completes it by predicting <img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BY%7D" 
alt="\mathbf{Y}">.
  * Whenever a hotkey is pressed again, <img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BX%7D%5Cmathbf%7BY%7D" 
alt="\mathbf{X}\mathbf{Y}"> is automatically sended.
* Pressing the hotkey assigned by `ResetHotKey` (default is `ESC`) in the settings below will clear the history of previous keystrokes and delete any repeated keystrokes that have been retained.


### Configuration

#### Hotkey
Set hotkeys in the following parts of `DynamicMacro.ini`. The meaning of each command is as follows.
```
InvokeHotKey=^t
PredictHotKey=^y
ResetHotKey=~esc
PrevRepeatHotKey=^F9
PrevPredictHotKey=^F10
```

| # | Command          | Default HK    | Functional Overview                                 |
|---|-------------------|--------------|------------------------------------------|
| 1 | InvokeHotKey      | ^t           | Automatic determination and execution of repetitions or predictions.     |
| 2 | PredictHotKey     | ^y           | Specify the prediction mode and run.                 |
| 3 | ResetHotKey       | ~esc         | Clear key history.                         |
| 4 | PrevRepeatHotKey  | ^F9          | Re-execute previous repeat keystrokes.           |
| 5 | PrevPredictHotKey | ^F10         | Predictive mode re-run at the last time #1 was run. |

* #3 actively clears the key history and was implemented in consideration of the fact that this DynamicMacroAHK works throughout the OS, not in a specific editor.

* #4 will re-execute the last keystroke entered repeatedly when executed, even if another keystroke was sended after the repeat execution.

* #5 is a command to re-execute in predictive mode after manually undo if repetition mode was executed.



#### Logging
In order to analyze usage, a logging function is provided.
To enable logs, configure the following part of `DynamicMacro.ini`.
```
EnableLog=0
LogPath=DMlog.txt
```

If `EnableLog` is set to 1, logs are output to the file in `LogPath`. The log file can be specified as an absolute path or a relative path. In case of relative path, the starting point is the directory where DynamicMacro.ahk exists.

The logs are in CSV format, and the meaning of each column is as follows

| Column    | Content                                      | Example                  |
|-------*----|---------------------------------------------|----------------------------|
| 1st column | Timestamp                                   | 2021/07/17 01:01:01        |
| 2nd column | Type                                  | Reset or Repeat or Predict |
| 3rd column | Number of sended keys (Y in XYX for Predict) | 3                          |
| 4th column | Number of X keys in XYX for Predict       | 2                          |



## How it works
* Windows default notepad

![DynamicMacroAHK](https://user-images.githubusercontent.com/11771/125603690-31f4a997-b305-469b-b568-439422401381.gif)

* Excel

![DynamicMacroAHK_Excel](https://user-images.githubusercontent.com/11771/125603711-8d9fd7e4-ef86-4e94-9117-44a5e673c7f1.gif)

* Rename in Explorer

![DynamicMacroAHK_File](https://user-images.githubusercontent.com/11771/125621562-6e6292f1-d931-4fd2-9f9c-ee2f2a4226cb.gif)
