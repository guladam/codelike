extends CardState


func post_enter() -> void:
	transition_requested.emit(self, CardState.State.BASE)
