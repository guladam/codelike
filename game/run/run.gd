extends Control

const GAME = preload("res://game/game.tscn")
const SHOP = preload("res://game/shop/shop.tscn")

@export var level_goals: Array[Goal]

@onready var win_screen: ColorRect = $WinScreen
@onready var levels_won := 0


func _ready() -> void:
	_create_level()


func _create_level() -> void:
	var new_game := GAME.instantiate() as Game
	new_game.level_won.connect(_on_level_won)
	new_game.level_lost.connect(_on_level_lost)
	
	if levels_won <= level_goals.size()-1:
		new_game.goal = level_goals[levels_won]
		add_child(new_game)


func _create_shop() -> void:
	var new_shop := SHOP.instantiate() as Shop
	new_shop.shop_exited.connect(_on_shop_exited)
	add_child(new_shop)


func _on_level_won() -> void:
	get_child(-1).queue_free()
	levels_won += 1
	
	if levels_won == level_goals.size():
		win_screen.show()
	else:
		_create_shop()


func _on_level_lost() -> void:
	get_child(-1).queue_free()
	get_tree().reload_current_scene()


func _on_shop_exited() -> void:
	get_child(-1).queue_free()
	_create_level()
