extends Control

@onready var base_scene = $".."
@onready var tutorial_text = %"tutorial text"
@onready var text_panel = $"text panel"
@onready var continue_button = $"continue button"

var  timeline_tutorial = """Place cards in timeline 
from earliest year(left)
to latest year(right).
You get points equal to
 how many cards you
can get in order.
Good luck!"""

var single_category_tutorial = """Guess wich year the event 
happened in. You get points
equal to the difference
from the answer. 
Your score is how many
cards you can get through
without surpassing
1000 points.
Good luck!"""

var multiple_category_tutorial = """Guess from four options
when the event happened.
You get a point for each
wrong answer. If you get 
less than 4 wrong, you
advance to the next card,
if not you fail.
You get points equal to
how many cards 
you get through."""

var tutorials = {
	"timeline" : timeline_tutorial,
	"multiple choice" : multiple_category_tutorial,
	"single category" : single_category_tutorial,
}
func _ready():
	if base_scene.gameplay_mode not in Global.shown_tutorials and base_scene.gameplay_mode in tutorials:
		CategoryThemeManager.theme_changed.connect(change_tutorial_color)
		tutorial_text.text = tutorials[base_scene.gameplay_mode]
		self.visible = true
		Global.shown_tutorials.append(base_scene.gameplay_mode)
		Global.save()
	else:
		call_deferred("emit_base_scene_signal")
		visible = false
func _on_continue_pressed():
	call_deferred("emit_base_scene_signal")
	visible = false
func change_tutorial_color(_category, color):
	#tutorial_text.add_theme_color_override("font_color", Color(color).darkened(0.5))
	text_panel.get_theme_stylebox("panel").bg_color = color
	#continue_button.add_theme_color_override("font_color", Color.WHITE)

func emit_base_scene_signal():
	Global.base_scene_finished.emit()
