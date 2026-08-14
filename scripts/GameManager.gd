extends Node

var score:= 0
var lives:= 3
var day:= 1

#customers for current day
var day_customers: Array[Customer] = []
var current_index:= 0

#For UI to refresh HUD
signal stats_changed

func start_day(customers: Array[Customer]) -> void:
	day_customers = customers
	current_index = 0

func get_current_customer() -> Customer:
	if current_index < 0 or current_index >= day_customers.size():
		return null
	return day_customers[current_index]

#advance to next customer if it exists
func next_customer() -> bool:
	current_index += 1
	return current_index < day_customers.size()

func is_day_over() -> bool:
	return current_index >= day_customers.size()

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
