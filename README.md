<img width="1280" height="719" alt="image" src="https://github.com/user-attachments/assets/e707f30a-f386-4b04-83c5-e257ff3e3383" />

## Credits and Original Source
Based on [EasyTrainers](https://github.com/AviWind02/EasyTrainers) - Lua implementation of the original EasyTrainer mod.
Original EasyTrainer available on [Nexus Mods](https://www.nexusmods.com/cyberpunk2077/mods/23227).
All credits to the original authors for the base functionality.

## Features Introduced:
- **Professional & Friendly UI**: Completely revamped menu look for a modern and professional appearance.
- **Interactive Second Header**: Added a secondary header displaying version info, current menu name, and option count. Clicking the header title (Breadcrumb) allows for an instant return to the previous tab.
- **Hotkey System & Binding Manager**: A modern system for assigning keyboard shortcuts (hotkeys) directly to menu options.
    - **How to use**: Hover over any option to select it, then press **F+G+H** simultaneously.
    - **Status**: The row will show `[RELEASE F+G+H]`, followed by a blinking `[PRESS KEY TO BIND]`. Press any key to assign it. Success is confirmed with a green `[BIND: KEY]` message.
    - **Management**: A dedicated **Binding Menu** in settings allows you to preview shortcuts and quickly enable/disable them without clearing the binding.



### Built-in Cyberpunk-Style Font (Rajdhani-Bold.ttf)

This fork includes the bold and sharp **Rajdhani-Bold** font to give the trainer menu a true Night City aesthetic right out of the box.

#### Enable the custom font:
1. After installation open the CET config file:  
   `Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\config.json`

2. Find the `"font"` section and change the `"path"` value to:

   ```json
   "font": {
        "base_size": 24.0,
        "language": "Default",
        "oversample_horizontal": 3,
        "oversample_vertical": 1,
        "path": "Rajdhani-Bold.ttf"

## Change Log

### 1.0.0 Initial
- Base content from [EasyTrainers](https://github.com/AviWind02/EasyTrainers).
- Improved UI menu with a professional look.
- Added key binding system for options.

### 1.0.1 (Release)
- Added NPC Spawning system.
    - **Advanced NPC Spawning Menu**: A powerful and intuitive interface for managing NPC spawns.
        - **Select NPC**: Browse enemies by faction using organized submenus.
        - **Selected NPC**: Clearly displays the currently chosen character.
        - **Passive Mode**: Toggle to spawn NPCs that ignore the player (Invisible Mode).
        - **NPC Gun Mode**: Turn your weapon into a spawning tool - shoot any surface to spawn the selected NPC at the impact point!
        - **Spawn Options**:
            - **Spawn NPC**: Instantly spawn the selected enemy in front of you.
            - **Group Spawn**: Advanced spawning with detailed filters.

- Source used: [SimpleEnemySpawner](https://www.nexusmods.com/cyberpunk2077/mods/4674). Please visit the mod page for detailed functionality.

## Known Issues
- Due to Cyberpunk's spawning mechanism and my level of knowledge of CET, this mod has some oddities, quirks... bugs.
- Cyberpunk doesn't like spawning assets in the player's view... for obvious reasons. So you may need to look away and back to see the NPC(s).
