class_name Hand
extends Control

const CARD = preload("res://game/card/card.tscn")
const X_SIZE := 250
const Y_SIZE := 80

@export var y_separation := 20


func draw() -> void:
	var new_card := CARD.instantiate() as Card
	add_child(new_card)
	new_card.name_label.text = "Card %s" % get_child_count()
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
	var all_cards_size: float = Y_SIZE * cards + (y_separation * (cards - 1))
	var final_y_separation: float = y_separation
	
	if all_cards_size > size.y:
		final_y_separation = (size.y - Y_SIZE * cards) / (cards - 1)
		all_cards_size = Y_SIZE * cards + (final_y_separation * (cards - 1))
	
	var y_offset := (size.y - all_cards_size) / 2
	var x_offset := (size.x - X_SIZE) / 2
	
	for i in cards:
		var card := get_child(i)
		var y_pos: float = y_offset + Y_SIZE * i + final_y_separation * i
		card.position = Vector2(x_offset, y_pos)
