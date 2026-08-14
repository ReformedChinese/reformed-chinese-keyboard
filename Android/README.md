# Reformed Chinese Keyboard — Android Installation Guide

### Step 1: Install Trime

Download the Trime APK:
- https://f-droid.org/packages/com.osfans.trime/

Open the APK to install, enable **"Install unknown apps"** in Android Settings if prompted. 

Open Trime, follow in-app instructions  Step 1 (**"Request storage permission"**) and Step 2 (**"Enable input method"**). I suggest you skip in-app instruction Step 3 ("Select Trime as your default input method")

### Step 2: Copy Files to Phone

Download all files from GitHub repository's **`Android/`** folder including **`Android/lua/`** except README.MD. Watch out that your downloads do not modify file extension e.g. changed to .txt and if so, simply rename files to remove .txt extension:

```
Android/
  lua/
    reformed_filter.lua
    reformed_commit_filter.lua
  reformed.schema.yaml
  reformed.dict.yaml
  rime.lua
  default.custom.yaml
  trime.custom.yaml
```

Trime creates the `/sdcard/rime/` folder automatically when installed. Under `/sdcard/rime/`, create a new folder named `lua`. Copy the contents of `Android/` into `/sdcard/rime/`, exactly matching the GitHub folder structure:
- Files in `Android/` → `/sdcard/rime/`
- Files in `Android/lua/` → `/sdcard/rime/lua/`

### Step 3: Deploy Trime

- Open Trime app → tap the **↺ circular arrow icon** (top right) to deploy
- Wait about 30 seconds for deployment to complete

### Step 4: Enable Trime Keyboard

- Under your Android **Settings**, go to **General management** → **Keyboard** (or just search "Keyboard")
- Enable **Trime** as well as **Keyboard button on navigation bar** if not already enabled
- In bottom right or left corner of your current keyboard, tap ⌨. Select Trime (Rimes with Your Keystrokes on Android)
- Now you can type 拼音 pinyin to output Reformed Chinese characters 🥳

## Toggling Lookalike Characters

Reformed Chinese keyboard can optionally output similar-looking characters or variants to substitute some Reformed characters that lack Unicode support and thus wouldn't display e.g. 亀 for [⿱⺈⿻口电](https://glyphwiki.org/glyph/u2ffb-u20ba5-u7535.svg) (Traditional: 龜)、誏 for [⿰訁上]( https://glyphwiki.org/glyph/u33069-uk.svg) (Traditional: 讓)

To toggle lookalike features:
1. Tap **…** on top left corner of Reformed Chinese keyboard
2. Enable or Disable:
   - **Lookalikes** (Default ON): If OFF, outputs corresponding Traditional characters instead. In cases where I couldn't find a suitable lookalike, will output Traditional regardless
   - **Indicate Lookalikes** (Default OFF): Shows ᴸ marker after lookalikes, requires Lookalikes ON to function
