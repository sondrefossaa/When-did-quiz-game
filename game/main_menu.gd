extends Control
const CASUAL_CARD = preload("res://scenes/casual card/casual.tscn")
const SINGLE_CATEGORY_CARD = preload("res://scenes/single category card/single category card.tscn")
const MAIN = preload("uid://cn8psqd4pyn2m")
const MULTIPLE_CATEGORY_CARD = preload("uid://61iig0uvkhe1")
const TIMELINE = preload("uid://dfkj408orlm4r")
const BASE_SCENE = preload("uid://duuj82wjn50hv")
const HIGH_SCORES = preload("uid://bbtppu4gemmwp")

@onready var admob = $Admob
var is_initialized := false

func _ready():
	admob.initialize()



func _on_competitive_button_pressed():
	Global.change_scene_with_base(SINGLE_CATEGORY_CARD, self)

func _on_casual_button_pressed():
	Global.change_scene_with_base(CASUAL_CARD, self)

func _on_multiple_choice_pressed():
	Global.change_scene_with_base(MULTIPLE_CATEGORY_CARD, self)

func _on_timeline_pressed():
	Global.change_scene_with_base(TIMELINE, self)

func _on_high_score_pressed():
	Global.change_scene_with_base(HIGH_SCORES, self)

func _on_get_more_questions_pressed():
	if is_initialized:
		admob.load_rewarded_ad()
		await  admob.rewarded_ad_loaded
		admob.show_rewarded_ad()
 
func _on_admob_initialization_completed(status_data):
	is_initialized = true

func _on_admob_rewarded_ad_user_earned_reward(ad_id, reward_data):
	# Update q_count
	
	return
