class_name Shop
extends Control

signal shop_exited

@onready var close_shop_button: Button = %CloseShopButton


func _ready() -> void:
	close_shop_button.pressed.connect(func(): shop_exited.emit())
