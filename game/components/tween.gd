class_name TweenComponent
extends Node

@export var target: Control
@export var property: String
@export var tween_type: Tween.TransitionType
@export var tween_ease: Tween.EaseType
@export var length: float = 0.5

var tween: Tween


func start_tween(value: Variant) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween().set_ease(tween_ease).set_trans(tween_type)
	tween.tween_property(target, property, value, length)
