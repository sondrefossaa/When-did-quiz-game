extends Control
@onready var card = $card
@onready var hover_start_btn = card.get_node("Hover start")
@onready var hover_col : Area2D = card.get_node("card hover col")

@onready var timeline_cards = $"timeline cards"

var hovering := false
var offset := Vector2.ZERO
var added = false
var hover_over := false
func _ready():
	hover_start_btn.button_down.connect(hover_start)
	hover_start_btn.button_up.connect(hover_end)
	update_card_pos()
func hover_start():
	hovering = true
	offset = card.global_position - get_global_mouse_position()
func hover_end():
	hovering = false

func _process(_delta):
	if hovering:
		card.global_position = get_global_mouse_position() + offset
	update_card_pos()




func _on_card_drop_area_area_entered(_area):
	hover_over = true


func _on_card_drop_area_area_exited(_area):
	hover_over = false

func update_card_pos():
	var pivot = get_viewport_rect().size / 2 - Vector2(card.size.x * 0.2, 0)
	var cards = timeline_cards.get_children()
	if hover_over:
		cards.append(card)
	var pos_offset_array := []
	
	for i in range(cards.size()):
		var temp = i-cards.size() / 2.0
		pos_offset_array.append(temp+0.5)

	var i = 0
	for timeline_card in cards:
		timeline_card.global_position.x = pivot.x + (pos_offset_array[i] * timeline_card.size.x * 0.4)
		i += 1
