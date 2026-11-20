general file structure:
res://
├── assets/ # Raw imports (sprites, audio, 3D models, fonts)
├── autoloads/ # Global singletons (AudioManager.gd, SaveSystem.gd)
├── components/ # Reusable logic nodes (HealthComponent)
├── entities/ # Self-contained game objects
│ ├── player/ # player.tscn, player.gd, player_stats.tres
│ └── enemies/ # goblin.tscn, goblin.gd, goblin_stats.tres
├── levels/ # Main game worlds and stage scenes
├── resources/ # Custom Resource script definitions (ItemData.gd)
└── ui/ # Menus, HUD, and reusable interface widgets
