extends Button
var correct = false
signal answer_chosen(correct)
func _on_pressed():
	emit_signal("answer_chosen", correct)
