class_name ExecutionWindow
extends Control

signal execution_finished

const EXPRESSION_BUILDER = preload("res://game/expression_builder/expression_builder.tscn")

var _instructions: Array[Instruction]

@onready var instructions_container: VBoxContainer = %Instructions
@onready var variable_container: VariableContainer = $VariableContainer
@onready var step_button: Button = %StepButton
@onready var arrow: TextureRect = %Arrow
@onready var arrow_tween: TweenComponent = %ArrowTween


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
	step_button.disabled = true
	var instruction: Instruction = _instructions.pop_front()
	variable_container.animate_instruction(instruction)
	variable_container.animation_finished.connect(_on_step_animation_finished.bind(instruction), CONNECT_ONE_SHOT)
	

func _animate_arrow(instruction: int) -> void:
	var target: Vector2 = instructions_container.get_child(instruction).global_position
	target.x -= 80
	arrow_tween.start_tween(target)


func _end_execution() -> void:
	arrow.hide()
	step_button.disabled = true
	# TODO this is a pretty ugly way to do it
	await get_tree().create_timer(1, false).timeout
	execution_finished.emit()
	queue_free()


func _on_step_animation_finished(instruction: Instruction) -> void:
	step_button.disabled = false
	instruction.execute()
	
	var current_instruction := instructions_container.get_child_count() - _instructions.size()
	
	if current_instruction < instructions_container.get_child_count():
		_animate_arrow(current_instruction)
	else:
		_end_execution()
