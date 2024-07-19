class_name VariableDisplay
extends VBoxContainer

signal highlight_finished

@export var variable: Variable

@onready var name_label: Label = $Name
@onready var value: Label = $Value
@onready var tween: TweenComponent = $Tween


func _ready() -> void:
	if variable:
		name_label.text = variable.icon
		variable.value_changed.connect(
			func():
				value.text = str(variable.value)
		)
	highlight_finished.connect(func(): print("second highlight part"))


func highlight() -> void:
	tween.start_tween(Vector2(1.25, 1.25))
	tween.tween.finished.connect(
		func():
			print("first highlight part")
			tween.start_tween(Vector2.ONE)
			tween.tween.finished.connect(func(): highlight_finished.emit(), CONNECT_ONE_SHOT)
	, CONNECT_ONE_SHOT)
