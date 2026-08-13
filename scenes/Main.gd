extends Control

@onready var name_label: Label = $NameLabel
@onready var dialogue_label: Label = $DialogueLabel
@onready var serve_button: Button = $ServeButton
@onready var shoo_button: Button = $ShooButton
@onready var result_label: Label = $ResultLabel

var current_customer: Customer = preload("res://data/customers/Trisha.tres")

func _ready() -> void:
	name_label.text = current_customer.display_name
	dialogue_label.text = current_customer.dialogue_line
	result_label.text = ""
	
	#connect buttons to functions
	serve_button.pressed.connect(_on_serve)
	shoo_button.pressed.connect(_on_shoo)

#if not not SHOO then serve
func _on_serve() -> void:
	_judge(false)
	
func _on_shoo()-> void:
	_judge(true)
	
func _judge(chose_shoo: bool) -> void:
	var correct := Game.judge(current_customer, chose_shoo)
	
	if correct:
		result_label.text = "CORRECT (score: %d)" % Game.score
	else:
		result_label.text = "WRONG (lives: %d)" % Game.lives
