extends Node

const BASE_SCENE = preload("uid://duuj82wjn50hv")

var save_path = "user://high_score.save"

var high_scores = {
	"single category" : 0,
	"multiple choice" : 0,
	"timeline" : 1,
}
var theme_colors = {
	"science" : "#38b6ff",
	"history" : "#ffde59",
	"pop" : "#955fff",
	"trivia" : "#ff3939",
	"sport" : "#00bf63",
}
var shown_tutorials : Array[String] = []

var data = {
	"shown_tutorials" : shown_tutorials,
	"high_scores" : high_scores
}
func _ready():
	load_data()

@warning_ignore("unused_signal")
signal theme_changed(category_name, category_color)
@warning_ignore("unused_signal")
signal question_generated(category)

func update_high_score(type : String, score : int):
	if score > high_scores[type]:
		high_scores[type] = score
		save()
		return true
	return false

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		data = file.get_var()
		shown_tutorials = data.shown_tutorials
		high_scores = data.high_scores

	else:
		print("No data saved")
		high_scores = {
		"single category" : 0,
		"multiple choice" : 0,
		"timeline" : 1
		}
	
func change_scene_with_base(new_scene, orgin_scene):
	var base_scene_instance = BASE_SCENE.instantiate()
	base_scene_instance.child_scene = new_scene
	base_scene_instance.type = new_scene.instantiate().name
	get_tree().root.add_child(base_scene_instance)
	get_tree().current_scene = base_scene_instance
	orgin_scene.queue_free()
