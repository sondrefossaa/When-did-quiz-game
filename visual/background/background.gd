extends Node

# TODO fix floater spawn position
@onready var main_bg = $"main bg"
@onready var floaters = $floaters
const BG_FLOATER = preload("uid://3tfn7w2ooy63")
const LABEL_FLOATER = preload("uid://c1qnak6hnx2u8")

var spawn_interval = 1
var color_C : Color
var viewport_size = Vector2(1080, 2400)


# Define variables for floaters
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
	Global.theme_changed.connect(change_theme)
	for i in range(0, floaters.size.x, 500):
		for j in range(0, floaters.size.y, 500):
			var temp_floater = make_label_floater()
			temp_floater.position = Vector2(i, j)
			floaters.add_child(temp_floater)
	spawn_floaters()
func change_theme(_category_name, new_color):
	color_C = Color(new_color)
	main_bg.color = new_color
	for floater in floaters.get_children():
		floater.color = color_C.lightened(0.2)
	change_direction()
func spawn_floaters():
	for i in range(floater_count):
		var temp_floaterX = make_label_floater()
		var temp_floaterY = make_label_floater()
		temp_floaterX.position = Vector2(i * interval.x, spawn.start_point.y) + spawn_offset * -spawn.direction
		temp_floaterY.position = Vector2(spawn.start_point.x, i * interval.y) + spawn_offset * -spawn.direction
		if i == 0:
			floaters.add_child(temp_floaterX)
		else:
			floaters.add_child(temp_floaterX)
			floaters.add_child(temp_floaterY)
		#print(temp_floaterX.position, ", ", temp_floaterY.position )
		
	await get_tree().create_timer(spawn_interval).timeout
	spawn_floaters()
	
func make_floater():
	var temp_floater = BG_FLOATER.instantiate()
	temp_floater.speed = speed
	temp_floater.color = color_C.lightened(0.2)
	temp_floater.scale = Vector2(randi_range(3, 5), randi_range(3, 5))
	temp_floater.direction = direction
	temp_floater.rotation_speed = randi_range(-2, 2)
	
	return temp_floater

func make_label_floater():
	var temp_floater = LABEL_FLOATER.instantiate()
	temp_floater.speed = speed
	temp_floater.color = color_C.lightened(0.2)
	temp_floater.font_size = randi_range(80, 200)
	temp_floater.direction = direction
	#temp_floater.rotation_speed = randi_range(-1, 1)
	
	return temp_floater


func change_direction():
	var new_direction = spawn_directions.keys().pick_random()
	spawn = spawn_directions[new_direction]
	#spawn = spawn_directions.top_left
	direction = spawn.direction * org_direction
	
	for floater in floaters.get_children():
		floater.direction = direction
	
