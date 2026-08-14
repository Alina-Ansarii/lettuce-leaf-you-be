extends Control

@onready var name_label: Label = $NameLabel
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel
@onready var serve_button: Button = $ServeButton
@onready var shoo_button: Button = $ShooButton
@onready var result_label: Label = $ResultLabel
@onready var portrait: TextureRect = $Portrait
@onready var next_button: Button = $NextButton
@onready var plate: Plate = $Plate

var day_one: Array[Customer] = [
	preload("res://data/customers/Trisha.tres"),
	preload("res://data/customers/Steg.tres"),
	preload("res://data/customers/Ray.tres"),
	preload("res://data/customers/Bronte.tres"),
]

#check for if we are currently in between customers
var awaiting_advance := false

#----------------TYPEWRITER STATE------------------
var full_line := ""              # the complete line we're revealing
var shown_chars := 0             # how many characters are visible so far
var is_typing := false           # true while letters are still appearing
const TYPE_SPEED := 0.03         # seconds between letters (smaller = faster)
var _type_timer: Timer           # ticks once per letter

func _ready() -> void:
	Game.start_day(day_one)

	serve_button.pressed.connect(_on_serve)
	shoo_button.pressed.connect(_on_shoo)
	next_button.pressed.connect(_advance)

	# Build the typewriter timer in code (no scene node needed).
	_type_timer = Timer.new()
	_type_timer.wait_time = TYPE_SPEED
	_type_timer.timeout.connect(_on_type_tick)
	add_child(_type_timer)

	_show_current_customer()

func _show_current_customer() -> void:
	var cust: Customer = Game.get_current_customer()

	if cust == null:
		_end_day()
		return

	plate.clear_plate()

	awaiting_advance = false
	result_label.text = ""
	name_label.text = cust.display_name
	_set_portrait(cust.portrait_neutral)
	_set_buttons_enabled(true)
	next_button.visible = false              # hide Next until they've judged

	_start_typing(_first_line(cust))         # type the dialogue out

func _first_line(cust: Customer) -> String:
	var dialogue = cust.dialogue_line
	if dialogue is Array:
		return str(dialogue[0]) if dialogue.size() > 0 else ""

	return str(dialogue)

#---------------------TYPEWRITER------------------------
#begin revealing a line one character at a time.
func _start_typing(text: String) -> void:
	full_line = text
	shown_chars = 0
	dialogue_label.text = ""
	is_typing = true
	_type_timer.start()

#called by the timer once per letter.
func _on_type_tick() -> void:
	shown_chars += 1
	dialogue_label.text = full_line.substr(0, shown_chars)
	if shown_chars >= full_line.length():
		_finish_typing()

#instantly show the whole line
func _finish_typing() -> void:
	_type_timer.stop()
	dialogue_label.text = full_line
	shown_chars = full_line.length()
	is_typing = false

#---------------------TEMPORARY PORTRAIT HANDLING
func _set_portrait(tex: Texture2D) -> void:
	if tex != null:
		portrait.texture = tex



#----------------JUDGING------------------------
#if not not SHOO then serve
func _on_serve() -> void:
	if is_typing:
		_finish_typing()                      # first click just completes the text
		return
	if awaiting_advance:
		return                                # already judged; use Next
	_judge(false)

func _on_shoo()-> void:
	if is_typing:
		_finish_typing()                      # first click just completes the text
		return
	if awaiting_advance:
		return                                # already judged; use Next
	_judge(true)

func _judge(chose_shoo: bool) -> void:
	var cust: Customer = Game.get_current_customer()
	if cust == null:
		return

	var correct: bool = Game.judge(cust, chose_shoo)

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
	_set_buttons_enabled(false)              # lock Serve/Shoo after judging
	next_button.visible = true               # reveal Next so they can move on

	if Game.is_game_over():
		_game_over()


#--------------Advancing

func _advance() -> void:
	var has_more: bool = Game.next_customer()
	if has_more:
		_show_current_customer()
	else:
		_end_day()

func _end_day() -> void:
	_finish_typing()
	_set_buttons_enabled(false)
	next_button.visible = false
	name_label.text = "Day %d complete!" % Game.day
	dialogue_label.text = ""
	result_label.text = "Score: %d    Lives: %d" % [Game.score, Game.lives]

func _game_over() -> void:
	_finish_typing()
	_set_buttons_enabled(false)
	next_button.visible = false
	name_label.text = "GAME OVER"
	dialogue_label.text = "The cafe closed for good."
	result_label.text = "Final score: %d" % Game.score

func _set_buttons_enabled(on: bool) -> void:
	serve_button.disabled = not on
	shoo_button.disabled = not on
