extends Node
class_name questionGenerator

# Moved to global
#signal question_created(category : String)
var csv_path = "res://questions/qtest.csv"

# Load custom resource
const questions = preload("res://questions/question_loader.tres") as CSVResource
@onready var data = questions.questions

var categories : Array[String] = ["science", "history", "pop", "trivia", "sport"]
var correct_answer : String
# Limit question count to prevent csv "wrapping"
var question_count := 131

func create_question(category = "random"):
	if category == "random":
		category = categories.pick_random()
	
	# Generate question from random column in categoy index
	var index = categories.find(category)
	var col = index * 2
	var row = randi_range(1, question_count-1)
	var question = data[row][col]

	correct_answer = data[row][col+1]

	Global.question_generated.emit(category)

	return {"question": question, "answer": correct_answer, "category" : category}
