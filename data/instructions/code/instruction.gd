class_name Instruction
extends Resource

@export var name: String
@export var variable_to_set: Variable


func execute() -> void:
	print("default empty instruction")


func _to_string() -> String:
	return "%s = 0" % variable_to_set.name
