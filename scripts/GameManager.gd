extends Node

var score:= 0
var lives:= 3

func judge(customer: Customer, player_chose_shoo: bool) -> bool:
	var correct := (player_chose_shoo == customer.is_carnivore)
	if correct: 
		score += 10
	else:
		lives -= 1
	return correct
