# Sly 2: Band of Thieves Cutscene and FMV Skip

An [emulated version of Sly 2 was released](https://store.playstation.com/concept/10010691) in late 2024 under the PlayStation Classics programme for both the PS4 and PS5.  

The release included a unique feature which enabled you to skip most cutscenes and FMVs. Unfortunately the feature was later removed from the release in update v1.01.  

This repository contains a re-implementation of this feature in a format that is compatible with the PCSX2 emulator patching system. It is directly based on the method used in the official release. Any bugs or limitations which existed in that will also exist in this; with likely probability of even more issues existing on the basis that I am not an experienced MIPS assembly programmer!  

Someone with more experience of both Sly 2 modding and PCSX2 patch creation may be able to significantly improve on this.

### Acknowledgements
Credit for the skip method belongs entirely to those working for PlayStation on these classic re-releases. Thank you for the work you're doing.

### Video Demonstration

<p align="center"><a href="https://www.youtube.com/watch?v=8faEAomDcf0" target="_blank"><img src="https://img.youtube.com/vi/8faEAomDcf0/hqdefault.jpg"/></a><br>
<a href="https://www.youtube.com/watch?v=8faEAomDcf0" target="_blank">https://www.youtube.com/watch?v=8faEAomDcf0</a></p>

## How to use

Download the appropriate patch Pnach file for your version of the game from the `PCSX2-Pnach` directory or from the [Releases page](https://github.com/andshrew/Sly2-Cutscene-Skip/releases). Save it to your PCSX2 `patches` directory, and then enable the Cutscene and FMV skip in the `Patches` section of the `Game Properties` within PCSX2.

Push the SELECT button to skip cutscenes and FMVs.

As mentioned above, there were issues that can be caused from skipping some cutscenes too early; and some cutscenes cannot be skipped. Some examples of issues which were reported for the official implementation include:  

> * Episode 4: Eavesdrop on Contessa - Last cutscene. This just doesn't spawn the Train Hack job trigger. This is preventable by waiting for Bentley to turn around fully in his monologue.  
> * Episode 6: Aerial Assault - First cutscene on the train. The chopper doesn't get into position correctly and it becomes impossible to progress  
> * Skipping a few cutscenes on the first possible frame can end up in a softlock, usually the ones ending a job. (Steal a Tuxedo, Cabin Crimes)


## Additional Detail

The `PS2HD` directory contains the cutscene patch scripts from the official PS4 release. There is some commentary from the developers which explains the idea behind the skip method.

The `src` directory contains my source code for this re-implementation of the skip method. I created it using the extremely useful [CLPS2C](https://github.com/NiV-L-A/CLPS2C-Compiler).  

For compatibility with existing Sly 2 patches data is stored at memory locations `F12C0` to `F13FF`

### Differences in implementation

The original implementation was triggered by pressing the START button, and had what appears to be a system for delaying when a skip attempt would happen after pressing the button (perhaps to stop accidental skips).  

In this implementation I have used the SELECT button to trigger the skip. I have not attempted to implement a system that would require you to hold the button for an amount of time before skipping, however using the SELECT button should hopefully result in it being less likely that you accidentally skip through a cutscene.  

### Misc observations

When the feature was discovered in the official release, there were questions around whether it was intended or if it had been left in by mistake. From the way that it is presented in the patch file, it does appear that it was specifically added as a quality of life enhancement and was not a debug feature that was accidentally left in the v1.00 release. The actual functionality for the skip still exists in the file from the v1.01 version, but the hooks to enable it were disabled. Hopefully this may mean that there is still a chance that an improved version of the feature will return to the official release at some point in future.