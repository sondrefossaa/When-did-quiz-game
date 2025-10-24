# When did? - a quiz game
### *My final project for cs50x*

**When did?** is a quiz game where you have to as yourself a simple question: **When did** x **happen?** The game consists of **four** game modes and **five** categories. 

The game modes are:
- **Numerical** - guess year event happened in with numpad
- **Multiple choice** - choose 1 of 4 options
- **Timeline** - place events in a timeline
- **Casual** - shows questions and can reveal the answer with a button

The categories are:
- **Science**	
- **History**
- **Pop culture**
- **Trivia**
- **Sports**

Players can freely choose between game modes from the main menu, and a high score is kept for each of them (except casual). Questions are randomly selected and are all formatted like you can add **"When did"** infront, and of course a **question mark** at the end. Example:
Question displayed: Alexander Flemming discover pencillin
Full formatting: **When did** Alexander Flemmin discover pencilin **?**







## Project structure
<details>
<summary>Filesystem</summary>

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

The project has three global scripts:

 1. global
 2. question_generator
 3. category_theme_manager
 
 The global script handles high score tracking, tracking tutorials shown, saving, and scene transitions. question_generator handles logic for generating a random question in a random category and triggers a theme change to the new question category. category_theme_manager handles the colors related to specific themes and emits a signal when the theme color is changed so that nodes affected by theme color can update it. I could consolidate these nodes to one script called game_maneger but i thought it would be more explicit and cleaner to do it this way.
