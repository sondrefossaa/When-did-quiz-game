extends Control

@onready var science_question = $"Card panel/card body/VBoxContainer2/MarginContainer/Science question"
@onready var history_question = $"Card panel/card body/VBoxContainer2/MarginContainer2/History question"
@onready var pop_question = $"Card panel/card body/VBoxContainer2/MarginContainer3/Pop question"
@onready var trivia_question = $"Card panel/card body/VBoxContainer2/MarginContainer4/Trivia question"
@onready var sport_question = $"Card panel/card body/VBoxContainer2/MarginContainer5/Sport question"

@onready var answers = %"Answer Buttons".get_children()
@onready var cards_count = %"cards count"
@onready var score_value = %"Score value"
@onready var card_panel = $"Card panel"

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
	for category in question_dict:
		question_dict[category].text = ""
	score_value.text = "0"
	cards_count.text = str(cards_count.text.to_int() + 1)
	var orgin_pos = card_panel.global_position
	var out_card = card_panel.duplicate()
	add_child(out_card)
	var viewport_width = get_viewport_rect().size.x
	
	card_panel.global_position.x = viewport_width
	var t = create_tween()
	var duration = 0.5
	
	t.set_trans(Tween.TRANS_QUAD)
	t.set_ease(Tween.EASE_OUT)

	t.tween_property(out_card, "global_position:x", 0.0 - card_panel.size.x * 2, duration)

	t.tween_property(card_panel, "global_position:x", orgin_pos.x, duration)

	t.finished.connect(func (): out_card.queue_free())
	
