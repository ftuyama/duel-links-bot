# Duellink-PC-Bot
Simple bot using Autoit languange for farming Duellink PC. This is active project and I check it daily.

**Tutorial**

1. Install
  - Install Duellink PC from Steam
  - Download Autowin cheat  
    for now, this farm bot only compatible with Autowin cheat for Duellink PC via Steam from [conom.org](http://conom.org/). Read carefully
    and follow necessary step on that link
  - Install Autoit with full installation mode. You can get it in [here](https://www.autoitscript.com/site/autoit/downloads/)
  - Donwload and install Advanced Pixel Search Library for Autoit from [here](https://www.autoitscript.com/forum/topic/126430-advanced-pixel-search-library/), put all files inside your repository. There is a help file in there in case you are
    interested.
2. Configuration
  - Open *DuelLinksConfiguration.exe* in `C:\Program Files (x86)\Steam\steamapps\common\Yu-Gi-Oh! Duel Links`. Disable fullscreen and set resolution
    to 800x450
  - Make sure four area tabs in lower Duellink screen that lead to four different areas(gate, duel, card shop, card studio) is clearly visible. In my case
    I must hide the Windows Taskbar because its block Duellink's tab.

3. Run The bot
  - Open Duellink PC via Steam
  - Open *dlpc.au3* whith SciTE Script editor that included form Autoit Installation.
  - For now There is two main feature function
    -`Gate_duel($arg)`
      Duel any legendary duellist inside gate until '$arg' cumulaive different legendary duellist.
    -'Street_duel($arg1,$arg2)'
      Duel any duelist included Standard duelist , vagabond, and legendary duelist available in the Street and collect orange
      exclamation mark that contain loot. '$arg1' is Duelworld, 0 for Yu-Gi-Oh 1 for Yu-Gi-Oh GX. '$arg2 is code area starting from 0 for duel gate
      area and 3 for Card shop area.
      
**Major BUg**
- If Vagabond offer friend recommendation bot will crash and you must manually select a friend and restart the bot.
