extends Control

@onready var input_container = %"input margin"
@onready var player_answer_text = %"player answer text"
@onready var answer_text = %"answer text"
@onready var score_anim = %"score anim"
@onready var question_text = $"Card bg/MarginContainer/Question text"



func update_question_text(question : String):
	question_text.text = question
