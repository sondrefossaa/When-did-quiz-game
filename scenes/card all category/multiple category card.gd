extends Control

@onready var science_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer/Science question"
@onready var history_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer2/History question"
@onready var pop_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer3/Pop question"
@onready var trivia_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer4/Trivia question"
@onready var sport_question = $"Panelcontainer/MarginContainer/VBoxContainer2/MarginContainer5/Sport question"
@onready var question_generator = $"question generator"
@onready var answers  = %"Answer Buttons".get_children()
@onready var cards_count = $"cards count"
@onready var score_value = %"Score value"

var question_dict ={}
var current_category = "science"

var current_question : Dictionary

func _ready():
	question_dict = {
	"science" : science_question,
	"history" : history_question,
	"pop" : pop_question,
	"trivia" : trivia_question,
	"sport" : sport_question,
	}
	for category in question_dict:
		question_dict[category].text = ""
	current_question = question_generator.create_question(current_category)
	question_dict[current_category].text = current_question.question
	gen_multiple_choice()


func gen_multiple_choice():
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
	if current_category == "science":
		cards_count.text = str(cards_count.text.to_int() + 1)
		score_value.text = "0"
	current_question = question_generator.create_question(current_category)
	gen_multiple_choice()
