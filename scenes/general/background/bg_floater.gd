extends ColorRect


var speed = 1.0
var direction : Vector2 = Vector2(1, 1)
var rotation_speed = 2
func _process(delta):
	position += speed * direction * delta
	rotation += deg_to_rad(rotation_speed)
