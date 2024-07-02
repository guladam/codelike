extends CardState


func enter() -> void:
	card.shadow.hide()
	card.released.emit(card)


func post_enter() -> void:
	transition_requested.emit(self, CardState.State.BASE)
