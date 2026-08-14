extends Node

var score := 0
var lives := 3
var day := 1

const TOTAL_DAYS := 2            # survive this many days to win

#customers for the current day
var day_customers: Array[Customer] = []
var current_index := 0

#for the hud to refresh
signal stats_changed

func start_day(customers: Array[Customer]) -> void:
	day_customers = customers
	current_index = 0
	stats_changed.emit()

func get_current_customer() -> Customer:
	if current_index < 0 or current_index >= day_customers.size():
		return null
	return day_customers[current_index]

#advance to the next customer, returns true if one exists
func next_customer() -> bool:
	current_index += 1
	return current_index < day_customers.size()

func is_day_over() -> bool:
	return current_index >= day_customers.size()

#move to the next day, returns true if there is another day to play
func next_day() -> bool:
	day += 1
	current_index = 0
	stats_changed.emit()
	return day <= TOTAL_DAYS

#true once the player has cleared the final day
func has_won() -> bool:
	return day > TOTAL_DAYS

func judge(customer: Customer, player_chose_shoo: bool) -> bool:
	var correct := (player_chose_shoo == customer.is_carnivore)
	if correct:
		score += 10
	else:
		lives -= 1

	stats_changed.emit()
	return correct

func is_game_over() -> bool:
	return lives <= 0

func reset() -> void:
	score = 0
	lives = 3
	day = 1
	day_customers = []
	current_index = 0
	stats_changed.emit()
