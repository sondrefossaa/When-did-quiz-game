extends Node
class_name Category_theme_manager
@export var question_generator : Node


signal theme_changed(category_name, new_color)
var CARD_THEME = preload("res://scenes/general/card_theme.tres")
var card_general_theme = preload("res://scenes/general/card_general_theme.tres")
var currect_theme := "science"
var category_color = {
	"science" : "#38b6ff",
	"history" : "#ffde59",
	"pop" : "#955fff",
	"trivia" : "#ff3939",
	"sport" : "#00bf63",
}


func _ready():
	question_generator.connect("question_created", change_theme)
	
func change_theme(category):
	
	currect_theme = category
	#card_bg.theme_type_variation = category
	var stlbox = card_general_theme.get_stylebox("panel", "PanelContainer")
	stlbox.bg_color = category_color[category]
	theme_changed.emit(category, category_color[category])
