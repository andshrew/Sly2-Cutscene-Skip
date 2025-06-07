# Summary

The files in this directory are written in [CLPS2C](https://github.com/NiV-L-A/CLPS2C-Compiler/blob/master/CLPS2C-Documentation.txt) and should be compiled with the [CLPS2C-Compiler](https://github.com/NiV-L-A/CLPS2C-Compiler).

I would suggest using Visual Studio Code with the vscode-clps2c extension.

```
CLPS2C-Compiler.exe -i "Sly2-Cutscene-Skip-SCES52529#v2.01.clps2c" -p
```

This will output Pnach-formatted lines ready for [use with PCSX2](https://forums.pcsx2.net/Thread-Sticky-Important-Patching-Notes-1-7-4546-Pnach-2-0):

```
patch=1,EE,201E4CE0,extended,0803C4B4
patch=1,EE,200F12D0,extended,3C0B000F
patch=1,EE,200F12D4,extended,8D6B12C3
patch=1,EE,200F12D8,extended,51600005
patch=1,EE,200F12DC,extended,00000000
...
...
```

For compatibility with existing Sly 2 patches data is stored at memory locations `F12C0` to `F13FF`