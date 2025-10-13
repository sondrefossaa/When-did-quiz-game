extends Control
@onready var answer_text = %"answer text"
@onready var answer_input = %"player answer text"
@onready var num_input = %"num input"

@onready var question_timer = %"question timer"

@onready var question_generator = %"question generator"

@onready var input_viewer = %"Input viewer"
@onready var correct_answer = %"correct answer"
@onready var timer_border_indicator = %"timer border indicator"
@onready var score_value = %"Score value"
@onready var category_display = $"Category display"
@onready var score_anim = %"score anim"
@onready var question_text = $"Card and ans/Card bg/MarginContainer/Question text"

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
func _on_main_anim_animation_finished(anim_name):
	if anim_name == "show score":
		answer_input.text = ""
		answer_text.text = ""


func _process(_delta):
	if not question_timer.paused:
		timer_border_indicator.value = (question_timer.time_left / question_timer.wait_time) * 1000

func _on_question_generator_question_created(category):
	# Change the first letter to uppercase
	category_display.text = category[0].to_upper() + category.substr(1)
	question_timer.start()

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
	if answer_input.text != "":
		#correct_answer_text.text = str(correct_answer)
		score_anim.play("show score")
		#show answer for 1 second
		await  score_anim.animation_finished
		score_anim.play("RESET")
		answer_input.text = ""
	score_value.text = str(score_value.text.to_int() + temp_score.to_int())
	answer_text.text = str(temp_score)
	temp_score = ""
	current_question = question_generator.create_question("random")
	question_text.text = current_question.question
	answer_text.text = ""

func show_score():
	answer_text.text = temp_score
