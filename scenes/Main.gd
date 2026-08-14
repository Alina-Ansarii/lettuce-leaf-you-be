extends Control

@onready var name_label: Label = $NameLabel
@onready var dialogue_label: Label = $DialogueLabel
@onready var serve_button: Button = $ServeButton
@onready var shoo_button: Button = $ShooButton
@onready var result_label: Label = $ResultLabel
@onready var portrait: TextureRect = $Portrait

var day_one: Array[Customer] = [
	preload("res://data/customers/Trisha.tres"),
	preload("res://data/customers/Steg.tres"),
	preload("res://data/customers/Ray.tres"),
	preload("res://data/customers/Bronte.tres"),	
]

#check for if we are currently in between customers
var awaiting_advance := false

func _ready() -> void:
	Game.start_day(day_one)
	
	serve_button.pressed.connect(_on_serve)
	shoo_button.pressed.connect(_on_shoo)
	
	_show_current_customer()
	
func _show_current_customer() -> void:
	var cust := Game.get_current_customer()
	
	if cust == null:
		_end_day()
		return
	
	awaiting_advance = false
	result_label.text = ""
	name_label.text = cust.display_name
	dialogue_label.text = _first_line(cust)
	_set_portrait(cust.portrait_neutral)
	_set_buttons_enabled(true)
	
func _first_line(cust: Customer) -> String:
	var dialogue = cust.dialogue_line
	if dialogue is Array:
		return str(dialogue[0]) if dialogue.size() > 0 else ""
	
	return str(dialogue)	
	
#---------------------TEMPORARY PORTRAIT HANDLING 
func _set_portrait(tex: Texture2D) -> void:
	if tex != null:
		portrait.texture = tex
		
		
		
#----------------JUDGING------------------------
#if not not SHOO then serve
func _on_serve() -> void:
	if awaiting_advance:
		_advance()
	else:
		_judge(false)
	
func _on_shoo()-> void:
	if awaiting_advance:
		_advance()
	else:
		_judge(true)

func _judge(chose_shoo: bool) -> void:
	var cust := Game.get_current_customer()
	if cust == null:
		return
		
	var correct := Game.judge(cust, chose_shoo)
	
	#expression handling
	if correct:
		if chose_shoo:
			_set_portrait(cust.portrait_caught)
		else:
			_set_portrait(cust.portrait_happy)
		result_label.text = "CORRECT!"
	else:
		_set_portrait(cust.portrait_angry)
		result_label.text = "WRONG (lives: %d)" % Game.lives
	
	awaiting_advance = true
	
	if Game.is_game_over():
		_game_over()
		
		
#--------------Advancing

func _advance() -> void:
	var has_more := Game.next_customer()
	if has_more:
		_show_current_customer()
	else:
		_end_day()
		
func _end_day() -> void:
	_set_buttons_enabled(false)
	name_label.text = "Day %d complete!" % Game.day
	dialogue_label.text = ""
	result_label.text = "Score: %d    Lives: %d" % [Game.score, Game.lives]
	
func _game_over() -> void:
	_set_buttons_enabled(false)
	name_label.text = "GAME OVER"
	dialogue_label.text = "The cafe closed for good."
	result_label.text = "Final score: %d" % Game.score
 
func _set_buttons_enabled(on: bool) -> void:
	serve_button.disabled = not on
	shoo_button.disabled = not on
