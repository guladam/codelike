extends CardState

var mouse_over_card := false


func enter() -> void:
	if not card.is_node_ready():
		await card.ready
	
	card.pivot_offset = Vector2.ZERO


func exit() -> void:
	card.visuals.material.set_shader_parameter("x_rot", 0.0)
	card.visuals.material.set_shader_parameter("y_rot", 0.0)


func on_input(event: InputEvent) -> void:
	if not mouse_over_card or not event is InputEventMouseMotion:
		return
	
	var mouse_local := card.get_local_mouse_position()
	
	var lerp_x := mouse_local.x / card.size.x
	var lerp_y := mouse_local.y / card.size.y
	var rotation_x: float = rad_to_deg(lerp_angle(card.LERP_HOVER_ANGLE_MIN, card.LERP_HOVER_ANGLE_MAX, lerp_x))
	var rotation_y: float = rad_to_deg(lerp_angle(card.LERP_HOVER_ANGLE_MIN, card.LERP_HOVER_ANGLE_MAX, lerp_y))
	
	card.visuals.material.set_shader_parameter("x_rot", rotation_y)
	card.visuals.material.set_shader_parameter("y_rot", rotation_x)


func on_gui_input(event: InputEvent) -> void:
	if mouse_over_card and event.is_action_pressed("select_card"):
		card.pivot_offset = card.get_global_mouse_position() - card.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	mouse_over_card = true
	card.z_index = 9


func on_mouse_exited() -> void:
	mouse_over_card = false
	card.z_index = 0
	
	card.visuals.material.set_shader_parameter("x_rot", 0.0)
	card.visuals.material.set_shader_parameter("y_rot", 0.0)
