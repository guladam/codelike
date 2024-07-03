class_name GoalDisplay
extends Label

@export var goal: Goal : set = set_goal


func set_goal(value: Goal) -> void:
	goal = value
	text = "Goal: %s" % value.text
