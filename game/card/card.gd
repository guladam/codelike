class_name Card
extends Control

signal dragging_started(card: Card)
signal released(card: Card)

const LERP_HOVER_ANGLE_MIN := -0.05
const LERP_HOVER_ANGLE_MAX := 0.05

static var cards_selected := 0

@export var instruction: Instruction : set = set_instruction

var tween_rotation: Tween
var tween_hover: Tween
var tween_position: Tween

@onready var selected := false
@onready var visuals: TextureRect = $Visuals
@onready var shadow: TextureRect = $Visuals/Shadow
@onready var expression_builder: ExpressionBuilder = $ExpressionBuilder
@onready var state_machine: CardStateMachine = $StateMachine


func _ready() -> void:
	state_machine.init(self)


func _input(event: InputEvent) -> void:
	state_machine.on_input(event)


func set_instruction(value: Instruction) -> void:
	instruction = value
	
	if not is_node_ready() or not value:
		return
	
	expression_builder.build_expression(CustomExpression.str_to_expr_array(instruction.name))


func toggle_selected() -> void:
	if not selected and cards_selected >= 5:
		return

	selected = not selected
	
	if selected:
		position.x += 50
		cards_selected += 1
	else:
		position.x -= 50
		cards_selected -= 1


func tween_to_position(new_position: Vector2) -> void:
	if tween_position:
		tween_position.kill()
		
	tween_position = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_position.tween_property(self, "position", new_position, 0.3)


func _on_gui_input(event: InputEvent) -> void:
	state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	state_machine.on_mouse_exited()
