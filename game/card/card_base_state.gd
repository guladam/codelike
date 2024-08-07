extends CardState


func enter() -> void:
	if not card.is_node_ready():
		await card.ready
	
	card.z_index = 0
	card.shadow.hide()
	card.pivot_offset = card.size / 2
	_tween_rotation_reset()
	_tween_hover_reset()


func exit() -> void:
	_tween_rotation_reset()


func on_input(event: InputEvent) -> void:
	if not card.mouse_over_card or not event is InputEventMouseMotion:
		return
	
	var mouse_local := card.get_local_mouse_position()
	
	var lerp_x := mouse_local.x / card.size.x
	var lerp_y := mouse_local.y / card.size.y
	var rotation_x: float = rad_to_deg(lerp_angle(card.lerp_hover_angle_min, card.lerp_hover_angle_max, lerp_x))
	var rotation_y: float = rad_to_deg(lerp_angle(card.lerp_hover_angle_min, card.lerp_hover_angle_max, lerp_y))
	
	card.visuals.material.set_shader_parameter("x_rot", rotation_y)
	card.visuals.material.set_shader_parameter("y_rot", rotation_x)


func on_gui_input(event: InputEvent) -> void:
	if card.mouse_over_card and event.is_action_pressed("select_card"):
		card.pivot_offset = card.get_global_mouse_position() - card.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	card.z_index = 1
	
	if card.tween_hover:
		card.tween_hover.kill()
	
	card.tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	card.tween_hover.tween_property(card, "scale", card.hover_scale_vector, card.hover_scale_length)


func on_mouse_exited() -> void:
	card.z_index = 0
	
	_tween_rotation_reset()
	_tween_hover_reset()


func _tween_rotation_reset() -> void:
	if not is_inside_tree():
		return
	
	if card.tween_rotation:
		card.tween_rotation.kill()
	
	card.tween_rotation = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	card.tween_rotation.tween_property(card.visuals.material, "shader_parameter/x_rot", 0.0, card.hover_angle_reset_length)
	card.tween_rotation.parallel().tween_property(card.visuals.material, "shader_parameter/y_rot", 0.0, card.hover_angle_reset_length)


func _tween_hover_reset() -> void:
	if not is_inside_tree():
		return
	
	if card.tween_hover:
		card.tween_hover.kill()
		
	card.tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	card.tween_hover.tween_property(card, "scale", Vector2.ONE, card.hover_scale_length)
