class_name Customer
extends Resource

@export var display_name: String = "Dino"
@export var is_carnivore: bool = false

#dialogue
@export_multiline var dialogue_line: String = "..."

#portraits and expressions
@export_group("Portraits")
@export var portrait_neutral: Texture2D
@export var portrait_happy: Texture2D
@export var portrait_angry: Texture2D
@export var portrait_caught: Texture2D  
