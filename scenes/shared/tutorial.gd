extends Control
@onready var tutorial_text = $"tutorial text"
@onready var base_scene = $".."

var timeline_tutorial = """Place cards in timeline 
from earliest year(left)
to latest year(right).
You get points equal to
 how many cards you
can get in order.
Good luck!"""

func _ready():
	if base_scene.type not in Global.shown_tutorials:
		tutorial_text.text = timeline_tutorial
		self.visible = true
		Global.shown_tutorials.append(base_scene.type)
		Global.save()
	else:
		self.visible = false
func _on_continue_pressed():
	visible = false
