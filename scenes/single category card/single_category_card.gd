extends Control
@onready var answer_text = %"answer text"
@onready var answer_input = %"player answer text"
@onready var num_input = %"num input"

@onready var question_timer = %"question timer"

@onready var question_generator = %"question generator"
@onready var category_theme_manager = %"category theme manager"

@onready var input_viewer = %"Input viewer"
@onready var correct_answer = %"correct answer"
@onready var timer_border_indicator = %"timer border indicator"
@onready var score_value = %"Score value"
@onready var category_display = $"Category display"
@onready var score_anim = %"score anim"

@onready var question_text = $"Card and ans/Card bg/MarginContainer/Question text"
@onready var card_and_ans = $"Card and ans"

var current_question : Dictionary

var blank_input_score = 1000
var temp_score = ""
func _ready():
	answer_input.text = ""
	answer_text.text = ""
	#current_question = question_generator.create_question("random")
	#question_text.text = current_question.question
	current_question = question_generator.create_question("random")
	question_text.text = current_question.question

		
		


func _process(_delta):
	if not question_timer.paused:
		timer_border_indicator.value = (question_timer.time_left / question_timer.wait_time) * 1000

func _on_question_generator_question_created(category):
	# Change the first letter to uppercase
	category_display.text = category[0].to_upper() + category.substr(1)

# Calculate score when timer runs out
func _on_question_timer_timeout():
	answer_input.text = "?"
	calculate_score()

func calculate_score():
	# TODO

	var new_score = abs(answer_input.text.to_int() - current_question.answer.to_int())
	#print(new_score, " player_answer: ", answer_input.text.to_int(), " correct: ",  question_generator.correct_answer.to_int())
	if answer_input.text == "":
		answer_input.text = "?"
		new_score = blank_input_score
	# Generate new current_question after score is calculated
	#emit_signal("score_calculated", new_score)
	temp_score = str(new_score)
	answer_text.text = current_question.answer

	#correct_answer_text.text = str(correct_answer)
	score_anim.play("show score")
	#show answer for 1 second
	await  score_anim.animation_finished
	score_anim.play("RESET")
	# Reset input viewer position
	input_viewer.anchor_top = 0.693
	answer_input.text = ""
	score_value.text = str(score_value.text.to_int() + temp_score.to_int())
	answer_text.text = str(temp_score)
	temp_score = ""
	#Copy current card, generate new and animate their swap
	var temp_card = card_and_ans.duplicate()
	swap_cards(temp_card)
	
	current_question = question_generator.create_question("random")
	question_text.text = current_question.question
	answer_text.text = ""
	
	score_anim.play("card_in")
	await score_anim.animation_finished
	temp_card.queue_free()
	question_timer.start()

	answer_input.modulate ="ffffff"

func swap_cards(temp_card):
	var temp_anim = temp_card.get_node("score anim")
# Remove any theme inheritance and create a flat stylebox
	var temp_card_bg : PanelContainer = temp_card.get_node("Card bg")
	var old_stylebox = card_and_ans.get_node("Card bg").get_theme_stylebox("panel") as StyleBoxFlat
	var new_stylebox = old_stylebox.duplicate()
	new_stylebox.bg_color = category_theme_manager.current_color
	
	temp_card_bg.add_theme_stylebox_override("panel", new_stylebox)

	temp_anim.play("card_out")
	add_child(temp_card)
	await get_tree().create_timer(0.25).timeout
	
	
	
func show_score():
	answer_text.text = temp_score
