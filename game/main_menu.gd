extends Control
const CASUAL_CARD = preload("res://scenes/casual card/casual.tscn")
const SINGLE_CATEGORY_CARD = preload("res://scenes/single category card/single category card.tscn")
const MULTIPLE_CATEGORY_CARD = preload("uid://61iig0uvkhe1")
const TIMELINE = preload("uid://dfkj408orlm4r")
const BASE_SCENE = preload("uid://duuj82wjn50hv")
const HIGH_SCORES = preload("uid://bbtppu4gemmwp")

@onready var background = $background
@onready var admob = $Admob
@onready var screen_transition_anim = $"screen transition anim"
@onready var transition_circle = $"screen transition anim/transition_circle"

@export var game_mode_buttons : Array[Button] = []
var is_initialized := false

func _ready():
	admob.initialize()
func transition_scene_with_anim(scene_type):
	var animation_transition_custom_pos = get_global_mouse_position() - (transition_circle.size * transition_circle.scale) / 2 
	transition_circle.global_position = animation_transition_custom_pos
	screen_transition_anim.play("screen transition")
	await  screen_transition_anim.animation_finished
	Global.change_scene_with_base(scene_type, self, animation_transition_custom_pos)


func _on_competitive_button_pressed():
	transition_scene_with_anim(SINGLE_CATEGORY_CARD)
	

func _on_casual_button_pressed():
	transition_scene_with_anim(CASUAL_CARD)

func _on_multiple_choice_pressed():
	transition_scene_with_anim(MULTIPLE_CATEGORY_CARD,)

func _on_timeline_pressed():
	transition_scene_with_anim(TIMELINE)

func _on_high_score_pressed():
	transition_scene_with_anim(HIGH_SCORES)

func _on_get_more_questions_pressed():
	if is_initialized:
		admob.load_rewarded_ad()
		await  admob.rewarded_ad_loaded
		admob.show_rewarded_ad()
 
func _on_admob_initialization_completed(status_data):
	is_initialized = true

func _on_admob_rewarded_ad_user_earned_reward(ad_id, reward_data):
	# TODO Update q_count

	return
