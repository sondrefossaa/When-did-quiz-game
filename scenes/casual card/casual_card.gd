extends Control
@onready var question_generator = $"question generator"
@onready var card = $Card
@onready var show_answer_btn = $"Card/show answer btn"

var question : Dictionary
var answer_btn_def_text = "Show answer"
func _ready():
	Global.question_generated.connect(question_generated)
	question = question_generator.create_question()
	card.update_question_text(question.question)
	card.player_answer_text.visible = false
	card.answer_text.visible = false
func question_generated(category):
	pass


func _on_button_pressed():
	show_answer_btn.text = question.answer
	await get_tree().create_timer(1).timeout
	show_answer_btn.text = answer_btn_def_text
	question = question_generator.create_question()
	card.update_question_text(question.question)
