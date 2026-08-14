class_name Customer
extends Resource

@export var display_name: String = "Dino"
@export var is_carnivore: bool = false
@export_multiline var dialogue_line: String = "..."

## Portrait states — used by Main.gd's expression-swap logic.
## Fill these in per-customer in the Inspector. It's fine to leave
## happy/caught/angry blank while art isn't ready yet; _set_portrait()
## in Main.gd already guards against null textures.
@export var portrait_neutral: Texture2D
@export var portrait_happy: Texture2D
@export var portrait_caught: Texture2D
@export var portrait_angry: Texture2D

## Order matching. Leave empty for a customer with no specific order
## (e.g. Trisha still works untouched, defaults to []).
## Use ids from IngredientData.ALL_IDS: fern, bamboo, cactus, beet,
## mushroom, flower.
@export var wanted_ingredients: Array[String] = []

## Patience timer, in seconds. How long before this customer gets
## impatient and leaves if you haven't served/shooed them yet.
@export var patience_seconds: float = 15.0
