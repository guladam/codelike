extends Instruction

@export var second_variable: Variable


func execute() -> void:
	variable_to_set.value = second_variable.value
