extends Control
const CASUAL_CARD = preload("res://scenes/casual card/casual.tscn")
const SINGLE_CATEGORY_CARD = preload("res://scenes/single category card/single category card.tscn")
const MAIN = preload("uid://cn8psqd4pyn2m")
const MULTIPLE_CATEGORY_CARD = preload("uid://61iig0uvkhe1")


func _on_competitive_button_pressed():
	get_tree().change_scene_to_packed(MAIN)


func _on_casual_button_pressed():
	get_tree().change_scene_to_packed(CASUAL_CARD)


func _on_multiple_choice_pressed():
	get_tree().change_scene_to_packed(MULTIPLE_CATEGORY_CARD)
