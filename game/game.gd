class_name Game
extends Control

signal level_won
signal level_lost

const CARD = preload("res://game/card/card.tscn")

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
	_draw_cards(run_stats.current_hand_size)


func _draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in amount:
		tween.tween_callback(hand.draw)
		tween.tween_interval(0.25)


func _get_selected_cards() -> Array[Node]:
	return hand.get_children().filter(
		func(card: Card):
			return card.selected
	)


func _on_play_button_pressed() -> void:
	var selected_cards := _get_selected_cards()
	
	if selected_cards.is_empty():
		return
	
	for card: Card in selected_cards:
		card.instruction.execute()
		card.queue_free()
	
	run_stats.current_hands -= 1
	Card.cards_selected = 0
	
	if goal.are_goals_met():
		level_won.emit()
		#game_end_panel.show_end_screen(true)
		return
		
	if run_stats.current_hands <= 0 and not goal.are_goals_met():
		level_lost.emit()
		#game_end_panel.show_end_screen(false)
		return
	
	_draw_cards(selected_cards.size())


func _on_discard_button_pressed() -> void:
	var selected_cards := _get_selected_cards()
	
	if selected_cards.is_empty() or run_stats.current_discards <= 0:
		return
	
	for card: Card in selected_cards:
		card.queue_free()
	
	_draw_cards(selected_cards.size())
	
	Card.cards_selected = 0
	run_stats.current_discards -= 1
