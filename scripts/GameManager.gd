extends Node

var score := 0
var lives := 3
var day := 1

var _customers: Array[Customer] = []
var _current_index := -1

## Call this once when a day starts (Main.gd does this in _ready()).
func start_day(customers: Array[Customer]) -> void:
	_customers = customers
	_current_index = 0

## Returns the customer currently being served, or null if the day
## hasn't started / is over.
func get_current_customer() -> Customer:
	if _current_index < 0 or _current_index >= _customers.size():
		return null
	return _customers[_current_index]

## Advances to the next customer. Returns true if there is one,
## false if the day is over (Main.gd uses this to decide whether
## to call _show_current_customer() or _end_day()).
func next_customer() -> bool:
	_current_index += 1
	return _current_index < _customers.size()

func is_game_over() -> bool:
	return lives <= 0

## judge() takes what's on the plate too (defaults to [] so it still
## works fine for customers with no specific order, or if you haven't
## wired up plating yet).
## - Shoo is correct only if the customer IS a carnivore.
## - Serve is correct only if the customer is NOT a carnivore AND
##   (they had no specific order, or the plate exactly matches it).
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
	return correct

## Impatience penalty — call this from Main.gd when the patience
## Timer times out before the player acts.
func penalize_impatience() -> void:
	lives -= 1

func _ingredients_match(plate: Array, wanted: Array) -> bool:
	var p: Array = plate.duplicate()
	var w: Array = wanted.duplicate()
	p.sort()
	w.sort()
	return p == w
