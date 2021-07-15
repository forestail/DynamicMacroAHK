# DynamicMacroAHK
[増井俊之氏](https://github.com/masui)のDynamic MacroのAutoHotKey実装。

参考：http://www.pitecan.com/DynamicMacro/

### 使い方

`DynamicMacro.ini`の以下の部分でホットキーを設定してください。
```
InvokeHotKey=^t
ResetHotKey=~esc
```

`InvokeHotKey`で割り当てたホットキーを入力すると、その時点までのキー操作から繰り返しを見つけてそれを再生します。<br/>
繰り返しが見つからない場合は、キー操作を補完して繰り返しになるものを探します。<br/>
まずキー操作から<img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BX%7D%5Cmathbf%7BY%7D%5Cmathbf%7BX%7D" 
alt="\mathbf{X}\mathbf{Y}\mathbf{X}">を探し、<img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BY%7D" 
alt="\mathbf{Y}">を補完します、以降続けてホットキーが入力されると<img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BX%7D%5Cmathbf%7BY%7D" 
alt="\mathbf{X}\mathbf{Y}">を再生します。

`ResetHotKey`で割り当てたホットキーを入力すると、これまでのキー入力履歴をクリアします。保持している繰り返しキー入力も削除します。


### 増井先生の論文にあって実装できていないもの
* 繰り返し検知が意図しないものだった場合、予測モードに切り替える機能

### その他
* 特定のエディタではなくOS全体で機能する点、AutoHotKeyの仕様による制限などを考慮し、能動的にキー履歴をクリアする機能を付けました。デフォルトでは[ESC]に割り当てています。

### 動作している様子
* Windows標準のメモ帳

![DynamicMacroAHK](https://user-images.githubusercontent.com/11771/125603690-31f4a997-b305-469b-b568-439422401381.gif)

* Excel

![DynamicMacroAHK_Excel](https://user-images.githubusercontent.com/11771/125603711-8d9fd7e4-ef86-4e94-9117-44a5e673c7f1.gif)

* ファイルリネーム

![DynamicMacroAHK_File](https://user-images.githubusercontent.com/11771/125621562-6e6292f1-d931-4fd2-9f9c-ee2f2a4226cb.gif)
