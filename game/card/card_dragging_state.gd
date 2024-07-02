extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05

var minimum_drag_time_elapsed := false


func enter() -> void:
	card.z_index = 10
	card.shadow.show()
	minimum_drag_time_elapsed = false
	card.dragging_started.emit(card)
	
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimum_drag_time_elapsed = true)


func on_input(event: InputEvent) -> void:
	if not minimum_drag_time_elapsed:
		return
	
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("cancel")
	var confirm = event.is_action_released("select_card") or event.is_action_pressed("select_card")

	if mouse_motion:
		card.global_position = card.get_global_mouse_position() - card.pivot_offset

	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif minimum_drag_time_elapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
