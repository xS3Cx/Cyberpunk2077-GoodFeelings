<img width="1280" height="719" alt="image" src="https://github.com/user-attachments/assets/e707f30a-f386-4b04-83c5-e257ff3e3383" />

## Credits and Original Source
This is a personal fork of [AviWind02/EasyTrainers](https://github.com/AviWind02/EasyTrainers) - Lua implementation of the original EasyTrainer mod.
Original EasyTrainer available on [Nexus Mods](https://www.nexusmods.com/cyberpunk2077/mods/23227).
All credits to the original authors for the base functionality.

### Built-in Cyberpunk-Style Font (Play-Bold.ttf)

This fork includes the bold and sharp **Play-Bold** font to give the trainer menu a true Night City aesthetic right out of the box.

#### Enable the custom font:
1. After installation open the CET config file:  
   `Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\config.json`

2. Find the `"font"` section and change the `"path"` value to:

   ```json
   "font": {
        "base_size": 18.0,
        "language": "Default",
        "oversample_horizontal": 3,
        "oversample_vertical": 1,
        "path": "Play-Bold.ttf"
   }
