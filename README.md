
# When did? - a quiz game
### *My final project for cs50x*
##### Made in the Godot game engine
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
All categories are related to a theme color, for example light blue for **Science**. The colors affect the background of the game and also the color of the card displaying the question.

Players can freely choose between game modes from the main menu, and a high score is kept for each of them (except casual). Questions are randomly selected and are all formatted like you can add **"When did"** infront, and of course a **question mark** at the end. Example:
Question displayed: Alexander Flemming discover pencillin
Full formatting: **When did** Alexander Flemmin discover pencilin **?**
## Inspiration
The idea came from a card game i own called 0-100. The goal of the game is to guess from a question a value for 0-100, you get points equal to how far off you are from the answer and the goal is to have as little points as possible.  I really like gussing which year events happened in so i wanted to make a game about that where you get points equal to how many points you are of the year. You can see easally that the **Numerical** game mode mimics this. The design of the multiple choice card also mimics the question card in 0-100.

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

## How it works
### Background
The background scene inherits the current category theme color and has two modes.

 1. Year
 2. Question
 
 The year mode generates labes with a year that float over the background in the same random direction. They change direction and color when the category theme changes. The question mode is the same but instead of displaying a year the floating labels display a random question from the question_generator script.
The floating labels spawn outside the viewport and are removed from processing after they leave it.

### Card scene
All game modes except multiple choice share a common scene called: **card**. The card scene looks like a card, has a white border and the background color follows the currect category theme. The game scene is able to generate qusetions on load or manually by function call. It also has information about what the current answer is and a button that can show it. Making a general card scene like this that can be specified for different game modes makes it easier to add new gamemodes. The reason the multiple choice mode dosent use the card scene is that i wanted to perserve some of the orignal inspiration. It would definetly have been cleaner if i used the card scene for it too.

![Card](https://photos.fife.usercontent.google.com/pw/AP1GczPubnafVmQ2spdsap9xV-TkKcg0oA67nEsCa52B2cBfkJWieiUafRRDgw=w406-h586-s-no-gm?authuser=0)
### Question generation
All questions are loaded from a csv file into an array with something called a tool script. A tool script in Godot is a script that can be run in the editor. The reason i dont load questions directly from a csv file is because i had some problems referencing it when exporting. 



