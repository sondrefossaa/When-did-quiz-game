@tool
extends Resource
class_name CSVResource

@export var csv_path: String = "res://questions/qtest.csv"
@export var questions: Array = []  # Remove the [Array] type hint for flexibility

@export var load_now: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			questions = read_csv_file(csv_path)
			print("Manually loaded questions: ", questions.size(), " rows.")
			# Save automatically
			ResourceSaver.save(self, resource_path)
			load_now = false  # Reset the toggle

func read_csv_file(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		printerr("Failed to open file at: ", path, " Error: ", error)
		return []

	var rows = []
	while not file.eof_reached():
		var line = file.get_line()
		if line.strip_edges().is_empty():
			continue  # Skip empty lines
		var cells = line.split(",")
		# Remove quotes and trim each cell
		for i in cells.size():
			cells[i] = cells[i].replace('"', '').strip_edges()
		rows.append(cells)

	file.close()
	return rows

# Optional: Add a function to get questions by index
func get_question(index: int) -> Array:
	if index >= 0 and index < questions.size():
		return questions[index]
	return []

# Optional: Add a function to get the number of questions
func get_question_count() -> int:
	return questions.size()
