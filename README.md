# DynamicMacroAHK
増井俊之先生のDynamic MacroのAuto Hot Key  実装。

参考：http://www.pitecan.com/DynamicMacro/

2021/07/12	公開 by forestail

※呼び出しホットキーのデフォルトは[Ctrl + t]になっているので、好みのものに変更してください。
■増井先生の論文にあって実装できていないもの
　・繰り返し検知が意図しないものだった場合、予測モードに切り替える機能
■その他
　・特定のエディタではなくOS全体で機能する点、AutoHotKeyの仕様による制限などを考慮し、能動的にキー履歴をクリアする機能を付けました。
　　デフォルトでは[ESC]に割り当てています。
