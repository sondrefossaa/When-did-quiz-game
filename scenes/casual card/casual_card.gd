extends Control
@onready var question_generator = $"question generator"
@onready var card_scroll_buton : Button= $"card scroll buton"
@onready var cards_container = $"cards container"
@onready var cards = cards_container.get_children()
const CARD = preload("uid://fi246xsplije")
const CARD_WIDTH = 718.2
const card_margin = 70
var question : Dictionary
var answer_btn_def_text = "Show answer"
var prev_pos := Vector2.ZERO

var dragging := false
var drag_start := Vector2.ZERO

# TODO is laggy on mobile, fix
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			drag_start = event.position
		else:
			dragging = false
	elif event is InputEventScreenDrag and dragging:
		var delta = event.position - drag_start
		drag_cards(delta.x)
		drag_start = event.position

func drag_cards(delta_x: float) -> void:
	for card in cards:
		card.global_position.x += delta_x

func _ready():
	for card in cards:
		card.player_answer_text.visible = false
		card.answer_text.visible = false


func _process(_delta):
	var screen_width = get_viewport_rect().size.x
	cards = cards_container.get_children()
	var max_min = get_max_min_width()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var change = get_global_mouse_position() - prev_pos
		drag_cards(change.x)
	if max_min.min.global_position.x > - CARD_WIDTH:
		spawn_new_card("start", max_min.min.global_position.x)
# 718.2 is card width
	if max_min.max.global_position.x < screen_width:
		spawn_new_card("end", max_min.max.global_position.x)
	
	prev_pos = get_global_mouse_position()
	
func spawn_new_card(pos: String, card_pos) -> void:
	var temp_card := cards[0].duplicate() as Control
	#temp_card.show_answer_btn.text = temp_card.SHOW_ANSWER_DEF
	cards_container.add_child(temp_card)
	match pos:
		# Spawn at end
		"end":
			temp_card.global_position = Vector2(card_pos+CARD_WIDTH+card_margin, 428)
		# Spawn at start
		"start":
			temp_card.global_position = Vector2(card_pos-CARD_WIDTH-card_margin, 428)
		_:
			push_warning("spawn_new_card: Unknown position '%s'" % pos)
	cards = cards_container.get_children()

func get_max_min_width():
	var max_width = 0
	var min_width = 1000000000000000000
	var max_card = null
	var min_card = null
	for card in cards:
		if card.global_position.x > max_width:
			max_width = card.global_position.x
			max_card = card
		if card.global_position.x < min_width:
			min_width = card.global_position.x
			min_card = card
	return {"min" : min_card, "max" : max_card}
