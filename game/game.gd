class_name Game
extends Control

signal level_won
signal level_lost

const CARD = preload("res://game/card/card.tscn")
const EXECUTION_WINDOW = preload("res://game/execution_window/execution_window.tscn")

@export var run_stats: RunStats
@export var goal: Goal
@export var deck: CardStack

@onready var goal_display: GoalDisplay = %GoalDisplay
@onready var hand: Hand = %Hand
@onready var play_button: Button = %PlayButton
@onready var discard_button: Button = %DiscardButton


func _ready() -> void:
	deck.reset_to_default(preload("res://data/card_stacks/default_deck.tres")) # TODO temporary code

	run_stats.setup()
	goal_display.goal = goal
	play_button.pressed.connect(_on_play_button_pressed)
	discard_button.pressed.connect(_on_discard_button_pressed)
	_start_game()


func _start_game() -> void:
	deck.shuffle()
	_draw_cards(range(run_stats.current_hand_size))


func _draw_cards(indices: Array) -> void:
	var current_cards_in_hand := hand.get_child_count()
	
	if current_cards_in_hand == 0:
		current_cards_in_hand = indices.size()
	
	hand.disable_hand()
	hand.calculate_y_positions(current_cards_in_hand)
	
	var tween := create_tween()
	for i in indices:
		tween.tween_callback(hand.draw.bind(i))
		tween.tween_interval(0.15)
	
	tween.tween_interval(hand.draw_anim_length)
	tween.finished.connect(func(): hand.enable_hand())


func _discard_cards(indices: Array) -> Tween:
	var tween := create_tween()
	
	for i in indices:
		tween.tween_callback(hand.discard.bind(i))
		tween.tween_interval(0.15)
	
	tween.tween_interval(hand.discard_anim_length)
	
	return tween


func _get_selected_cards() -> Array[Node]:
	return hand.get_children().filter(
		func(card: Card):
			return card.selected
	)


func _play_cards(cards: Array[Node]) -> void:
	var instructions: Array[Instruction] = []
	for card: Card in cards:
		instructions.append(card.instruction)
	
	var new_window = EXECUTION_WINDOW.instantiate() as ExecutionWindow
	add_child(new_window)
	new_window.init_window(instructions)
	new_window.execution_finished.connect(_on_execution_window_closed.bind(cards))


func _on_play_button_pressed() -> void:
	var selected_cards := _get_selected_cards()
	
	if selected_cards.is_empty():
		return
	
	_play_cards(selected_cards)


func _on_discard_button_pressed() -> void:
	var selected_cards := _get_selected_cards()
	
	if selected_cards.is_empty() or run_stats.current_discards <= 0:
		return
	
	hand.disable_hand()
	var indices := selected_cards.map(func(card: Card): return card.get_index())
	var tween := _discard_cards(indices)
	
	tween.finished.connect(
		func():
			for card: Card in selected_cards:
				card.queue_free()
			_draw_cards(indices)
	)
	
	Card.cards_selected = 0
	run_stats.current_discards -= 1


func _on_execution_window_closed(cards_played: Array[Node]) -> void:
	run_stats.current_hands -= 1
	Card.cards_selected = 0
	
	if goal.are_goals_met():
		level_won.emit()
		return
		
	if run_stats.current_hands <= 0 and not goal.are_goals_met():
		level_lost.emit()
		return
	
	var indices := cards_played.map(func(card: Card): return card.get_index())
	for card: Card in cards_played:
		card.queue_free()
	
	_draw_cards(indices)
