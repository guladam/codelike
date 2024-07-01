extends Control

@onready var button: Button = $Button
@onready var button_2: Button = $Button2
@onready var hand: Hand = $Hand


func _ready() -> void:
	button.pressed.connect(func(): hand.draw())
	button_2.pressed.connect(func(): hand.discard())
