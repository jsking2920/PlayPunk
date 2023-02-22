# PlayPunk

A Playdate game developed by Scott King

## Build instructions

Set up for VSCode + Windows only, from: https://github.com/Whitebrim/VSCode-PlaydateTemplate

0. **Unlock** `Build and Run (Simulator).ps1` file if it's locked: open properties and click unlock in the bottom of the window.  
0. If you've installed Playdate SDK to the default path (Documents folder) then just **run** `ADD_ENV_VARIABLE.cmd` to add env variables:  
    * PLAYDATE_SDK_PATH to Playdate SDK
    * Adds Playdate SDK's bin folder to PATH (if it is not already added) to create `pdc` shortcut  

    **!!!** If you've changed default path - edit 6th line in `ADD_ENV_VARIABLE.cmd`, then run it.  
    `set SDKPATH="YOUR CUSTOM SDK PATH HERE"`
    
    This should be done only once, you need to restart VSCode after this.  
0. ~~Edit your `Code.exe` execatable (VSCode) to run with **admin rights** by default. You can find this file if you input this path to your explorer: `%appdata%\..\Local\Programs\Microsoft VS Code`~~  
    Open PowerShell and change execution policy to RemoteSigned, so you can run closeSim.ps1 without admin rights:  
    Enter `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` into PowerShell then hit `Y`.
0. Open template folder with VSCode, **install recomended extensions** (popup will show in the lower right corner): `Lua`, `Lua Plus`. Then restart VSCode.  
0. To build and run in simulator use Ctrl + Shift + B

## Attributions:
- Forked from VSCode-PlaydateTemplate <br>
	(https://github.com/Whitebrim/VSCode-PlaydateTemplate) by Whitebrim


### TODOs
- Add screenshot/gif
- Add link to itch page
- Add link to dev log/portfolio page
- Add a license (MIT probably)
- Create a release
- Add credit to Paolo
- Add credit to Panic
- Improve install + build instructions
