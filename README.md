<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/dd6d2d78-3612-4eaa-9971-ccf63e29e1fc" />


## Credits and Original Source

- Based on [EasyTrainers](https://github.com/AviWind02/EasyTrainers) - Lua implementation of the original EasyTrainer mod.
- Original EasyTrainer available on [Nexus Mods](https://www.nexusmods.com/cyberpunk2077/mods/23227).
- Some Stuff from [Categorized All-In-One Command List](https://www.nexusmods.com/cyberpunk2077/mods/521?tab=description).
- All credits to the original authors for the base functionality.

## Features Introduced:

- **Cyberpunk Visual Overhaul**: Completely revamped UI with a professional look, smooth animations, and a true Night City aesthetic.
- **Interactive Second Header**: Added a secondary header displaying version info, current menu name, and option count. Clicking the header title (Breadcrumb) allows for an instant return to the previous tab.
- **Hotkey System & Binding Manager**: A modern system for assigning keyboard shortcuts (hotkeys) directly to menu options.
  - **How to use**: Hover over any option to select it, then press **F+G+H** simultaneously.
  - **Status**: The row will show `[RELEASE F+G+H]`, followed by a blinking `[PRESS KEY TO BIND]`. Press any key to assign it. Success is confirmed with a green `[BIND: KEY]` message.
  - **Management**: A dedicated **Binding Menu** in settings allows you to preview shortcuts and quickly enable/disable them without clearing the binding.

### Built-in Cyberpunk-Style Font (Rajdhani-Bold.ttf)

This fork includes the bold and sharp **Rajdhani-Bold** font to give the trainer menu a true Night City aesthetic right out of the box.

#### Enable the custom font:

1. After installation open the CET config file:`Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\config.json`
2. Find the `"font"` section and change the `"path"` value to:

   ```json
   "font": {
        "base_size": 24.0,
        "language": "Default",
        "oversample_horizontal": 3,
        "oversample_vertical": 1,
        "path": "Rajdhani-Bold.ttf"

   ```

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

### 1.0.2

- **Explosive Bullets**:
  - Added over **400 explosion types** (TweakDB IDs).
  - **Categorized UI**: Organized explosions into 14 logical groups (Bosses, Quickhacks, Chimera, etc.) with nested submenus.
  - **Quick Sets**: Added a hand-picked list of the best and most common explosion types for quick access.
  - **Navigation Improvements**: Current explosion selection is now marked with an `[X]` indicator.

### 1.0.3

- **UI Redesign**: Significant visual overhaul inspired by Cyberpunk 2077's native UI, featuring improved gradients, borders, and smooth height transitions.
- **Overlay Enhancements**:

  - **Version Display**: Added mod version (vX.X.X) to top-left overlay and game version to bottom-right corner.
  - **Configurable Toggles**: New overlay settings to show/hide mod version and game version displays.
- **World Time Dilation**:

  - **Slow The World Around You**: Slows down the environment while maintaining the player's 1x movement speed.
  - **Stop The World Around You**: Effectively pauses the world while allowing the player to freely explore.
- **World Interactions**:

  - **Toggle Door Status**: Open or close targeted doors; fixes stuck automatic doors.
  - **Destroy Door**: Instantly removes targeted doors or fake doors.
  - **Toggle Targeted Device**: Turn ON/OFF electronic devices like TVs, Jukeboxes, PCs, etc.
  - **Instant Kill NPC (On Click)**: Enable a toggle to instantly eliminate NPCs with a Left Mouse Click.
  - **World Interactions (On Click)**: Added new toggles to enable interaction with doors and devices using a Left Mouse Click when looking at them.
  - **Randomize NPC Appearance**: Instantly randomizes clothes/look of targeted NPCs.
- **Abilities**:

  - **Forcefield**: Added a destructive shockwave ability that clears the area around the player (15m radius).
- **Modifiers**:

  - **Cycle Game Difficulty**: Added a new cheat to cycle through game difficulty levels (Story, Easy, Hard, Very Hard) from the Modifiers menu.
- **Self**:

  - **FOV Control**: Interactive adjustment for Field of View (65-115) with automatic zoom removal.
  - **Instant Suicide**: Quick action to apply ForceKill status effect.
- **Status Effects Menu**:

  - **817+ Effects**: Comprehensive browser loaded from TweakDB with 6 categorized menus (Combat, Cyberware, Quickhacks, Buffs, Debuffs, All).
  - **Direct Application**: Click any effect to apply to player instantly.
  - **Active Indicator**: [X] marker shows currently applied effect.

### 1.0.4 

- **World Interaction Hotkey**:
  - **Fully Customizable**: All World Interaction toggles (Instant Kill, Door, Device, Random Appearance, **Remote Launch**) now trigger using a user-configurable hotkey (Default: **Q**).
  - **Remote Launch Vehicle**: Added to World Interactions – launch any targeted vehicle into the air remotely using your interact hotkey.
- **Universal Randomization**:
  - **Random Appearance** now works on **any targeted object** (NPCs, Vehicles, Doors, Vending Machines, etc.).
- **New Vehicle Features**:
  - **Random Vehicle Appearance**: Dedicated option in the Vehicle Menu to randomize the appearance (color/livery) of your currently mounted vehicle.
  - **Police Siren Lights**: Alternates vehicle lights between Red and Blue.
  - **Launch Vehicle**: Allows your vehicle to leap into the air (Space/A) with fixed, optimal force.
  - **Insta Flip**: Quickly flip your vehicle back onto its wheels if overturned.
- **New Tool: Debug Object**:
  - Added a specialized toggle to draw a **Cyan Crosshair** and real-time data overlay.
  - Displays technical information like **Entity Hash**, **Technical Type**, and **Localized Name** of what you are currently aiming at.
- **Enhanced Color Picker UI**:
  - **Multi-Mode RGB Slider**: Replaced dropdown color picker with an intuitive gradient slider system.
  - **4 Modes**: 
    - **RGB (Hue)**: Rainbow gradient for color selection
    - **Saturation**: Gray to full color intensity
    - **Brightness**: Black to white grayscale
    - **Alpha**: Transparency control (0-255)
  - **Controls**:
    - **Left/Right Arrow Keys**: Adjust current value
    - **Space Key**: Cycle between modes
    - **R3 Button (Controller)**: Cycle between modes
    - **Right Mouse Button**: Cycle between modes
    - **Mouse Drag**: Click and drag to select value
  - **Visual Indicators**: Dual branded triangle indicators show current position on slider
- **Window Dragging Restriction**:
  - Menu window can now only be dragged by clicking and holding the **Header** or **Footer** areas.
  - Prevents accidental window movement when interacting with UI elements like sliders.

## Known Issues

- **Explosive Bullets**: Some explosion types may cause game crashes, have no visual/audio effects, or not work at all. Use with caution.
- **NPC Spawning**: Due to Cyberpunk's spawning mechanism and current CET limitations, this mod has some oddities/bugs. Cyberpunk doesn't like spawning assets in the player's direct view, so you may need to look away and back to see the spawned NPC(s).
