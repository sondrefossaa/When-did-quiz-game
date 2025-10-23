extends Node

signal theme_changed(category_name, category_color)

var category_colors = {
	"science" : "#38b6ff",
	"history" : "#ffde59",
	"pop" : "#955fff",
	"trivia" : "#ff3939",
	"sport" : "#00bf63",
}
var current_theme : String = category_colors.keys().pick_random()
var current_color : String = category_colors[current_theme]

func _ready():
	QuestionGenerator.question_generated.connect(change_theme)
	var start_cat = category_colors.keys().pick_random()
	theme_changed.emit(start_cat, category_colors[start_cat])

func get_random_theme_color():
	return category_colors.values().pick_random()

func change_theme(category):
	current_theme = category
	current_color = category_colors[category]
	theme_changed.emit(category, category_colors[category])
