extends Control
#@onready var question_container = $Question
#@onready var answer_container = $Answer
@onready var science_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer/Science question"
@onready var history_qusetion = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer2/History qusetion"
@onready var pop_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer3/Pop question"
@onready var trivia_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer4/Trivia question"
@onready var sport_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer5/Sport question"

var question_dict ={}
var current_category = "science"
@onready var answers  = %"Answer Buttons".get_children()
var csv_path = "res://questions/qtest.csv"
@onready var data = $"question generator".data
@onready var question_generator = $"question generator"
var current_question : Dictionary

func _ready():
	question_dict = {
	"science" : science_question,
	"history" : history_qusetion,
	"pop" : pop_question,
	"trivia" : trivia_question,
	"sport" : sport_question,
	}
	
	current_question = question_generator.create_question(current_category)
	
	question_dict[current_category].text = current_question.question
	gen_multiple_choice("unused")

func gen_multiple_choice(_category):
	var answer = current_question.answer.to_int()
	question_dict[current_category].text = current_question.question
	var correct_button = randi() % 4
	# Need to add something to generate bc too
	for i in range(4):
		if i == correct_button:
			answers[i].correct = true
			answers[i].text = current_question.answer
		else:
			answers[i].text = str(randi_range(answer-100, answer+100))

func _on_answer_buttons_new_question():
	current_category = question_dict.keys()[(question_dict.keys().find(current_category)+1)%question_dict.size()]
	current_question = question_generator.create_question(current_category)
	gen_multiple_choice("unused")
