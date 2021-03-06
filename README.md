# DynamicMacroAHK
[増井俊之氏](https://github.com/masui)のDynamic MacroのAutoHotKey実装です。<br/>
オリジナルはEmacs上で動作するマクロですが、AutoHotKeyで実装することにより、Windows上の全てのエディタ、アプリケーションで手軽にDynamic Macroを利用できます。

参考：http://www.pitecan.com/DynamicMacro/

紹介記事：https://forestail.com/programing/dynamic-macro-autohotkey/

## 使い方
### 必要なもの
* [AutoHotKey本体](https://www.autohotkey.com/)がインストールされていること

※ AutoHotKeyの`KeyHistory`を利用しているため、現状スクリプトをコンパイルした状態で使うことはできません。

### 起動と使い方
* `DynamicMacro.ahk`をダブルクリックして実行します。
* 下記設定の`InvokeHotKey`で割り当てたホットキー(デフォルトは`Ctrl+T`)を入力すると、その時点までのキー操作から繰り返しを見つけてそれをマクロ実行します。
* 繰り返しが見つからない場合は、キー操作を予測した上で繰り返しになるものを探します。
  * まずキー操作から<img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BX%7D%5Cmathbf%7BY%7D%5Cmathbf%7BX%7D" 
alt="\mathbf{X}\mathbf{Y}\mathbf{X}">を探し、<img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BY%7D" 
alt="\mathbf{Y}">を予測して補完します。
  * 以降続けてホットキーが入力されると<img src=
"https://render.githubusercontent.com/render/math?math=%5CLarge+%5Ctextstyle+%5Cmathbf%7BX%7D%5Cmathbf%7BY%7D" 
alt="\mathbf{X}\mathbf{Y}">をマクロ実行します。
* 下記設定の`ResetHotKey`で割り当てたホットキー(デフォルトは`ESC`)を入力すると、これまでのキー入力履歴をクリアし、保持している繰り返しキー入力も削除します。


### 設定

#### ホットキーの指定
`DynamicMacro.ini`の以下の部分でホットキーを設定してください。それぞれのコマンドの意味は下記の通りです。
```
InvokeHotKey=^t
PredictHotKey=^y
ResetHotKey=~esc
PrevRepeatHotKey=^F9
PrevPredictHotKey=^F10
```

| # | コマンド          | デフォルトHK | 機能概要                                 |
|---|-------------------|--------------|------------------------------------------|
| 1 | InvokeHotKey      | ^t           | 繰り返しまたは予測を自動判定して実行     |
| 2 | PredictHotKey     | ^y           | 予測モードを指定して実行                 |
| 3 | ResetHotKey       | ~esc         | キー履歴をクリア                         |
| 4 | PrevRepeatHotKey  | ^F9          | 前回の繰り返しキー操作を再実行           |
| 5 | PrevPredictHotKey | ^F10         | 前回#1を実行した時点での予測モード再実行 |

※#3は能動的にキー履歴をクリアするもので、このDynamicMacroが特定のエディタではなくOS全体で機能する点を考慮して実装したものです。

※#4は繰り返し実行後、別のキー操作をしていたとしても、実行すると前回繰り返し入力したキー操作を再度実行します。

※#5は#1を実行したときに予測モードを期待したのに繰り返し実行されてしまった場合に、その時点までCtrl+ZなどでUndoして、予測モードでやり直すコマンドです。



#### ログ機能
利用状況を分析するために、ログ出力機能を付けています。<br/>
ログを出力するには、`DynamicMacro.ini`の以下の部分を設定してください。
```
EnableLog=0
LogPath=DMlog.txt
```

`EnableLog`を1にすると、`LogPath`のファイルにログを出力します。ログファイルは絶対パスか相対パスで指定してください。相対パスの場合はDynamicMacro.ahkが存在するディレクトリを起点にします。

ログはCSV形式で、それぞれのカラムの意味は以下です。

| カラム    | 意味                                        | 例                         |
|-----------|---------------------------------------------|----------------------------|
| 第1カラム | 時刻                                        | 2021/07/17 01:01:01        |
| 第2カラム | 実行タイプ                                  | Reset or Repeat or Predict |
| 第3カラム | 挿入したキー(Predictの場合はXYXのY)のタイプ数 | 3                          |
| 第4カラム | Predictの場合のXYXのXのキータイプ数         | 2                          |



## 動作している様子
* Windows標準のメモ帳

![DynamicMacroAHK](https://user-images.githubusercontent.com/11771/125603690-31f4a997-b305-469b-b568-439422401381.gif)

* Excel

![DynamicMacroAHK_Excel](https://user-images.githubusercontent.com/11771/125603711-8d9fd7e4-ef86-4e94-9117-44a5e673c7f1.gif)

* ファイルリネーム

![DynamicMacroAHK_File](https://user-images.githubusercontent.com/11771/125621562-6e6292f1-d931-4fd2-9f9c-ee2f2a4226cb.gif)
