# Toy Factory Survivors

## Introduction
Welcome to "Toy Factory Survivors"! This is an auto-shooter action game inspired by "Vampire Survivors". Take on the role of a brave character in a chaotic toy factory, facing endless waves of toy enemies. Collect experience gems to upgrade your abilities, unlock new skills, and survive!

## Features
- **Classic Survivor Gameplay**: Survive against ever-growing hordes of enemies, testing your strategy and reflexes.
- **Free Movement**: Move freely across the map, dodging enemies and finding the best combat positions.
- **Auto-Shooting**: Focus on movement and positioning; your weapons will automatically target the nearest enemies.
- **Rich Upgrade System**: Collect experience gems to level up and enhance your character from a diverse selection of upgrade options.
- **Diverse Toy Enemies**: Face a variety of toy enemies, each with unique behaviors.
- **Resizable Window**: The game window can be freely resized, and the content will scale accordingly, providing a better gaming experience.
- **Sound System**: Immerse yourself in battle sound effects, upgrade notifications, gem pickups, and more (some sound files need to be added by the user).

## Technologies Used
- **Godot Engine 4.x**: The primary engine used for developing this game.
- **GDScript**: Godot Engine's built-in scripting language, used for game logic programming.

## How to Run the Game

### 1. Install Godot Engine
If you haven't already, download and install Godot Engine 4.x from the [official Godot Engine website](https://godotengine.org/download).

### 2. Clone the Project
```bash
git clone https://github.com/bluetch/toy-factory-survivors.git
cd toy-factory-survivors
```

### 3. Open the Project
Launch Godot Engine, then click "Import" or "Open Project" and select the `project.godot` file located in the `toy-factory-survivors` project folder you cloned.

### 4. Run the Game
In the Godot editor, click the "Run" button (typically a play icon) in the top right corner to start the game.

## Sound Setup
A sound system has been set up in the game, but some audio files need to be provided by you.
1.  **Prepare your sound files:**
    *   Find suitable `.wav` or `.ogg` sound files for the following events:
        *   Player taking damage
        *   Enemy dying
        *   Collecting XP gems
        *   Player leveling up
    *   Rename these files exactly as follows:
        *   `player_hurt.wav` (or `.ogg`)
        *   `enemy_death.wav` (or `.ogg`)
        *   `pickup.wav` (or `.ogg`)
        *   `level_up.wav` (or `.ogg`)
2.  **Place sound files in the project:**
    *   Move all these renamed sound files into the `assets/audio/` directory within your project.
3.  **Modify `scripts/sound_manager.gd`:**
    *   Open `scripts/sound_manager.gd`.
    *   In the `_ready()` function, add code to load the other sound effects. For example:
        ```gdscript
        player_hurt_stream = load("res://assets/audio/player_hurt.wav")
        enemy_death_stream = load("res://assets/audio/enemy_death.wav")
        pickup_stream = load("res://assets/audio/pickup.wav")
        level_up_stream = load("res://assets/audio/level_up.wav")
        ```
    *   In the `play_sound()` function, within the `match sound_name:` block, add stream assignments for the corresponding sound effects. For example:
        ```gdscript
        match sound_name:
            "shoot":
                audio_player.stream = shoot_stream
            "player_hurt":
                audio_player.stream = player_hurt_stream
            "enemy_death":
                audio_player.stream = enemy_death_stream
            "pickup":
                audio_player.stream = pickup_stream
            "level_up":
                audio_player.stream = level_up_stream
        ```

## Contributing
Contributions in all forms are welcome! If you have any suggestions, bug reports, or feature requests, feel free to submit an Issue or Pull Request.

## License
[Please fill in your license information here, e.g., MIT License, GPL, etc.]

## Acknowledgements
- Inspired by "Vampire Survivors".
- [You can add other resources or individuals you'd like to acknowledge here.]
