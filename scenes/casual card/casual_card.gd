extends Control
@onready var question_generator = $"question generator"
@onready var cards_container = $"cards container"
@onready var cards = cards_container.get_children()
const CARD = preload("uid://fi246xsplije")
const CARD_WIDTH = 718.2
const card_margin = 70
var question : Dictionary
var answer_btn_def_text = "Show answer"

var prev_pos := 0.0
var dragging := false
var cur_velocity := 0.0
var movement := 0.0
var speed := 0.0
# TODO change velocity manually for smoother feel
func _input(event):
	if event is InputEventScreenDrag:
		drag_cards(event.relative.x)
		dragging = true
		cur_velocity = speed
	else:
		dragging = false

func drag_cards(delta_x: float) -> void:
	for card in cards:
		card.position.x += delta_x
	speed = delta_x / get_process_delta_time()
func _ready():
	# Make competitive specific featur invisible
	for card in cards:
		card.player_answer_text.visible = false
		card.answer_text.visible = false


func _process(delta):
	var screen_width = get_viewport_rect().size.x
	cards = cards_container.get_children()
	var max_min = get_max_min_width()
	if cur_velocity != 0 and not dragging:
		drag_cards(cur_velocity * delta)
		cur_velocity = lerp(cur_velocity, 0.0, delta * 1.0)

	if max_min.min.global_position.x > -CARD_WIDTH:
		spawn_new_card("start", max_min.min.global_position.x)
		
	if max_min.max.global_position.x < screen_width:
		spawn_new_card("end", max_min.max.global_position.x)
	
func spawn_new_card(pos: String, card_pos) -> void:
	var temp_card := cards[0].duplicate() as Control
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
	var max_width = -100000000000000000
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
