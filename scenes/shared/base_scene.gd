extends Control
const MAIN_MENU = "uid://calwfewnvjycf"
@onready var failed_animation = $"failed animation"
@onready var score_display = $"score display"
@onready var failed_bg = $"failed bg"
@onready var high_score_or_failed_text = $"menu container/high score or failed text"
@onready var high_score_display = $"high score container/high score display"
@onready var high_score_title = $"high score container/high score title"

var type = ""
var child_scene : PackedScene = null

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file(MAIN_MENU)

func _ready():
	#print(type)
	failed_animation.play("RESET")
	if child_scene:
		var child_scene_instance = child_scene.instantiate()
		add_child(child_scene_instance)


func _on_try_again_button_pressed():
	Global.change_scene_with_base(child_scene, self)

func play_fail(score):
	# TODO add prev highscore
	var prev_high_score = Global.high_scores[type]
	var is_high_score = Global.update_high_score(type, score)
	high_score_display.text = str(Global.high_scores[type])
	if is_high_score:
		failed_bg.color = Color.GREEN
		high_score_or_failed_text.text = "High Score!"
		high_score_title.add_theme_font_size_override("font_size", 10)
		high_score_title.text = "Previous high score:"
		high_score_display.text = str(prev_high_score)
	else:
		high_score_title.add_theme_font_size_override("font_size", 15)
		high_score_title.text = "High score:"
		failed_bg.color = Color.RED
		high_score_or_failed_text.text = "Failed"
	score_display.text = "Score: %d" % [score]
	failed_animation.play("failed_start")
