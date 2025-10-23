extends Control

@onready var science_question = $"Card panel/card body/VBoxContainer2/MarginContainer/Science question"
@onready var history_question = $"Card panel/card body/VBoxContainer2/MarginContainer2/History question"
@onready var pop_question = $"Card panel/card body/VBoxContainer2/MarginContainer3/Pop question"
@onready var trivia_question = $"Card panel/card body/VBoxContainer2/MarginContainer4/Trivia question"
@onready var sport_question = $"Card panel/card body/VBoxContainer2/MarginContainer5/Sport question"

@onready var answers = %"Answer Buttons".get_children()
@onready var cards_count = $"cards count"
@onready var score_value = %"Score value"
const NORMAL_THEME = preload("uid://cdhu03nh24i37")

var question_dict ={}
var current_category = "science"

var current_question : Dictionary
var swapping = false
var swap_type = ""
var transition_speed = 10
var card_size = Vector2(183, 439)
var orgin_pos_x = card_size.x
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
	current_question = QuestionGenerator.create_question(current_category)
	question_dict[current_category].text = current_question.question
	gen_multiple_choice()

func _process(delta):
	if swapping:
		match swap_type:
			"out":
				global_position.x = lerp(global_position.x, -get_viewport_rect().size.x, transition_speed * delta)
				if abs(global_position.x+get_viewport_rect().size.x) < 1.0:
					queue_free()
			"in":
				global_position.x = lerp(global_position.x, orgin_pos_x, transition_speed * delta)
				if abs(global_position.x - orgin_pos_x) < 1.0:
					global_position.x = orgin_pos_x
					swapping = false
					score_value.text = "0"

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
			if "BC" in current_question.answer:
				answers[i].text = str(randi_range(answer-100, answer+100)) + " BC"
			else:
				answers[i].text = str(randi_range(answer-100, answer+100))
		answers[i].add_theme_font_size_override("font_size", 50 - 5 *(len(answers[i].text)-5))

func _on_answer_buttons_new_question():
	current_category = question_dict.keys()[(question_dict.keys().find(current_category)+1)%question_dict.size()]
	if current_category == "science":
		animate_card_swap()
	current_question = QuestionGenerator.create_question(current_category)
	gen_multiple_choice()

func animate_card_swap():
	# TODO fix so that it only animates the visual
	var new_card = self.duplicate()
	
	for question_label in new_card.question_dict.values():
		question_label.text = ""
	new_card.global_position.x = get_viewport_rect().size.x
	new_card.swapping = true
	new_card.swap_type = "in"
	self.swapping = true
	self.swap_type = "out"
	get_tree().get_root().get_node("base scene").add_child(new_card)
	new_card.cards_count.text = str(cards_count.text.to_int() + 1)
