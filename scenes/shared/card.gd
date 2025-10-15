extends Control

@export var question_generator : questionGenerator = null
@export var category_theme_manager : categoryThemeManager = null


@onready var input_container = %"input margin"
@onready var player_answer_text = %"player answer text"
@onready var answer_text = %"answer text"
@onready var score_anim = %"score anim"
@onready var question_text = $"Card bg/MarginContainer/Question text"
@onready var card_bg = $"Card bg"
@onready var CARD_BG_DEFAULT = preload("uid://mgu6f7bglqa0")
@onready var show_answer_btn = get_node("show answer btn")

var generate_question = true
var card_general_theme = preload("res://visual/themes/single category card/card_general_theme.tres")
var current_question : Dictionary

const SHOW_ANSWER_DEF = "Show answer"
func _ready():
	if question_generator and generate_question:
		current_question = question_generator.create_question()
		update_question_text(current_question.question)
		update_bg_color(category_theme_manager.category_color[current_question.category])
		print(current_question.question)


func update_question_text(new_question : String):
	question_text.text = new_question


func update_bg_color(newcolor):
	#var stlbox = card_bg.get_theme().get_stylebox("panel", "PanelContainer")
	# TODO might create infinate stylebox
	var new_stylebox = CARD_BG_DEFAULT.duplicate()
	new_stylebox.bg_color = newcolor
	card_bg.add_theme_stylebox_override("panel", new_stylebox)

func _on_show_answer_btn_pressed():
	if show_answer_btn:
		show_answer_btn.text = current_question.answer
		#current_question = question_generator.create_question()
		#update_question_text(current_question.question)
		#update_bg_color(category_theme_manager.category_color[current_question.category])
