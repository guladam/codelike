extends CardState

var mouse_over_card := false


func enter() -> void:
	if not card.is_node_ready():
		await card.ready
	
	card.pivot_offset = Vector2.ZERO


func on_gui_input(event: InputEvent) -> void:
	if mouse_over_card and event.is_action_pressed("select_card"):
		card.pivot_offset = card.get_global_mouse_position() - card.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	mouse_over_card = true
	card.z_index = 99


func on_mouse_exited() -> void:
	mouse_over_card = false
	card.z_index = 0
