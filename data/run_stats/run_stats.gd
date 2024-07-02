class_name RunStats
extends Resource

signal hands_changed
signal discards_changed

@export var hands_per_round := 3
@export var discards_per_round := 3
@export var hand_size := 6
@export var card_selection_limit := 5

var current_hands: int : set = set_current_hands
var current_discards: int : set = set_current_discards
var current_card_selection_limit: int
var current_hand_size: int 


func copy_from_default(other: RunStats) -> void:
	hands_per_round = other.hands_per_round
	discards_per_round = other.discards_per_round
	hand_size = other.hand_size
	card_selection_limit = other.card_selection_limit
	setup()


func setup() -> void:
	current_hands = hands_per_round
	current_discards = discards_per_round
	current_hand_size = hand_size
	current_card_selection_limit = card_selection_limit


func set_current_hands(value: int) -> void:
	current_hands = value
	hands_changed.emit()
	

func set_current_discards(value: int) -> void:
	current_discards = value
	discards_changed.emit()
