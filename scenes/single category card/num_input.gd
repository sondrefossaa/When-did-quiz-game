extends PanelContainer
@onready var card = $"../Card"

@onready var score_value = %"Score value"
@onready var answer_input = %"player answer text"


@onready var back_button = $"Number input/Row4/back button"
@onready var confirm_button = $"Number input/Row4/confirm button"
@onready var single_category_card = $".."

@export var numpad : Array[Button]
var CALCULATOR_BUTTON_THEME = preload("res://visual/themes/single category card/card_general_theme.tres")
var answer_confirmed = false
var blank_input_score = 1000
func _ready():
	#category_theme_manager.connect("theme_changed", update_button_theme)
	for button in numpad:
		button.pressed.connect(register_button_input.bind(button))
	back_button.pressed.connect(register_button_input.bind(back_button))
	confirm_button.pressed.connect(register_button_input.bind(confirm_button))

func register_button_input(pressed_button :Button):
	if pressed_button.is_in_group("numpad"):
		if answer_input.text.length() < 4 and answer_input.text != "?":
			answer_input.text += pressed_button.text
			
	if pressed_button.is_in_group("back"):
		if answer_input.text:
			answer_input.text = answer_input.text.substr(0, answer_input.text.length() - 1)
			
	if pressed_button.is_in_group("confirm"):
		if answer_input.text.length() > 0:
			answer_confirmed = true
			single_category_card.calculate_score()




#func update_button_theme(category, new_color):
	#return
	#var stylebox := CALCULATOR_BUTTON_THEME.get_stylebox("normal", "Button")
	#stylebox.bg_color = Color(new_color)
	
