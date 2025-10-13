extends HBoxContainer
@onready var buttons = self.get_children()
var right = false
signal new_question(correct)
@onready var card = $"../../../.."
@onready var new_answer_timer = $"../../../../new answer timer"
@onready var card_outline = $"../../../../Panelcontainer"
var normal_panel_style = preload("res://visual/themes/multiple category card/Card panel style.tres")
var normal_theme = preload("res://visual/themes/multiple category card/normal theme.tres")
var button_style = preload("res://visual/themes/multiple category card/button style.tres")
const WRONG_THEME = preload("res://visual/themes/multiple category card/wrong theme.tres")
const CORRECT_THEME = preload("res://visual/themes/multiple category card/correct theme.tres")
var question_color = {
	"science" : "#38b6ff",
	"history" : "#ffde59",
	"pop" : "#955fff",
	"trivia" : "#ff3939",
	"sport" : "#00bf63",
}
func _ready():
	update_color()
	for button in buttons:
		button.answer_chosen.connect(answer_chosen)

func update_color():
	normal_panel_style.border_color = Color.BLACK
	for button in buttons:
		var new_color = Color(question_color[card.current_category])
		#button.add_theme_color_override("font_color", Color.WEB_GRAY)
		button.add_theme_color_override("font_hover_color", new_color)
		button.add_theme_color_override("font_color", new_color)
		button.add_theme_color_override("font_hover_pressed_color", new_color)
		button.add_theme_color_override("font_focus_color", new_color)

func answer_chosen(correct, clicked_button):
	var disabled_correct_stylebox := StyleBoxFlat.new()
	disabled_correct_stylebox.bg_color = Color.GREEN
	var disabled_wrong_stylebox := StyleBoxFlat.new()
	disabled_wrong_stylebox.bg_color = Color.RED
	#disabled_wrong_stylebox.font_color = Color.BLACK
	for button in buttons:
		button.disabled = true
		if button.correct == true:
			button.theme = CORRECT_THEME
		else:
			button.theme = WRONG_THEME
	if correct:
		right = true
		"""button.add_theme_color_override("font_hover_color", Color.GREEN)
		button.add_theme_color_override("font_color", Color.GREEN)
		button.add_theme_color_override("font_hover_pressed_color", Color.GREEN)
		button.add_theme_color_override("font_focus_color", Color.GREEN)"""
		normal_panel_style.border_color = Color.GREEN
		
	else:
		normal_panel_style.border_color = Color.RED
		right = false
		#card_outline.border_color = Color.GREEN
		"""button.add_theme_color_override("font_hover_color", Color.RED)
		button.add_theme_color_override("font_color", Color.RED)
		button.add_theme_color_override("font_hover_pressed_color", Color.RED)
		button.add_theme_color_override("font_focus_color", Color.RED)"""
	new_answer_timer.start()

func _on_new_answer_timer_timeout():
	right = false
	for button in buttons:
		button.disabled = false
		button.correct = false
	emit_signal("new_question")
	update_color()
	for button in buttons:
		button.theme = normal_theme
		#button.add_theme_stylebox_override("disabled", button_style)
