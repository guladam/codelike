class_name Card
extends Control

signal dragging_started(card: Card)
signal released(card: Card)

const SIZE_X := 300
const SIZE_Y := 150

static var cards_selected := 0

@export_category("Data")
@export var run_stats: RunStats
@export var instruction: Instruction : set = set_instruction

@export_category("Visuals")
@export var selection_x_offset := 50
@export var selection_tween_length := 0.2
@export var hover_scale_vector := Vector2(1.05, 1.05)
@export var hover_scale_length := 0.5
@export var hover_angle_reset_length := 0.3
@export var lerp_hover_angle_min := -0.05
@export var lerp_hover_angle_max := 0.05

var mouse_over_card := false
var interactable := false
var tween_rotation: Tween
var tween_hover: Tween
var tween_position: Tween
var tween_scale: Tween

@onready var selected := false
@onready var visuals: TextureRect = $Visuals
@onready var shadow: TextureRect = $Visuals/Shadow
@onready var expression_builder: ExpressionBuilder = $ExpressionBuilder
@onready var state_machine: CardStateMachine = $StateMachine


func _ready() -> void:
	state_machine.init(self)


func _input(event: InputEvent) -> void:
	if not interactable:
		return
	
	state_machine.on_input(event)


func set_instruction(value: Instruction) -> void:
	instruction = value
	
	if not is_node_ready() or not value:
		return
	
	expression_builder.build_expression(CustomExpression.str_to_expr_array(instruction.name))


func enable() -> void:
	interactable = true
	
	if mouse_over_card:
		_on_mouse_entered()


func disable() -> void:
	interactable = false


func toggle_selected() -> void:
	if not interactable:
		return
		
	if not selected and cards_selected >= run_stats.current_card_selection_limit:
		return

	selected = not selected
	var final_pos: Vector2
	
	if selected:
		final_pos = position + Vector2(selection_x_offset, 0)
		cards_selected += 1
	else:
		final_pos = position - Vector2(selection_x_offset, 0)
		cards_selected -= 1
	
	tween_to_position(final_pos, selection_tween_length)


func draw_tween(target_position: Vector2, length: float) -> void:
	if tween_rotation:
		tween_rotation.kill()
	if tween_scale:
		tween_scale.kill()
		
	tween_rotation = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_scale = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	rotation = (target_position - position).angle()
	scale = Vector2.ZERO
	tween_rotation.tween_property(self, "rotation", 0.0, length)
	tween_scale.tween_property(self, "scale", Vector2.ONE, length)
	tween_to_position(target_position, length)


func discard_tween(target_position: Vector2, length: float) -> void:
	if tween_rotation:
		tween_rotation.kill()
	if tween_scale:
		tween_scale.kill()
	
	var angle := Vector2.LEFT.angle_to(target_position - global_position)
	tween_rotation = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_scale = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_rotation.tween_property(self, "rotation", angle, length)
	tween_scale.tween_property(self, "scale", Vector2.ZERO, length)
	tween_to_position(target_position, length, "global_position")


func tween_to_position(new_position: Vector2, length: float, property: String = "position") -> void:
	if tween_position:
		tween_position.kill()
	
	tween_position = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_position.tween_property(self, property, new_position, length)


func _on_gui_input(event: InputEvent) -> void:
	if not interactable:
		return
	
	state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	mouse_over_card = true
	
	if not interactable:
		return
	
	state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	mouse_over_card = false
	
	if not interactable:
		return
	
	state_machine.on_mouse_exited()
