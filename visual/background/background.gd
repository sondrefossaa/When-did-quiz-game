extends Node

# TODO fix floater spawn position
@onready var main_bg = $"main bg"
@onready var floaters = $floaters
@onready var question_generator = $"question generator"
@onready var backgound_viewport = $"../.."

const BG_FLOATER = preload("uid://3tfn7w2ooy63")
const LABEL_FLOATER = preload("uid://c1qnak6hnx2u8")

var spawn_interval = 1
var color_C : Color = Color.BLACK
var viewport_size = Vector2(1080, 2400)

# Define variables for floaters
var floater_type
var floater_count = 3
var org_direction : Vector2 = viewport_size.normalized()
var direction : Vector2 = org_direction
var speed = 3

var interval = Vector2(viewport_size.x / floater_count, viewport_size.y / floater_count)
var spawn_offset =Vector2(500, 500)
var spawn_directions : Dictionary = {
	"top_left" = {
		"start_point" : Vector2(0, 0), # Top-left corner
		"direction" : Vector2(1, 1) # Toward bottom-right
	},
	"top_right" = {
		"start_point" : Vector2(viewport_size.x, 0), # Top-right corner
		"direction" : Vector2(-1, 1) # Toward bottom-left
	},
	"bottom_right" = {
		"start_point" : Vector2(viewport_size.x, viewport_size.y), # Bottom-right corner
		"direction" : Vector2(-1, -1) # Toward top-left
	},
	"bottom_left" = {
		"start_point" : Vector2(0, viewport_size.y), # Bottom-left corner
		"direction" : Vector2(1, -1) # Toward top-right
	}
}
var spawn : Dictionary = spawn_directions[spawn_directions.keys().pick_random()]

func _ready():
	if backgound_viewport.floater_type == 0:
		floater_type = "question"
	if backgound_viewport.floater_type == 1:
		floater_type = "year"
	Global.theme_changed.connect(change_theme)
	for i in range(0, backgound_viewport.size.x, 500):
		for j in range(0, backgound_viewport.size.y, 500):
			var temp_floater : Label
			if floater_type ==  "year":
				temp_floater = make_year_floater()
			elif floater_type == "question":
				temp_floater = make_question_floater()
			temp_floater.position = Vector2(i, j)
			floaters.add_child(temp_floater)
	spawn_floaters()

func change_theme(_category_name, new_color):
	print(2)
	color_C = Color(new_color)
	main_bg.color = new_color
	for floater in floaters.get_children():
		floater.color = color_C.lightened(0.2)
	change_direction()
func spawn_floaters():
	for i in range(floater_count):
		var temp_floaterX : Label
		var temp_floaterY : Label
		if floater_type ==  "year":
			temp_floaterX = make_year_floater()
			temp_floaterY = make_year_floater()
		elif floater_type == "question":
			temp_floaterX = make_question_floater()
			temp_floaterY = make_question_floater()
		temp_floaterX.position = Vector2(i * interval.x, spawn.start_point.y) + spawn_offset * -spawn.direction
		temp_floaterY.position = Vector2(spawn.start_point.x, i * interval.y) + spawn_offset * -spawn.direction
		if i == 0:
			floaters.add_child(temp_floaterX)
		else:
			floaters.add_child(temp_floaterX)
			floaters.add_child(temp_floaterY)
		
	await get_tree().create_timer(spawn_interval).timeout
	spawn_floaters()
	
func make_square_floater():
	var temp_floater = BG_FLOATER.instantiate()
	temp_floater.speed = speed
	temp_floater.color = color_C.lightened(0.2)
	temp_floater.scale = Vector2(randi_range(3, 5), randi_range(3, 5))
	temp_floater.direction = direction
	temp_floater.rotation_speed = randi_range(-2, 2)
	
	return temp_floater

func make_year_floater():
	var temp_floater = LABEL_FLOATER.instantiate()
	temp_floater.speed = speed
	temp_floater.color = color_C.lightened(0.2)
	temp_floater.font_size = randi_range(80, 200)
	temp_floater.direction = direction
	temp_floater.text = str(randi_range(0,2025))
	#temp_floater.rotation_speed = randi_range(-1, 1)
	return temp_floater

func make_question_floater():
	var temp_question = question_generator.create_question()
	var temp_floater = LABEL_FLOATER.instantiate()
	temp_floater.speed = speed
	temp_floater.font_size = randi_range(10, 50)
	temp_floater.direction = direction
	temp_floater.text = temp_question.question
	#color_C = Global.theme_colors[temp_question.category]
	temp_floater.color = color_C.lightened(0.5)
	return temp_floater


func change_direction():
	var new_direction = spawn_directions.keys().pick_random()
	spawn = spawn_directions[new_direction]
	#spawn = spawn_directions.top_left
	direction = spawn.direction * org_direction
	for floater in floaters.get_children():
		floater.direction = direction
	
