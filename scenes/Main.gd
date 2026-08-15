extends Control

#----------------NODE REFERENCES------------------
@onready var name_label: Label = $NameLabel
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel
@onready var result_label: Label = $ResultLabel
@onready var hud_label: Label = $HudLabel
@onready var portrait: TextureRect = $Portrait

@onready var serve_button: Button = $ServeButton
@onready var shoo_button: Button = $ShooButton
@onready var next_button: Button = $NextButton
@onready var ask_button: Button = $AskButton

@onready var plate: Plate = $Plate
@onready var patience_bar: ProgressBar = $PatienceBar
@onready var patience_timer: Timer = $PatienceTimer
@onready var order_text: Label = $OrderTicket/OrderText

@onready var click_player: AudioStreamPlayer = $ClickPlayer
@onready var question_player: AudioStreamPlayer = $QuestionPlayer
@onready var confirmation_player: AudioStreamPlayer = $ConfirmationPlayer
@onready var wrong_player: AudioStreamPlayer = $WrongPlayer
@onready var ticking_player: AudioStreamPlayer = $TickingPlayer

#----------------DAY ROSTERS------------------
#customers split across two days. day 2 is the harder shift.
var _day1: Array[Customer] = [
	preload("res://data/customers/Trisha.tres"),
	preload("res://data/customers/Steg.tres"),
	preload("res://data/customers/Ray.tres"),
]
var _day2: Array[Customer] = [
	preload("res://data/customers/Bronte.tres"),
	preload("res://data/customers/Dilo.tres"),
	preload("res://data/customers/Trisha.tres"),
]
var day_rosters := [_day1, _day2]

#----------------CONVERSATION STATE------------------
# phase: "intro" = reading arrival lines, "ready" = can ask/plate/judge,
#        "judged" = already resolved; only Next works
var phase := "intro"
var intro_index := 0
var intro_lines: Array = []
var has_asked := false

# what Next does: "customer" -> next dino, "newday" -> next day
var pending_advance := ""

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
	patience_timer.timeout.connect(_on_patience_timeout)

	_type_timer = Timer.new()
	_type_timer.wait_time = TYPE_SPEED
	_type_timer.timeout.connect(_on_type_tick)
	add_child(_type_timer)

	if ticking_player.stream != null:
		ticking_player.stream.loop = true

	Game.stats_changed.connect(_update_hud)

	Game.start_day(day_rosters[0])
	_update_hud()
	_show_current_customer()

#----------------SHOWING A CUSTOMER------------------
func _show_current_customer() -> void:
	var cust: Customer = Game.get_current_customer()
	if cust == null:
		_end_day()
		return

	#reset per-customer state.
	phase = "intro"
	intro_index = 0
	intro_lines = cust.intro_lines
	has_asked = false
	pending_advance = ""
	plate.clear_plate()

	#patience timer only starts once they're done talking (in _enter_ready_phase).
	patience_timer.stop()
	_stop_ticking()
	patience_bar.max_value = cust.patience_seconds
	patience_bar.value = cust.patience_seconds

	result_label.text = ""
	name_label.text = cust.display_name
	order_text.text = _order_ticket_text(cust)
	_set_portrait(cust.portrait_neutral)

	#during intro only Next is usable.
	next_button.visible = true
	next_button.text = "Next"
	ask_button.visible = false
	_set_judge_enabled(false)
	_set_tray_enabled(false)

	question_player.play()
	_start_typing(_current_intro_line())

func _current_intro_line() -> String:
	if intro_index < intro_lines.size():
		return str(intro_lines[intro_index])
	return ""

#a carnivore looks a little too pleased on its final intro line - a subtle
#'i'm fooling you' tell. herbivores stay neutral throughout.
func _update_intro_portrait() -> void:
	if _showing_disgust:
		return
	var cust: Customer = Game.get_current_customer()
	if cust == null:
		return
	var is_last_line := intro_index == intro_lines.size() - 1
	if cust.is_carnivore and is_last_line and cust.portrait_happy != null:
		portrait.texture = cust.portrait_happy
	else:
		portrait.texture = cust.portrait_neutral

func _order_ticket_text(cust: Customer) -> String:
	if cust.wanted_ingredients.is_empty():
		return "No specific order"
	var capitalized: Array[String] = []
	for ingredient_id in cust.wanted_ingredients:
		capitalized.append(str(ingredient_id).capitalize())
	return "Order:\n%s" % ", ".join(capitalized)

#----------------THE ASK BUTTON------------------
func _on_ask() -> void:
	if phase != "ready" or has_asked:
		return
	var cust: Customer = Game.get_current_customer()
	if cust == null:
		return
	has_asked = true
	ask_button.visible = false
	if cust.question_answer != "":
		_start_typing(cust.question_answer)

#----------------JUDGING------------------------
func _on_serve() -> void:
	click_player.play()
	if is_typing:
		_finish_typing()
		return
	if phase != "ready":
		return
	_judge(false)

func _on_shoo() -> void:
	click_player.play()
	if is_typing:
		_finish_typing()
		return
	if phase != "ready":
		return
	_judge(true)

func _judge(chose_shoo: bool) -> void:
	var cust: Customer = Game.get_current_customer()
	if cust == null:
		return

	patience_timer.stop()
	_stop_ticking()

	var correct: bool = Game.judge(cust, chose_shoo, plate.ingredients)

	var reaction := ""
	if correct:
		confirmation_player.play()
		if chose_shoo:
			_set_portrait(cust.portrait_caught)   # carnivore caught -> fuss
			reaction = cust.shooed_right
		else:
			_set_portrait(cust.portrait_happy)    # herbivore served -> happy
			reaction = cust.served_right
		result_label.text = "CORRECT!"
	else:
		wrong_player.play()
		if chose_shoo:
			_set_portrait(cust.portrait_angry)    # herbivore wrongly shooed -> upset
			reaction = cust.shooed_wrong
		else:
			_set_portrait(cust.portrait_happy)    # carnivore fooled you -> pleased
			reaction = cust.served_wrong
		result_label.text = "WRONG (lives: %d)" % Game.lives

	plate.clear_plate()
	phase = "judged"
	_set_judge_enabled(false)
	_set_tray_enabled(false)
	ask_button.visible = false

	if reaction != "":
		_start_typing(reaction)

	if Game.is_game_over():
		_game_over()
	else:
		pending_advance = "customer"
		next_button.visible = true
		next_button.text = "Next"

#----------------PATIENCE------------------------
func _process(_delta: float) -> void:
	if not patience_timer.is_stopped():
		patience_bar.value = patience_timer.time_left

func _on_patience_timeout() -> void:
	var cust: Customer = Game.get_current_customer()
	if cust == null:
		return

	_stop_ticking()
	wrong_player.play()
	Game.penalize_impatience()
	_set_portrait(cust.portrait_angry)
	result_label.text = "%s got impatient and left! (lives: %d)" % [cust.display_name, Game.lives]

	plate.clear_plate()
	phase = "judged"
	_set_judge_enabled(false)
	_set_tray_enabled(false)
	ask_button.visible = false

	if Game.is_game_over():
		_game_over()
	else:
		pending_advance = "customer"
		next_button.visible = true
		next_button.text = "Next"

#----------------ADVANCING------------------------
func _on_next() -> void:
	click_player.play()
	if is_typing:
		_finish_typing()
		return

	if phase == "intro":
		intro_index += 1
		if intro_index < intro_lines.size():
			_start_typing(_current_intro_line())
			_update_intro_portrait()
		else:
			_enter_ready_phase()
		return

	if phase == "judged":
		if pending_advance == "customer":
			_advance_customer()
		elif pending_advance == "newday":
			_start_next_day()

#intro finished: unlock ask + judging + plating, and start the patience clock.
func _enter_ready_phase() -> void:
	phase = "ready"
	next_button.visible = false

	var cust: Customer = Game.get_current_customer()
	if cust != null and cust.question_answer != "" and not has_asked:
		ask_button.text = cust.question_prompt
		ask_button.visible = true

	_set_judge_enabled(true)
	_set_tray_enabled(true)

	if cust != null:
		patience_timer.wait_time = cust.patience_seconds
		patience_timer.start()
		_start_ticking()

func _advance_customer() -> void:
	if Game.next_customer():
		_show_current_customer()
	else:
		_end_day()

#----------------DAY TRANSITIONS------------------------
func _end_day() -> void:
	_finish_typing()
	patience_timer.stop()
	_stop_ticking()
	_set_judge_enabled(false)
	_set_tray_enabled(false)
	ask_button.visible = false
	plate.clear_plate()
	name_label.text = "Day %d complete!" % Game.day
	dialogue_label.text = "Score: %d    Lives: %d\nClick Next for the next shift." % [Game.score, Game.lives]
	result_label.text = ""
	order_text.text = ""
	pending_advance = "newday"
	phase = "judged"
	next_button.visible = true
	next_button.text = "Next day"

func _start_next_day() -> void:
	if Game.next_day():
		Game.start_day(day_rosters[Game.day - 1])
		_show_day_card()
	else:
		_win()

func _show_day_card() -> void:
	name_label.text = "Day %d" % Game.day
	dialogue_label.text = "A new shift begins. Stay sharp - the wolves are hungrier today."
	result_label.text = ""
	order_text.text = ""
	_set_portrait(null)
	ask_button.visible = false
	_set_judge_enabled(false)
	_set_tray_enabled(false)
	phase = "judged"
	pending_advance = "customer"
	next_button.visible = true
	next_button.text = "Start day"

#----------------END STATES------------------------
func _win() -> void:
	_finish_typing()
	patience_timer.stop()
	_stop_ticking()
	_set_judge_enabled(false)
	_set_tray_enabled(false)
	ask_button.visible = false
	next_button.visible = false
	name_label.text = "YOU MADE IT!"
	dialogue_label.text = "You survived all %d days. The cafe is a hit and every leaf-lover is safe." % Game.TOTAL_DAYS
	result_label.text = "Final score: %d" % Game.score

func _game_over() -> void:
	_finish_typing()
	patience_timer.stop()
	_stop_ticking()
	_set_judge_enabled(false)
	_set_tray_enabled(false)
	ask_button.visible = false
	next_button.visible = false
	pending_advance = ""
	name_label.text = "GAME OVER"
	dialogue_label.text = "The cafe closed for good."
	result_label.text = "Final score: %d" % Game.score

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

#----------------DISGUST REACTION------------------------
# called by a DraggableIngredient while it is being dragged over the portrait.
# a disguised carnivore recoils from veggies with a disgusted face; the moment
# the food moves away (or is dropped) the neutral face returns.
var _showing_disgust := false

func notify_food_near_portrait(is_near: bool) -> void:
	if phase != "ready":
		return
	var cust: Customer = Game.get_current_customer()
	if cust == null or not cust.is_carnivore or cust.portrait_disgusted == null:
		return
	if is_near and not _showing_disgust:
		_showing_disgust = true
		portrait.texture = cust.portrait_disgusted
	elif not is_near and _showing_disgust:
		_showing_disgust = false
		portrait.texture = cust.portrait_neutral

#----------------HELPERS------------------------
func _start_ticking() -> void:
	ticking_player.play()

func _stop_ticking() -> void:
	ticking_player.stop()

func _set_portrait(tex: Texture2D) -> void:
	_showing_disgust = false
	if tex != null:
		portrait.texture = tex

func _set_judge_enabled(on: bool) -> void:
	serve_button.disabled = not on
	shoo_button.disabled = not on

#enables/disables dragging by toggling mouse input on each tray item.
func _set_tray_enabled(on: bool) -> void:
	var tray := get_node_or_null("IngredientTray")
	if tray == null:
		return
	for item in tray.get_children():
		if item is Control:
			item.mouse_filter = Control.MOUSE_FILTER_STOP if on else Control.MOUSE_FILTER_IGNORE

func _update_hud() -> void:
	if hud_label != null:
		hud_label.text = "Day %d    Score: %d    Lives: %d" % [Game.day, Game.score, Game.lives]
