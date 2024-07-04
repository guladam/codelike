class_name GoalDisplay
extends Label

@export var goal: Goal : set = set_goal


func set_goal(value: Goal) -> void:
	goal = value
	text = tr("GOAL_DISPLAY") % value.text
