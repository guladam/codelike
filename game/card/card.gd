class_name Card
extends Panel

signal dragging_started(card: Card)
signal released(card: Card)

static var cards_selected := 0

@onready var selected := false
@onready var name_label: Label = $Label
@onready var state_machine: CardStateMachine = $StateMachine


func _ready() -> void:
	state_machine.init(self)


func _input(event: InputEvent) -> void:
	state_machine.on_input(event)


func toggle_selected() -> void:
	if not selected and cards_selected >= 5:
		return

	selected = not selected
	
	if selected:
		position.x += 20
		cards_selected += 1
	else:
		position.x -= 20
		cards_selected -= 1


func _on_gui_input(event: InputEvent) -> void:
	state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	state_machine.on_mouse_exited()
