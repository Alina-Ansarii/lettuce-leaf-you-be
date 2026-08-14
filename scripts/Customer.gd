class_name Customer
extends Resource

@export var display_name: String = "Dino"
@export var is_carnivore: bool = false

#----------------DIALOGUE------------------
#the customer speaks intro_lines one at a time (click Next to advance them).
#then the player may press "Ask" to hear the answer to a probing question -
#a good clue for spotting a carnivore. finally the player judges.
@export_group("Dialogue")
@export_multiline var intro_lines: Array[String] = ["..."]   # said on arrival, line by line

@export var question_prompt: String = "So... what'll it be?"  # label on the Ask button
@export_multiline var question_answer: String = ""            # what they say when asked

#reaction lines - what they say after you judge. leave empty to skip.
@export_multiline var served_right: String = ""   # herbivore you correctly served
@export_multiline var served_wrong: String = ""   # carnivore you wrongly served (it wins)
@export_multiline var shooed_right: String = ""   # carnivore you correctly caught
@export_multiline var shooed_wrong: String = ""   # herbivore you wrongly shooed (upset)

#----------------PORTRAITS------------------
@export_group("Portraits")
@export var portrait_neutral: Texture2D
@export var portrait_happy: Texture2D
@export var portrait_angry: Texture2D
@export var portrait_caught: Texture2D
