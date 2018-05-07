# Duellink-PC-Bot
Simple bot with GUI using Autoit languange for farming Duellink PC. 

**Feature**  
  - Gate duel: duel any available legendary duelist in the gate. You must set key amount manually
  - Street duel: duel any duelist in the street and pickup loot

**Tutorial**

1. Install
  - Install Duellink PC from Steam
  - Download Autowin cheat from [here](https://ex.in.th)
    for now, this farm bot only compatible with Autowin  and skip PVE cheat for Duellink PC via Steam from that site. Read carefully
    and follow necessary step on that link
  - Install Autoit with full installation mode. You can get it in [here](https://www.autoitscript.com/site/autoit/downloads/)
2. Configuration
  - Open *DuelLinksConfiguration.exe* in `C:\Program Files (x86)\Steam\steamapps\common\Yu-Gi-Oh! Duel Links`. Disable fullscreen and set resolution
    to 1280x720
  - Make sure four area tabs in lower Duellink screen that lead to four different areas(gate, duel, card shop, card studio) is clearly visible. In my case
    I must hide the Windows Taskbar because its block Duellink's tab.

3. Run The bot
  - Open Duellink PC via Steam
  - Open *dlpc_gui.au3* whith SciTE Script editor that included form Autoit Installation.
  - Build the source code by press F7
  - Open dlpc.exe at your repository
  - Make sure Duellink main(middle) windows section is visible
  
**Caution**
  - If Bot stuck at some point please wait for less than 20 secons. The GUI will detect unexpected result and exit automatically.
  
**Next Update**
  - Option to non-cheater player
