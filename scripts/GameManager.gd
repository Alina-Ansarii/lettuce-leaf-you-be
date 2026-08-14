extends Node

var score := 0
var lives := 3
var day := 1

const TOTAL_DAYS := 2            # survive this many days to win

var _customers: Array[Customer] = []
var _current_index := -1

#for the hud to refresh
signal stats_changed

func start_day(customers: Array[Customer]) -> void:
	_customers = customers
	_current_index = 0
	stats_changed.emit()

func get_current_customer() -> Customer:
	if _current_index < 0 or _current_index >= _customers.size():
		return null
	return _customers[_current_index]

#advance to the next customer, returns true if one exists
func next_customer() -> bool:
	_current_index += 1
	return _current_index < _customers.size()

func is_day_over() -> bool:
	return _current_index >= _customers.size()

#move to the next day, returns true if there is another day to play
func next_day() -> bool:
	day += 1
	_current_index = 0
	stats_changed.emit()
	return day <= TOTAL_DAYS

func has_won() -> bool:
	return day > TOTAL_DAYS

func is_game_over() -> bool:
	return lives <= 0

#judge takes the plate contents too.
# - shoo is correct only if the customer IS a carnivore.
# - serve is correct only if the customer is NOT a carnivore AND
#   (they had no specific order, or the plate exactly matches it).
func judge(customer: Customer, player_chose_shoo: bool, plate_ingredients: Array = []) -> bool:
	var correct: bool
	if player_chose_shoo:
		correct = customer.is_carnivore
	else:
		var order_ok := customer.wanted_ingredients.is_empty() \
			or _ingredients_match(plate_ingredients, customer.wanted_ingredients)
		correct = (not customer.is_carnivore) and order_ok

	if correct:
		score += 10
	else:
		lives -= 1
	stats_changed.emit()
	return correct

#impatience penalty - called when the patience timer runs out.
func penalize_impatience() -> void:
	lives -= 1
	stats_changed.emit()

func _ingredients_match(plate: Array, wanted: Array) -> bool:
	var p: Array = plate.duplicate()
	var w: Array = wanted.duplicate()
	p.sort()
	w.sort()
	return p == w

func reset() -> void:
	score = 0
	lives = 3
	day = 1
	_customers = []
	_current_index = -1
	stats_changed.emit()
