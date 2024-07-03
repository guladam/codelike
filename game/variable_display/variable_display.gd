class_name VariableDisplay
extends VBoxContainer

@export var variable: Variable

@onready var name_label: Label = $Name
@onready var value: Label = $Value


func _ready() -> void:
	if variable:
		name_label.text = variable.icon
		variable.value_changed.connect(
			func():
				value.text = str(variable.value)
		)
