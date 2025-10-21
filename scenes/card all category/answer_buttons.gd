extends HBoxContainer
@onready var buttons = self.get_children()
var right = false
signal new_question(correct)

@onready var card = $"../../.."
@onready var new_answer_timer = %"new answer timer"
@onready var buttons_bg = $"../.."
@onready var score_value = %"Score value"
@onready var score_add_anim = %"score add anim"
@onready var cards_count = %"cards count"


var normal_panel_style = preload("res://visual/themes/multiple category card/Card panel style.tres")
var normal_theme = preload("res://visual/themes/multiple category card/normal theme.tres")
var button_style = preload("res://visual/themes/multiple category card/button style.tres")
const WRONG_THEME = preload("res://visual/themes/multiple category card/wrong theme.tres")
const CORRECT_THEME = preload("res://visual/themes/multiple category card/correct theme.tres")
const NORMAL_THEME = preload("uid://cdhu03nh24i37")

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
		var new_color = Color(CategoryThemeManager.category_colors[card.current_category])
		button.add_theme_color_override("font_hover_color", new_color)
		button.add_theme_color_override("font_color", new_color)
		button.add_theme_color_override("font_hover_pressed_color", new_color)
		button.add_theme_color_override("font_focus_color", new_color)


		
func answer_chosen(correct):
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
		normal_panel_style.border_color = Color.GREEN
		right = true
	else:
		score_value.text = str(score_value.text.to_int() + 1)
		score_add_anim.play("score added start")
		await score_add_anim.animation_finished
		score_add_anim.play("score added")
		if score_value.text.to_int() > 3:
			var base_scene = get_tree().get_root().get_child(1)
			base_scene.play_fail(cards_count.text.to_int())
		normal_panel_style.border_color = Color.RED
		right = false
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
