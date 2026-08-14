extends Control

#----------------NODE REFERENCES------------------
@onready var name_label: Label = $NameLabel
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel
@onready var result_label: Label = $ResultLabel
@onready var hud_label: Label = $HudLabel
@onready var portrait: TextureRect = $Portrait

@onready var serve_button: Button = $WorkZone/ServeButton
@onready var shoo_button: Button = $WorkZone/ShooButton
@onready var next_button: Button = $WorkZone/NextButton
@onready var ask_button: Button = $WorkZone/AskButton
@onready var plate: Panel = $WorkZone/Plate
@onready var ingredient_row: HBoxContainer = $WorkZone/IngredientRow

#----------------DAY ROSTERS------------------
#i split the customers across two days. day 2 is the harder shift (two carnivores).
#all art/data lives in the .tres files; this just picks who shows up when.
#each day's list must be typed Array[Customer] so it matches start_day().
var _day1: Array[Customer] = [
	preload("res://data/customers/Trisha.tres"),
	preload("res://data/customers/Steg.tres"),
	preload("res://data/customers/Ray.tres"),
]
var _day2: Array[Customer] = [
	preload("res://data/customers/Bronte.tres"),
	preload("res://data/customers/Compy.tres"),
	preload("res://data/customers/Ray.tres"),
]
var day_rosters := [_day1, _day2]

#----------------CONVERSATION STATE------------------
# phase drives what a click means right now:
#   "intro"  -> still reading the arrival lines
#   "ready"  -> intro done; player can Ask or judge
#   "judged" -> already judged; only Next works
var phase := "intro"
var intro_index := 0
var intro_lines: Array = []
var has_asked := false

#----------------ADVANCE STATE------------------
# what the Next button does: "customer" -> next dino, "newday" -> next day
var pending_advance := ""

#----------------PLATING STATE------------------
var plate_count := 0

#----------------TYPEWRITER STATE------------------
var full_line := ""
var shown_chars := 0
var is_typing := false
const TYPE_SPEED := 0.03
var _type_timer: Timer

func _ready() -> void:
	Game.reset()

	serve_button.pressed.connect(_on_serve)
	shoo_button.pressed.connect(_on_shoo)
	next_button.pressed.connect(_on_next)
	ask_button.pressed.connect(_on_ask)

	#wire every ingredient button to drop a placeholder on the plate.
	for btn in ingredient_row.get_children():
		if btn is Button:
			btn.pressed.connect(_on_ingredient_pressed)

	#typewriter timer, built in code.
	_type_timer = Timer.new()
	_type_timer.wait_time = TYPE_SPEED
	_type_timer.timeout.connect(_on_type_tick)
	add_child(_type_timer)

	Game.stats_changed.connect(_update_hud)

	Game.start_day(day_rosters[0])
	_update_hud()
	_show_current_customer()

#----------------SHOWING A CUSTOMER------------------
func _show_current_customer() -> void:
	var cust := Game.get_current_customer()
	if cust == null:
		_end_day()
		return

	#reset per-customer state.
	phase = "intro"
	intro_index = 0
	intro_lines = cust.intro_lines
	has_asked = false
	pending_advance = ""
	_clear_plate()

	result_label.text = ""
	name_label.text = cust.display_name
	_set_portrait(cust.portrait_neutral)

	#buttons: only Next is usable while reading intro lines.
	next_button.visible = true
	next_button.text = "Next"
	ask_button.visible = false
	_set_judge_enabled(false)
	_set_plating_enabled(false)

	_start_typing(_current_intro_line())

func _current_intro_line() -> String:
	if intro_index < intro_lines.size():
		return str(intro_lines[intro_index])
	return ""

#----------------THE ASK BUTTON------------------
func _on_ask() -> void:
	if phase != "ready" or has_asked:
		return
	var cust := Game.get_current_customer()
	if cust == null:
		return
	has_asked = true
	ask_button.visible = false
	if cust.question_answer != "":
		_start_typing(cust.question_answer)

#----------------JUDGING------------------------
func _on_serve() -> void:
	if is_typing:
		_finish_typing()
		return
	if phase != "ready":
		return
	if plate_count == 0:
		result_label.text = "Add something to the plate first!"
		return
	_judge(false)

func _on_shoo() -> void:
	if is_typing:
		_finish_typing()
		return
	if phase != "ready":
		return
	_judge(true)

func _judge(chose_shoo: bool) -> void:
	var cust := Game.get_current_customer()
	if cust == null:
		return

	var correct := Game.judge(cust, chose_shoo)

	#pick reaction line + expression for this exact outcome.
	var reaction := ""
	if correct:
		if chose_shoo:
			_set_portrait(cust.portrait_caught)   # carnivore caught -> fuss
			reaction = cust.shooed_right
		else:
			_set_portrait(cust.portrait_happy)    # herbivore served -> happy
			reaction = cust.served_right
		result_label.text = "CORRECT!"
	else:
		if chose_shoo:
			_set_portrait(cust.portrait_angry)    # herbivore wrongly shooed -> upset
			reaction = cust.shooed_wrong
		else:
			_set_portrait(cust.portrait_happy)    # carnivore fooled you -> it's happy
			reaction = cust.served_wrong
		result_label.text = "WRONG (lives: %d)" % Game.lives

	phase = "judged"
	_set_judge_enabled(false)
	_set_plating_enabled(false)
	ask_button.visible = false

	if reaction != "":
		_start_typing(reaction)

	if Game.is_game_over():
		_game_over()
	else:
		pending_advance = "customer"
		next_button.visible = true
		next_button.text = "Next"

#----------------ADVANCING------------------------
func _on_next() -> void:
	if is_typing:
		_finish_typing()
		return

	#still reading intro lines? show the next one.
	if phase == "intro":
		intro_index += 1
		if intro_index < intro_lines.size():
			_start_typing(_current_intro_line())
		else:
			_enter_ready_phase()
		return

	#judged? advance to next customer or next day.
	if phase == "judged":
		if pending_advance == "customer":
			_advance_customer()
		elif pending_advance == "newday":
			_start_next_day()

#intro finished: unlock ask + judging + plating.
func _enter_ready_phase() -> void:
	phase = "ready"
	next_button.visible = false
	var cust := Game.get_current_customer()
	if cust != null and cust.question_answer != "" and not has_asked:
		ask_button.text = cust.question_prompt
		ask_button.visible = true
	_set_judge_enabled(true)
	_set_plating_enabled(true)

func _advance_customer() -> void:
	if Game.next_customer():
		_show_current_customer()
	else:
		_end_day()

#----------------DAY TRANSITIONS------------------------
func _end_day() -> void:
	_finish_typing()
	_set_judge_enabled(false)
	_set_plating_enabled(false)
	ask_button.visible = false
	_clear_plate()
	name_label.text = "Day %d complete!" % Game.day
	dialogue_label.text = "Score: %d    Lives: %d\nClick Next for the next shift." % [Game.score, Game.lives]
	result_label.text = ""
	pending_advance = "newday"
	phase = "judged"
	next_button.visible = true
	next_button.text = "Next day"

func _start_next_day() -> void:
	if Game.next_day():                          # increments Game.day
		Game.start_day(day_rosters[Game.day - 1])
		_show_day_card()
	else:
		_win()

func _show_day_card() -> void:
	name_label.text = "Day %d" % Game.day
	dialogue_label.text = "A new shift begins. Stay sharp — the wolves are hungrier today."
	result_label.text = ""
	_set_portrait(null)
	ask_button.visible = false
	_set_judge_enabled(false)
	_set_plating_enabled(false)
	phase = "judged"
	pending_advance = "customer"
	next_button.visible = true
	next_button.text = "Start day"

#----------------END STATES------------------------
func _win() -> void:
	_finish_typing()
	_set_judge_enabled(false)
	_set_plating_enabled(false)
	ask_button.visible = false
	next_button.visible = false
	name_label.text = "YOU MADE IT!"
	dialogue_label.text = "You survived all %d days. The cafe is a hit and every leaf-lover is safe." % Game.TOTAL_DAYS
	result_label.text = "Final score: %d" % Game.score

func _game_over() -> void:
	_finish_typing()
	_set_judge_enabled(false)
	_set_plating_enabled(false)
	ask_button.visible = false
	next_button.visible = false
	pending_advance = ""
	name_label.text = "GAME OVER"
	dialogue_label.text = "The cafe closed for good."
	result_label.text = "Final score: %d" % Game.score

#----------------PLATING (green placeholder)------------------------
func _on_ingredient_pressed() -> void:
	if phase != "ready":
		return
	_add_to_plate()

#drops a small green square onto the plate. stand-in for real food art +
#drag-and-drop, which comes later.
func _add_to_plate() -> void:
	plate_count += 1
	var chip := ColorRect.new()
	chip.color = Color(0.654, 0.741, 0.251)      # android green from the palette
	chip.custom_minimum_size = Vector2(28, 28)
	chip.size = Vector2(28, 28)
	#scatter it a little inside the plate so it looks piled on.
	var px := 30 + (plate_count * 23) % 140
	var py := 30 + ((plate_count * 37) % 60)
	chip.position = Vector2(px, py)
	plate.add_child(chip)

func _clear_plate() -> void:
	plate_count = 0
	for child in plate.get_children():
		child.queue_free()

#----------------TYPEWRITER------------------------
func _start_typing(text: String) -> void:
	full_line = text
	shown_chars = 0
	dialogue_label.text = ""
	is_typing = true
	_type_timer.start()

func _on_type_tick() -> void:
	shown_chars += 1
	dialogue_label.text = full_line.substr(0, shown_chars)
	if shown_chars >= full_line.length():
		_finish_typing()

func _finish_typing() -> void:
	_type_timer.stop()
	dialogue_label.text = full_line
	shown_chars = full_line.length()
	is_typing = false

#----------------HELPERS------------------------
func _set_portrait(tex: Texture2D) -> void:
	if tex != null:
		portrait.texture = tex

func _set_judge_enabled(on: bool) -> void:
	serve_button.disabled = not on
	shoo_button.disabled = not on

func _set_plating_enabled(on: bool) -> void:
	for btn in ingredient_row.get_children():
		if btn is Button:
			btn.disabled = not on

func _update_hud() -> void:
	hud_label.text = "Day %d    Score: %d    Lives: %d" % [Game.day, Game.score, Game.lives]
