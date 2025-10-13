extends Label


var speed = 1.0
var direction : Vector2 = Vector2(1, 1)
var rotation_speed = 0
var color = "#38b6ff"
var font_size = 10
var def_font = 180
var can_die = false
func _ready():
	text = str(randi_range(0,2025))
	await get_tree().create_timer(1.0).timeout
	can_die = true

func _process(delta):
	position += speed * direction * delta * 60
	rotation += deg_to_rad(rotation_speed)
	color_offset_by_size()
	add_theme_color_override("font_color", color)
	add_theme_font_size_override("font_size", font_size)
	if can_die:
		check_boundary()

func color_offset_by_size():
	var difference = abs(def_font - font_size)
	# Use a small multiplier to control how much alpha changes
	var alpha_factor = difference * 0.00001  # Adjust this value as needed
	speed += speed * difference * 0.00001
	# Start from original color and adjust alpha
	color.a = clamp(color.a - alpha_factor, 0.1, 1.0)  # Keep some visibility
	
func check_boundary():
	var viewport_size = get_viewport().get_visible_rect().size
	var offset = 500
	
	# Quick boundary check
	if (position.x < -offset || position.x > viewport_size.x + offset ||
		position.y < -offset || position.y > viewport_size.y + offset):
		queue_free()
