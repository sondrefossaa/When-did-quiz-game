extends Control
@onready var card = $card
@onready var hover_start_btn = card.get_node("Hover start")
@onready var hover_col : Area2D = card.get_node("card hover col")
@onready var wrong_answer_anim = $"wrong answer anim"
@onready var timeline_cards = $"timeline cards"
@onready var orgin_pos = card.global_position
@onready var score_value = %"Score value"
@onready var score_add_anim = $"Score value/score add anim"
const TIMELINE_SCENE = preload("uid://dfkj408orlm4r")
var cards_scale = 0.6
var timeline_card_orgin : Vector2
var hovering := false
var hover_offset := Vector2.ZERO
var drag_offset_x := 0.0
var added = false
var hover_over := false
var drag_vel_x := 0.0
func _input(event):
	if event is InputEventScreenDrag:
		if not hovering:
			# TODO fix bug that allows card to get out of bounds
			drag_vel_x = event.relative.x
			drag_cards(event.relative.x)


func drag_cards(delta_x: float) -> void:
	if not (timeline_cards.get_children()[-1].global_position.x < 0 and drag_vel_x < 0):
		if not (timeline_cards.get_children()[0].global_position.x > get_viewport_rect().size.x - card.size.x * cards_scale and drag_vel_x > 0): 
			drag_offset_x += delta_x
		else:
			drag_offset_x = get_viewport_rect().size.x / 2 - card.size.x * cards_scale + card.size.x * cards_scale * timeline_cards.get_children().size()/2
	else:
		drag_offset_x = -get_viewport_rect().size.x / 2 + card.size.x * cards_scale - card.size.x * cards_scale * timeline_cards.get_children().size()/2


func _ready():
	# Set scale
	card.get_node("show answer btn").text = ""
	card.scale = Vector2(cards_scale, cards_scale)
	timeline_cards.scale = Vector2(cards_scale, cards_scale)
	score_add_anim.speed_scale = 3
	hover_start_btn.button_down.connect(hover_start)
	hover_start_btn.button_up.connect(hover_end)
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
		new_card.global_position = card.global_position
		#new_card.global_position.y = timeline_card_orgin.y
		# Make the area not moniterable so that area_entered dosent register
		new_card.get_node("card hover col").monitorable = false
		new_card.current_question = card.current_question
		new_card.reveal_answer()
		card.global_position = orgin_pos
		card.get_new_question()
		hover_over = false
		if not is_valid_insertion(new_card, index):
			var base_scene = get_parent()
			base_scene.play_fail(score_value.text.to_int())
		else:
			var score = score_value.text.to_int()
			score_add_anim.play("score added start")
			await score_add_anim.animation_finished
			
			score_add_anim.play("score added")
			score_value.text = str(score + 1)
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
	var pivot = get_viewport_rect().size / 2 - Vector2(card.size.x * cards_scale / 2.0, 0)
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
		timeline_card.global_position.x = lerp(timeline_card.global_position.x, pivot.x + (pos_offset_array[i] * timeline_card.size.x * cards_scale) + drag_offset_x, 0.1)
		timeline_card.global_position.y = lerp(timeline_card.global_position.y, timeline_card_orgin.y, 0.1)
		i += 1

func find_index(x_pos):
	var index = 0
	for timeline_card in timeline_cards.get_children():
		if timeline_card.global_position.x < x_pos:
			index += 1
	return index
