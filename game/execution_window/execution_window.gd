class_name ExecutionWindow
extends Control

signal execution_finished

const EXPRESSION_BUILDER = preload("res://game/expression_builder/expression_builder.tscn")

var _instructions: Array[Instruction]

@onready var instructions_container: VBoxContainer = %Instructions
@onready var step_button: Button = %StepButton
@onready var arrow: TextureRect = %Arrow


func _ready() -> void:
	step_button.pressed.connect(_step)


func init_window(instructions: Array[Instruction]) -> void:
	_instructions = instructions
	for instruction: Instruction in instructions:
		var expr := EXPRESSION_BUILDER.instantiate() as ExpressionBuilder
		instructions_container.add_child(expr)
		expr.build_expression(CustomExpression.str_to_expr_array(instruction.name))

	arrow.position = instructions_container.get_child(0).global_position
	arrow.position.x -= 80


func _step() -> void:
	var instruction: Instruction = _instructions.pop_front()
	instruction.execute()
	
	var current_instruction := instructions_container.get_child_count() - _instructions.size()
	
	if current_instruction < instructions_container.get_child_count():
		arrow.position = instructions_container.get_child(current_instruction).global_position
		arrow.position.x -= 80
	else:
		arrow.hide()
		step_button.disabled = true
		execution_finished.emit()
		queue_free()
