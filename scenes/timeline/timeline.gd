extends Control
@onready var card = $card
@onready var hover_start_btn = card.get_node("Hover start")
@onready var hover_col : Area2D = card.get_node("card hover col")
@onready var wrong_answer_anim = $"wrong answer anim"
@onready var timeline_cards = $"timeline cards"
@onready var orgin_pos = card.global_position
@onready var score_value = %"Score value"
@onready var score_add_anim = $"Score value/score add anim"
var timeline_card_orgin : Vector2
var hovering := false
var hover_offset := Vector2.ZERO
var drag_offset_x := 0.0
var added = false
var hover_over := false

func _input(event):
	if event is InputEventScreenDrag:
		if not hovering:
			drag_cards(event.relative.x)


func drag_cards(delta_x: float) -> void:
	drag_offset_x += delta_x


func _ready():
	score_add_anim.speed_scale = 3
	hover_start_btn.button_down.connect(hover_start)
	hover_start_btn.button_up.connect(hover_end)
	update_card_pos()
	for timeline_card in timeline_cards.get_children():
		timeline_card.reveal_answer()
		timeline_card_orgin = timeline_card.global_position
	card.global_position.x = timeline_card_orgin.x
func hover_start():
	hovering = true
	hover_offset = card.global_position - get_global_mouse_position()
func hover_end():
	hovering = false

func _process(_delta):
	if hovering:
		card.global_position = get_global_mouse_position() + hover_offset
	if Input.is_action_just_released("card_drop") and hover_over:
		var index = find_index(card.global_position.x)
		var new_card = card.duplicate()
		new_card.generate_question = false
		new_card.scale = Vector2(1,1)
		timeline_cards.add_child(new_card)
		timeline_cards.move_child(new_card, index)
		new_card.global_position.y = timeline_card_orgin.y
		# Make the area not moniterable so that area_entered dosent register
		new_card.get_node("card hover col").monitorable = false
		new_card.current_question = card.current_question
		new_card.reveal_answer()
		card.global_position = orgin_pos
		card.get_new_question()
		hover_over = false
		print(new_card.current_question)
		if not is_valid_insertion(new_card, index):
			wrong_answer_anim.play("wrong answer")
			await wrong_answer_anim.animation_finished
			get_tree().reload_current_scene()
		else:
			var score = score_value.text.to_int()
			score_add_anim.play("score added start")
			await score_add_anim.animation_finished
			score_value.text = str(score + 1)
			score_add_anim.play("score added")
	update_card_pos()


func is_valid_insertion(new_card: Node, index: int) -> bool:
	var child_count = timeline_cards.get_child_count()
	var new_value: int = new_card.current_question.answer.to_int()

	if index - 1 >= 0 and index + 1 < child_count:
		var prev: int = timeline_cards.get_child(index - 1).current_question.answer.to_int()
		var next: int = timeline_cards.get_child(index + 1).current_question.answer.to_int()
		return new_value > prev and new_value < next
	elif index - 1 >= 0:  # Only prev (inserting at end)
		var prev: int = timeline_cards.get_child(index - 1).current_question.answer.to_int()
		return new_value >= prev
	elif index + 1 < child_count:  # Only next (inserting at start)
		var next: int = timeline_cards.get_child(index + 1).current_question.answer.to_int()
		return new_value <= next
	else:
		return true
	
func _on_card_drop_area_area_entered(_area):
	hover_over = true


func _on_card_drop_area_area_exited(_area):
	hover_over = false

	
func update_card_pos():
	var pivot = get_viewport_rect().size / 2 - Vector2(card.size.x * 0.2, 0)
	var cards = timeline_cards.get_children()
	if hover_over:
		# Find index
		var index = find_index(card.global_position.x)
		cards.insert(index, card)
	var pos_offset_array := []
	
	for i in range(cards.size()):
		var temp = i-cards.size() / 2.0
		pos_offset_array.append(temp+0.5)

	var i = 0
	for timeline_card in cards:
		timeline_card.global_position.x = pivot.x + (pos_offset_array[i] * timeline_card.size.x * 0.4) + drag_offset_x
		i += 1

func find_index(x_pos):
	var index = 0
	for timeline_card in timeline_cards.get_children():
		if timeline_card.global_position.x < x_pos:
			index += 1
	return index
