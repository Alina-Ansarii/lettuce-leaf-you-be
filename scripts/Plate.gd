extends Control
class_name Plate

## The plate on the counter. Ingredients dragged onto it stack up as
## little food icons (the *-plate.png art). Still tracks the ingredient
## id list so GameManager can order-match.

signal contents_changed(ingredients: Array)

var ingredients: Array[String] = []

# maps an ingredient id to its plated-food texture. "beet" -> beets art.
const PLATED_ICONS := {
	"fern": "res://art/food/fern-plate.png",
	"bamboo": "res://art/food/bamboo-plate.png",
	"cactus": "res://art/food/cactus-plate.png",
	"beet": "res://art/food/beets-plate.png",
	"mushroom": "res://art/food/mushroom-plate.png",
	"flower": "res://art/food/flower-plate.png",
}

func _ready() -> void:
	add_to_group("plate")

func add_ingredient(id: String) -> void:
	ingredients.append(id)
	_spawn_icon(id)
	contents_changed.emit(ingredients)

func clear_plate() -> void:
	ingredients.clear()
	#remove only the food icons we spawned (they're in the "food_icon" group),
	#never the plate background art (PlateTex).
	for child in get_children():
		if child.is_in_group("food_icon"):
			child.queue_free()
	contents_changed.emit(ingredients)

#drops a plated-food icon onto the plate, scattered a little so it piles.
func _spawn_icon(id: String) -> void:
	var path: String = PLATED_ICONS.get(id, "")
	if path == "" or not ResourceLoader.exists(path):
		return
	var icon := TextureRect.new()
	icon.add_to_group("food_icon")
	icon.texture = load(path)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(48, 48)
	icon.size = Vector2(48, 48)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#scatter within the plate so multiple items look piled on.
	var n := ingredients.size()
	var px := 20 + (n * 29) % 90
	var py := 8 + ((n * 17) % 30)
	icon.position = Vector2(px, py)
	add_child(icon)
