class_name VariableContainer
extends VBoxContainer

signal animation_finished


func animate_instruction(instruction: Instruction) -> void:
	var var_display: VariableDisplay = _get_var_display(instruction.variable_to_set)
	var_display.highlight()
	var_display.highlight_finished.connect(func(): animation_finished.emit(), CONNECT_ONE_SHOT)


func _get_var_display(variable: Variable) -> VariableDisplay:
	for var_display: VariableDisplay in get_children():
		if var_display.variable == variable:
			return var_display
	
	return null
