extends Control
class_name DraggableIngredient

## Attach this to a small Control node in the ingredient tray.
## Expected children (placeholder art, swap for real icons later):
##   ColorRect  (fills the box, tinted by ingredient_id)
##   Label      (shows the ingredient name)
##
## The item is a reusable tray button, not consumed on drag -
## dropping it on the Plate adds one copy and it snaps back to the tray.
## While dragging, if the item passes over the customer Portrait, we tell
## Main so a disguised carnivore can flash its disgusted face.

@export var ingredient_id: String = "fern"

var _dragging := false
var _drag_offset := Vector2.ZERO
var _origin_position: Vector2

func _ready() -> void:
	_origin_position = position
	if has_node("Label"):
		$Label.text = ingredient_id.capitalize()
	if has_node("ColorRect"):
		$ColorRect.color = IngredientData.get_color(ingredient_id)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			_drag_offset = get_global_mouse_position() - global_position
			move_to_front()
		else:
			_dragging = false
			_notify_portrait(false)   # dropped: clear any disgust
			_try_drop()
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset
		_notify_portrait(_over_portrait())

func _over_portrait() -> bool:
	var portrait := get_tree().get_first_node_in_group("portrait")
	if portrait == null:
		return false
	return portrait.get_global_rect().has_point(get_global_mouse_position())

func _notify_portrait(is_near: bool) -> void:
	# Main is the scene root; it exposes notify_food_near_portrait().
	var root := get_tree().current_scene
	if root != null and root.has_method("notify_food_near_portrait"):
		root.notify_food_near_portrait(is_near)

func _try_drop() -> void:
	var plate := get_tree().get_first_node_in_group("plate")
	if plate and plate.get_global_rect().has_point(get_global_mouse_position()):
		plate.add_ingredient(ingredient_id)
	# always snap back - the tray button is reusable
	var tween := create_tween()
	tween.tween_property(self, "position", _origin_position, 0.12)
