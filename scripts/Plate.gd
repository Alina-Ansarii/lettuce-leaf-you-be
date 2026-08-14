extends Control
class_name Plate

## Attach to a Control on the counter. Add ONE child Label (call it
## PlateLabel) so contents are readable before real plate art exists.

signal contents_changed(ingredients: Array)

var ingredients: Array[String] = []

func _ready() -> void:
	add_to_group("plate")
	_refresh_visual()

func add_ingredient(id: String) -> void:
	ingredients.append(id)
	contents_changed.emit(ingredients)
	_refresh_visual()

func clear_plate() -> void:
	ingredients.clear()
	contents_changed.emit(ingredients)
	_refresh_visual()

func _refresh_visual() -> void:
	if has_node("PlateLabel"):
		$PlateLabel.text = "Plate: %s" % (", ".join(ingredients) if ingredients.size() > 0 else "empty")
