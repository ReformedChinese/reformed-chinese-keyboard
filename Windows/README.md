# Reformed Chinese Keyboard - Windows Installation Guide

### Step 1: Install Weasel

下載 Download the latest compatible version of 小狼毫 Weasel under Windows section:

- https://rime.im/download/

Open the downloaded Weasel installer .exe file and complete installation

### Step 2: Download this GitHub repo

From [reformed-chinese-keyboard](https://github.com/ReformedChinese/reformed-chinese-keyboard) GitHub repo, click the green `Code` button. Under `Local` click `Download ZIP`

Extract .zip file. If you lack software to extract, I suggest [7-Zip](https://www.7-zip.org/download.html)

### Step 3: Install Reformed Chinese keyboard

In your extracted reformed-chinese-keyboard folder, go to `Windows` subfolder and double-click `INSTALL_WINDOWS.bat` which installs Reformed Chinese keyboard for you

Now you can type 拼音 pinyin to output Reformed Chinese characters 🥳


## Toggling Lookalike Characters

Reformed Chinese keyboard can optionally output similar-looking characters or variants to substitute some Reformed characters that lack Unicode support and thus wouldn't display e.g. 亀 for [⿱⺈⿻口电](https://glyphwiki.org/glyph/u2ffb-u20ba5-u7535.svg) (Traditional: 龜)、誏 for [⿰訁上]( https://glyphwiki.org/glyph/u33069-uk.svg) (Traditional: 讓)

To toggle lookalike features:
1. In Reformed Chinese keyboard, press **Ctrl** + **`**
2. Enable or Disable:
   - **Lookalikes** (Default ON): If OFF, outputs corresponding Traditional characters instead. In cases where I couldn't find a suitable lookalike, will output Traditional regardless
   - **Indicate Lookalikes** (Default OFF): Shows ᴸ marker after lookalikes, requires Lookalikes ON to function

**For Weasel (小狼毫) - Windows Rime implementation**

## Quick Installation (Automatic)

**Download the entire `Windows` folder, then double-click `INSTALL_WINDOWS.bat`** - it does everything automatically

> ⚠️ You must have the **entire `Windows` folder** (not just `INSTALL_WINDOWS.bat`) — the installer copies Reformed Chinese files from that folder to Rime.

The installer will:
- ✅ Check if Weasel is installed (guide you to install if needed). Once directed, click 下載 of the latest Weasel (小狼毫) version. Click the downloaded installer.exe.
- ✅ Copy all Reformed Chinese files to the correct locations
- ✅ Deploy Lua filters with proper UTF-8 encoding
- ✅ Set Reformed Chinese as your default input method
- ✅ Redeploy Weasel automatically

**Installation takes 5-10 minutes.**

## Step-by-Step

1. **Download this repository** (as ZIP or clone with Git) — you need the entire `Windows` folder, not just the `.bat` file
2. **Navigate to the `Windows` folder**
3. **Double-click `INSTALL_WINDOWS.bat`**
4. **Follow the prompts**:
   - If Weasel is not installed, the installer will open the download page
   - Install Weasel, then run `INSTALL_WINDOWS.bat` again
5. **Start typing!**
   - Press **Ctrl+Shift** or **Ctrl+Space** to activate
   - Type pinyin to get Reformed Chinese characters

## Quick Start Guide

- **Activate keyboard**: Press **Ctrl+Shift** or **Ctrl+Space**
- **Switch mode**: Press **Shift** to toggle Chinese ⇄ English
- **View candidates**: Use number keys (1-9) to select characters
- **Page through options**: Use **-** and **=** keys
- **Settings**: Right-click the Weasel tray icon (中)

## Toggling Lookalike Characters

Reformed Chinese includes optional lookalike characters for traditional characters without proper Reformed Unicode support.

To toggle lookalike features:
1. While typing, press **F4** or **Ctrl+`** to open the menu
2. Find switches:
   - **Use Lookalikes** (使用形似字) - Toggle lookalike substitution (Default: ON)
   - **Indicate Lookalikes** (標示形似字) - Show ᴸ marker after lookalikes (Default: OFF)
