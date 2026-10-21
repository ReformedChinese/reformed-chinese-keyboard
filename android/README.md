# Reformed Chinese Keyboard for Android Installation Guide

### Step 1: Download this GitHub repo

On this GitHub repo [reformed-chinese-keyboard](https://github.com/ReformedChinese/reformed-chinese-keyboard), tap the green **Code** button and then tap **Download ZIP**. A "File downloaded" pop-up (or similar pop-up depending on browser) will appear, tap **Open** or open from your Downloads

![Download ZIP](../media/trime/trime1.png)

Tap **Extract**

![Extract ZIP](../media/trime/trime2.png)

### Step 2: Install Trime

Access https://f-droid.org/packages/com.osfans.trime/. Under the latest suggested version, tap **Download APK** and open

![Download APK](../media/trime/trime3.png)

You may see a pop-up warning "your phone currently isn't allowed to install unknown apps". If so, tap **Settings**. Enable **Allow permission** then in the new pop-up, tap **Install**

![Settings](../media/trime/trime4.png)

![Allow permission](../media/trime/trime5.png)

In the new pop-up that appears once Trime app is installed, tap **Open**

![App installed](../media/trime/trime6.png)

### Step 3: Configure Trime

Choose **Sync from external storage** and tap **SELECT EXTERNAL DATA DIRECTORY...**

![Sync from external](../media/trime/trime7.png)

Navigate to `android` folder under your extracted `reformed-chinese-keyboard-main` (Step 1). Inside `android` folder, tap **USE THIS FOLDER**

![USE THIS FOLDER](../media/trime/trime8.png)

In the new pop-up "Allow Trime to access folder?", tap **ALLOW**. You will see "Data folder imported successfully", tap **NEXT**

![Allow Trime](../media/trime/trime9.png)

![Data folder imported](../media/trime/trime10.png)

Tap **ENABLE INPUT METHOD** which will open **Keyboard** settings

![Data folder imported](../media/trime/trime11.png)

Enable both **Trime** and **Keyboard button on navigation bar** if the latter isn't already enabled

![Enable Trime](../media/trime/trime12.png)

In top-left of **Keyboard** settings, tap **<** to go back. Tap **Next**

![Tap <](../media/trime/trime13.png)

![NEXT](../media/trime/trime14.png)

Decide whether you'd like to set Trime as your default input method. I recommend tapping **SKIP** which in the next pop-up tap **OK, THANKS** 

![SKIP](../media/trime/trime15.png)

![OK THANKS](../media/trime/trime16.png)

In "No Notification Permission" pop-up, decide whether you'd like Trime notifications and choose either **CANCEL** or **GRANT PERMISSION**

![Notifications](../media/trime/trime17.png)

At the top, tap the circular arrow icon (**↺**) to deploy so you can finally type Reformed Chinese characters
 
![Deploy](../media/trime/trime18.png)

### Step 4: Verify Trime

On your Android keyboard, tap **⌨** icon located at bottom right or left corner

![⌨ icon](../media/trime/trime19.png)

In "Choose input method" pop-up, select **Trime**

![Choose input method](../media/trime/trime20.png)

Type some 拼音 Pinyin to verify you can output Reformed Chinese characters e.g. "chacanting" for 茶湌庁, "guayulin" for 刮魚魿, "xuanyuanjian" for 軒䡇剣. Tap the correct candidate characters to output

![Input](../media/trime/trime21.png)

![Output](../media/trime/trime22.png)

If you're able to output Reformed Chinese characters such as in screenshot above, CONGRATULATIONS! You have verified you can type Reformed Chinese characters, here's a [list of other Reformed characters](https://docs.google.com/spreadsheets/d/1lK39EUCqPZukM4NCPzidQg1L0zzKc6zavR6WR9Z6XZQ/) you can try typing 🥳 Woo!

## Toggling Lookalike Characters

Reformed Chinese keyboard can optionally output similar-looking characters or variants to substitute some Reformed characters that lack Unicode support and thus wouldn't display e.g. 亀 for [⿱⺈⿻口电](https://glyphwiki.org/glyph/u2ffb-u20ba5-u7535.svg) (Traditional: 龜)、誏 for [⿰訁上]( https://glyphwiki.org/glyph/u33069-uk.svg) (Traditional: 讓)、㒷 for [⿱丿㒷]( https://glyphwiki.org/glyph/u2a94c-var-002.svg) (Traditional: 興)

To toggle lookalike features:

1. With Trime input method selected, tap **⋯** at top-left of keyboard to see lookalike options

![Tap ⋯](../media/trime/trime23.png)

2. The `ON`/`OFF` on left-side of `→` indicate what is currently enabled or disabled. Tap **L** or **I** option icons to toggle corresponding feature

![Toggleable](../media/trime/trime24.png)

3. Enable or Disable:
   - **Lookalikes** (Default `ON`): If `OFF`, outputs corresponding Traditional characters instead. In cases where I couldn't find a suitable lookalike, will output Traditional regardless

      ![Lookalikes](../media/trime/trime25.png)

   - **Indicate Lookalikes** (Default `OFF`): Shows `ᴸ` marker after each lookalike. **Requires** `Lookalikes ON` to function

      ![Indicate Lookalikes](../media/trime/trime26.png)