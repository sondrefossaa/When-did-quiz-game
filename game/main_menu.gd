extends Control
const CASUAL_CARD = preload("res://scenes/casual card/casual card.tscn")
const SINGLE_CATEGORY_CARD = preload("res://scenes/single category card/single category card.tscn")
const MAIN = preload("uid://cn8psqd4pyn2m")


func _on_competitive_button_pressed():
	get_tree().change_scene_to_packed(MAIN)


func _on_casual_button_pressed():
	get_tree().change_scene_to_packed(CASUAL_CARD)
