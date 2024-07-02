class_name Variable
extends Resource

signal value_changed

@export var name: String
@export var icon: Texture
@export var value: int :
	set(new_value):
		value = new_value
		value_changed.emit()


func reset() -> void:
	value = 0
