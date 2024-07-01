extends CardState

const MINIMUM_THRESHOLD := 0.05

var minimum_time_elapsed := false


func enter() -> void:
	minimum_time_elapsed = false
	var threshold_timer := get_tree().create_timer(MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimum_time_elapsed = true)


func on_input(_event: InputEvent) -> void:
	if not minimum_time_elapsed:
		return

	if Input.is_action_pressed("select_card"):
		transition_requested.emit(self, CardState.State.DRAGGING)
	else:
		card.toggle_selected()
		transition_requested.emit(self, CardState.State.BASE)
