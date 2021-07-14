# DynamicMacroAHK
[増井俊之氏](https://github.com/masui)のDynamic MacroのAutoHotKey実装。

参考：http://www.pitecan.com/DynamicMacro/



※呼び出しホットキーのデフォルトは[Ctrl + t]になっているので、好みのものに変更してください。

### 増井先生の論文にあって実装できていないもの
* 繰り返し検知が意図しないものだった場合、予測モードに切り替える機能

### その他
* 特定のエディタではなくOS全体で機能する点、AutoHotKeyの仕様による制限などを考慮し、能動的にキー履歴をクリアする機能を付けました。デフォルトでは[ESC]に割り当てています。

### 動作している様子
■ Windows標準のメモ帳

![DynamicMacroAHK](https://user-images.githubusercontent.com/11771/125603690-31f4a997-b305-469b-b568-439422401381.gif)

■ Excel

![DynamicMacroAHK_Excel](https://user-images.githubusercontent.com/11771/125603711-8d9fd7e4-ef86-4e94-9117-44a5e673c7f1.gif)
