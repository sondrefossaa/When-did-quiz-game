extends Node

signal theme_changed(category_name, category_color)
var current_theme := "science"
var current_color := "38b6ff"
var category_colors = {
	"science" : "#38b6ff",
	"history" : "#ffde59",
	"pop" : "#955fff",
	"trivia" : "#ff3939",
	"sport" : "#00bf63",
}


func _ready():
	QuestionGenerator.question_generated.connect(change_theme)

func get_random_theme_color():
	return category_colors.values().pick_random()

func change_theme(category):
	current_theme = category
	current_color = category_colors[category]
	theme_changed.emit(category, category_colors[category])
