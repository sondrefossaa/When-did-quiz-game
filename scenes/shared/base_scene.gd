extends Control
const MAIN_MENU = "uid://calwfewnvjycf"
@onready var failed_animation = $"failed animation"
@onready var score_display = $"score display"
@onready var failed_bg = $"failed bg"
@onready var high_score_or_failed_text = $"menu container/high score or failed text"
@onready var high_score_display = $"high score container/high score display"
@onready var high_score_title = $"high score container/high score title"
@onready var screen_transition_anim = $"screen transition anim"
@onready var black = $black
@onready var transition_circle = $"screen transition anim/transition_circle"

# Either timeline, multiple or single category
var gameplay_mode = ""
var child_scene : PackedScene = null
var animation_transition_custom_pos = 0
var played_transition = false

var change_to_main_menu = false
var main_menu_instance = null
func _ready():

	if child_scene:
		var child_scene_instance = child_scene.instantiate()
		add_child(child_scene_instance)
	if animation_transition_custom_pos != Vector2.ZERO:
		transition_circle.global_position = animation_transition_custom_pos
		screen_transition_anim.play("scene transition reverse")
		await screen_transition_anim.animation_finished
	transition_circle.visible = false
	#screen_transition_anim.play("RESET")
func play_fail(score):
	var prev_high_score = Global.high_scores[gameplay_mode]
	var is_high_score = Global.update_high_score(gameplay_mode, score)
	high_score_display.text = str(Global.high_scores[gameplay_mode])
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


func _on_main_menu_button_pressed():
	main_menu_instance = load(MAIN_MENU).instantiate()
	main_menu_instance.global_position.x = -get_viewport_rect().size.x
	get_tree().get_root().add_child(main_menu_instance)
	# Play meny animation in process
	change_to_main_menu = true
	play_menu_animation()
	

func _on_try_again_button_pressed():
	Global.change_scene_with_base(child_scene, self)
# Call this when you want to start the transition
func play_menu_animation():
	change_to_main_menu = false  # no longer needed in _process
	var duration = 0.5
	var viewport_width = get_viewport_rect().size.x

	var t = create_tween()
	#t.set_parallel(true)
	t.set_trans(Tween.TRANS_QUAD)
	t.set_ease(Tween.EASE_OUT)

	# Slide main menu in (x → 0)
	t.tween_property(main_menu_instance, "global_position:x", 0.0, duration)

	# Slide this scene out (x → viewport)
	t.tween_property(self, "global_position:x", viewport_width, duration)

	# When animation is done → delete this scene
	t.finished.connect(queue_free)
