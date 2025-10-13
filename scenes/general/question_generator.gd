extends Node
class_name questionGenerator

signal question_created(category : String)
var csv_path = "res://questions/qtest.csv"

# Load custom resource
const questions_resouce = preload("res://resources/questions.tres") as CSVResource
@onready var data = questions_resouce.questions

var categories : Array[String] = ["science", "history", "pop", "trivia", "sport"]
var correct_answer : String

# Limit question count to prevent csv "wrapping"
var qestion_count := 131

func create_question(category = "random"):
	#TODO : Refactor whole system
	if category == "random":
		category = categories.pick_random()
	
	# Generate question from random column in categoy index
	var index = categories.find(category)
	var col = index * 2
	print(index)
	var row = randi_range(1, qestion_count-1)
	var question = data[row][col]

	# If single categoy card
	correct_answer = data[row][col+1]
	emit_signal("question_created", category)
	return {"question": question, "answer": correct_answer}
