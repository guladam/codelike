extends CardState


func enter() -> void:
	card.released.emit(card)


func post_enter() -> void:
	transition_requested.emit(self, CardState.State.BASE)
