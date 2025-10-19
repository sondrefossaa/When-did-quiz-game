extends Control

@onready var title_and_scores = $"title and scores"

func _ready():
	for child in title_and_scores.get_children():
		if "score" in child.name:
			child.text = str(Global.high_scores[child.name.substr(0, child.name.find(" score"))])
