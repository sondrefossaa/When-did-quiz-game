extends Control

@onready var card = $"Card"
@onready var player_answer_input = %"player answer text"
@onready var answer_text = %"answer text"

@onready var num_input = %"num input"

@onready var question_timer = %"question timer"
@onready var cards_count = $"Card/cards count"

@onready var timer_border_indicator = %"timer border indicator"
@onready var score_value = %"Score value"
@onready var category_display = $"Category display"
@onready var score_anim = %"score anim"

@onready var question_text = $"Card/Card bg/MarginContainer/Question text"
@onready var score_add_anim = $"Score value/score add anim"
@onready var input_container = $"Card/input container"
@onready var CARD_BG_DEFAULT = preload("uid://mgu6f7bglqa0")
var current_question : Dictionary

var max_allowed_score = 1000
var no_ans_score = 500
var temp_score = ""

# TODO update funcion with new card refactoring in mind
func _ready():
	player_answer_input.text = ""
	answer_text.text = ""
	QuestionGenerator.question_generated.connect(update_category_title)
	update_category_title(card.category)
	await Global.base_scene_finished
	question_timer.start()
func _process(_delta):
	if not question_timer.paused:
		timer_border_indicator.value = (question_timer.time_left / question_timer.wait_time) * 1000

func update_category_title(category):
	category_display.text = category[0].to_upper() + category.substr(1)

# Calculate score when timer runs out
func _on_question_timer_timeout():
	calculate_score()

func calculate_score():
	question_timer.stop()
	var new_score = abs(player_answer_input.text.to_int() - card.current_question.answer.to_int())
	# If no answer given
	if player_answer_input.text == "":
		player_answer_input.text = "?"
		new_score = no_ans_score
	# If answer is correct
	if new_score == 0:
		new_score = -100
	# Generate new current_question after score is calculated
	temp_score = str(new_score)
	answer_text.text = card.current_question.answer
	score_anim.play("show score")
	await  score_anim.animation_finished
	#score_anim.play("RESET")
	# Reset player answer pos
	input_container.position.y = 712.2
	player_answer_input.text = ""
	score_value.text = str(score_value.text.to_int() + temp_score.to_int())
	
	score_add_anim.play("score added")
	
	temp_score = ""
	# Show answer for 1 second
	await get_tree().create_timer(1).timeout
	if score_value.text.to_int() > max_allowed_score:
		var base_scene = get_parent()
		base_scene.play_fail(cards_count.text.to_int())
		return
	# Copy current card, generate new and animate their swap
	var temp_card = card.duplicate()
	animate_card_exit(temp_card)
	cards_count.text = str(cards_count.text.to_int() + 1)
	question_text.text = card.current_question.question
	answer_text.text = ""
	card.get_new_question()
	score_anim.play("card_in")
	await score_anim.animation_finished
	temp_card.queue_free()
	question_timer.start()
	player_answer_input.modulate ="ffffff"
	
	
func animate_card_exit(temp_card):
	temp_card.generate_question = false
	var temp_anim : AnimationPlayer = temp_card.get_node("score anim")
	var new_stylebox = CARD_BG_DEFAULT.duplicate()
	new_stylebox.bg_color = CategoryThemeManager.current_color
	temp_card.get_node("Card bg").add_theme_stylebox_override("panel", new_stylebox)
	#new_stylebox.bg_color = category_theme_manager.current_color
	
	#temp_card_bg.add_theme_stylebox_override("panel", new_stylebox)

	temp_anim.play("card_out")
	add_child(temp_card)
	await get_tree().create_timer(0.25).timeout


func show_score():
	answer_text.text = temp_score
