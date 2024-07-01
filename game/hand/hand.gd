class_name Hand
extends Control

const CARD_PLACEHOLDER = preload("res://game/hand/card_placeholder.tscn")
const CARD = preload("res://game/card/card.tscn")
const X_SIZE := 250
const Y_SIZE := 80

@export var y_separation := 20

var dragging_card: Card = null
var temporary_index := 0
var final_new_index := 0
var all_cards_size: float
var y_offset: float


func _process(_delta: float) -> void:
	if not dragging_card:
		return
	
	var new_index := _get_dragging_card_new_index()
	if temporary_index != new_index:
		_update_cards_dragging(new_index, temporary_index)
		temporary_index = new_index


func draw() -> void:
	var new_card := CARD.instantiate() as Card
	add_child(new_card)
	new_card.name_label.text = "Card %s" % get_child_count()
	new_card.dragging_started.connect(_on_card_dragging_started)
	new_card.released.connect(_on_card_released)
	_update_cards()


func discard() -> void:
	if get_child_count() < 1:
		return
		
	var child := get_child(-1)
	child.reparent(get_tree().root)
	child.queue_free()
	_update_cards()


func _update_cards() -> void:
	var cards := get_child_count()
	all_cards_size = Y_SIZE * cards + (y_separation * (cards - 1))
	var final_y_separation: float = y_separation
	
	if all_cards_size > size.y:
		final_y_separation = (size.y - Y_SIZE * cards) / (cards - 1)
		all_cards_size = Y_SIZE * cards + (final_y_separation * (cards - 1))
	
	y_offset = (size.y - all_cards_size) / 2
	var x_offset := (size.x - X_SIZE) / 2
	
	for i in cards:
		var card := get_child(i)
		var y_pos: float = y_offset + Y_SIZE * i + final_y_separation * i
		card.position = Vector2(x_offset, y_pos)


func _update_cards_dragging(card_index: int, shadow_index: int) -> void:
	var shadow := get_child(shadow_index)
	move_child(shadow, card_index)
	_update_cards()


func _get_dragging_card_new_index(debug: bool = false) -> int:
	var card_y_pos := int(dragging_card.position.y - y_offset - position.y)
	var dist := all_cards_size / get_child_count()
	if debug:
		printt(card_y_pos, dist, clampi(int(card_y_pos / dist), 0, get_child_count()-1))
	
	return clampi(int(card_y_pos / dist), 0, get_child_count()-1)


func _on_card_dragging_started(card: Card) -> void:
	dragging_card = card
	temporary_index = card.get_index()
	card.reparent(get_tree().root)
	var card_placeholder := CARD_PLACEHOLDER.instantiate()
	card_placeholder.tree_exited.connect(_on_card_placeholder_deleted)
	add_child(card_placeholder)
	move_child(card_placeholder, temporary_index)
	_update_cards()


func _on_card_released(_card: Card) -> void:
	get_tree().get_first_node_in_group("card_placeholders").queue_free()
	_get_dragging_card_new_index(true)
	final_new_index = temporary_index


func _on_card_placeholder_deleted() -> void:
	dragging_card.reparent(self)
	move_child(dragging_card, final_new_index)
	dragging_card = null
	_update_cards()
