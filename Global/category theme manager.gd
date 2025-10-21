extends Node
class_name categoryThemeManager
# Moved to global
#signal theme_changed(category_name, new_color)


var current_theme := "science"
var current_color := "38b6ff"
var category_color = Global.theme_colors


func _ready():
	Global.question_generated.connect(change_theme)

func get_random_theme_color():
	return category_color.values().pick_random()

func change_theme(category):
	current_theme = category
	current_color = category_color[category]
	Global.theme_changed.emit(category, category_color[category])
