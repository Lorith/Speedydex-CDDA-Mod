# Speedydex-CDDA-Mod
Allows you to increase your speed based on your dexterity.  Designed for use with mutations that give more dex, and/or stats through skills/kills mods to allow your character to become more inhuman over time.

On creating a character, it will open a configuration menu.  This menu will show examples of when you start gaining speed, as well as how much speed bonus you will have for the first few levels.  From this menu, you can edit both the minimum level of dexterity and the amount of speed gained per dexterity.  Once you close this menu, you cannot return back to it without save editing, so make sure you are happy with your choice before you hit done.

To add to an existing world, edit mods.json and include "speedydex" at the end, making sure the entry before it has a comma at the end.  The first time the script fires (per minute) it will open the configuration menu, and then it will consider your stats to see if it needs to increase your speed or not.