class_name Hand
extends Control

const CARD_PLACEHOLDER = preload("res://game/hand/card_placeholder.tscn")
const CARD = preload("res://game/card/card.tscn")

@export_category("Data")
@export var deck: CardStack

@export_category("Visuals")
@export var deck_control_node: Control
@export var discard_position: Vector2
@export var y_separation := 20
@export var draw_anim_length := 0.25
@export var discard_anim_length := 0.25

var dragging_card: Card = null
var dragging_card_current_index := 0
var card_released := false

var all_cards_size: float
var final_y_separation: float
var x_offset: float
var y_offset: float


func _ready() -> void:
	x_offset = (size.x - Card.SIZE_X) / 2


func _process(_delta: float) -> void:
	if not dragging_card or card_released:
		return
	
	var new_index := _get_dragging_card_new_index()
	if dragging_card_current_index != new_index:
		_update_cards_dragging(new_index, dragging_card_current_index)
		dragging_card_current_index = new_index


func calculate_y_positions(cards: int = get_child_count()) -> void:
	all_cards_size = Card.SIZE_Y * cards + (y_separation * (cards - 1))
	final_y_separation = y_separation
	
	if all_cards_size > size.y:
		final_y_separation = (size.y - Card.SIZE_Y * cards) / (cards - 1)
		all_cards_size = Card.SIZE_Y * cards + (final_y_separation * (cards - 1))
	
	y_offset = (size.y - all_cards_size) / 2


func draw(at: int) -> void:
	var new_card := CARD.instantiate() as Card
	add_child(new_card)
	move_child(new_card, at)
	new_card.instruction = deck.draw()
	new_card.dragging_started.connect(_on_card_dragging_started)
	new_card.released.connect(_on_card_released)
	
	var target_pos := Vector2(x_offset, _get_nth_card_y_position(at))
	new_card.global_position = deck_control_node.global_position
	new_card.tween_to_position(target_pos, draw_anim_length)


func discard(at: int) -> void:
	if get_child_count() < 1 or get_child_count() < at:
		return
		
	var card := get_child(at) as Card
	card.tween_to_position(discard_position, discard_anim_length)


func _update_cards() -> void:
	var cards := get_child_count()
	calculate_y_positions()
	
	for i in cards:
		var card := get_child(i)
		var y_pos: float = _get_nth_card_y_position(i)
		card.position = Vector2(x_offset, y_pos)
		
		if card is Card and card.selected:
			card.position.x += card.selection_x_offset


func _update_cards_dragging(card_index: int, shadow_index: int) -> void:
	var card := get_child(card_index) as Card
	var shadow := get_child(shadow_index) 
	
	move_child(shadow, card_index)
	shadow.position.y = _get_nth_card_y_position(card_index)
	card.tween_to_position(Vector2(card.position.x, _get_nth_card_y_position(shadow_index)), 0.3)


func _get_dragging_card_new_index() -> int:
	@warning_ignore("integer_division")
	var card_y_pos := int(dragging_card.position.y - y_offset - position.y) + Card.SIZE_Y / 2
	var dist := all_cards_size / get_child_count()
	return clampi(int(card_y_pos / dist), 0, get_child_count()-1)


func _get_nth_card_y_position(n: int) -> float:
	return y_offset + Card.SIZE_Y * n + final_y_separation * n


func _on_card_dragging_started(card: Card) -> void:
	dragging_card = card
	dragging_card_current_index = card.get_index()
	card.reparent(get_tree().root)
	var card_placeholder := CARD_PLACEHOLDER.instantiate()
	card_placeholder.tree_exited.connect(_on_card_placeholder_deleted)
	add_child(card_placeholder)
	move_child(card_placeholder, dragging_card_current_index)
	_update_cards()


func _on_card_released(_card: Card) -> void:
	get_tree().get_first_node_in_group("card_placeholders").queue_free()
	card_released = true


func _on_card_placeholder_deleted() -> void:
	dragging_card.reparent(self)
	move_child(dragging_card, dragging_card_current_index)
	
	var target_pos := Vector2(x_offset, _get_nth_card_y_position(dragging_card_current_index))
	dragging_card.tween_to_position(target_pos, draw_anim_length)
	
	card_released = false
	dragging_card = null
