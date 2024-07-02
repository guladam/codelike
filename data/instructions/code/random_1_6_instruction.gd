extends Instruction


func execute() -> void:
	variable_to_set.value = randi_range(1, 6)
