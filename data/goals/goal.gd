class_name Goal
extends Resource

const VAR_A = preload("res://data/variables/var_a.tres")
const VAR_B = preload("res://data/variables/var_b.tres")
const VAR_C = preload("res://data/variables/var_c.tres")
const VAR_D = preload("res://data/variables/var_d.tres")

@export_range(1, 3) var level: int
@export var text: String


func are_goals_met() -> bool:
	return false
