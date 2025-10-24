
# When did? - a quiz game
### *My final project for cs50x*

**When did?** is a quiz game where you have to as yourself a simple question: **When did** x **happen?** The game consists of **four** game modes and **five** categories. 
The categories are:
- **Science**	
- **History**
- **Pop culture**
- **Trivia**
- **Sports**

The game modes are:
- **Numerical** - guess year event happened in with numpad
- **Multiple choice** - choose 1 of 4 options
- **Timeline** - place events in a timeline
- **Casual** - shows questions and can reveal the answer with a button

## Project structure
<details>
<summary>Struct</summary>

res://  
├── addons/  
│ └── AdmobPlugin/  
├── android/  
├── game/  
│ ├── main menu.tscn  
│ ├── main_menu.gd  
│ └── screen_transition_anim.tscn  
├── Global/  
│ ├── category theme manager.gd  
│ ├── global.gd  
│ ├── question_generator.gd  
│ ├── question_generator.tscn  
│ └── theme_manager.tscn  
├── questions/  
│ ├── source/  
│ ├── question_loader.gd  
│ └── question_loader.tres  
├── scenes/  
│ ├── card all category/  
│ ├── casual card/  
│ ├── high scores/  
│ ├── shared/  
│ ├── single category card/  
│ └── timeline/  
├── visual/  
│ ├── background/  
│ ├── shader/  
│ ├── themes/  
│ │ ├── multiple category card/  
│ │ └── single category card/  
│ ├── answer button.tres  
│ ├── card bg default.tres  
│ ├── visual orgin/  
│ ├── border timer texture.png  
│ └── when didi card game logo.png  
├── export_presets.cfg  
├── icon.svg  
├── Notes.txt  
└── temp.tscn
</details>
