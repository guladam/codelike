class_name ExpressionBuilder
extends HBoxContainer

var current_bits: Array[CustomExpression]


func build_expression(bits: Array[CustomExpression]) -> void:
	current_bits = bits
	_clear_children()

	for bit: CustomExpression in bits:
		match bit.type:
			CustomExpression.Type.TEXT:
				_create_label(bit)
			CustomExpression.Type.TEXTURE:
				_create_texture_rect(bit)


func edit_expression(which_bit: int, custom_expression: CustomExpression) -> void:
	if which_bit >= current_bits.size():
		return
	
	var node := get_child(which_bit)
	
	match custom_expression.type:
		CustomExpression.Type.TEXT:
			_edit_label(node, custom_expression)
		CustomExpression.Type.TEXTURE:
			_edit_texture_rect(node, custom_expression)
		


func _clear_children() -> void:
	for child: Node in get_children():
		child.queue_free()


func _create_label(custom_expression: CustomExpression) -> void:
	var label := Label.new()
	_edit_label(label, custom_expression)
	add_child(label)


func _create_texture_rect(custom_expression: CustomExpression) -> void:
	var texture_rect := TextureRect.new()
	texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_edit_texture_rect(texture_rect, custom_expression)
	add_child(texture_rect)


func _edit_label(label: Label, custom_expression: CustomExpression) -> void:
	if not label:
		return
		
	label.text = custom_expression.text
	label.label_settings = custom_expression.label_settings
	

func _edit_texture_rect(texture_rect: TextureRect, custom_expression: CustomExpression) -> void:
	if not texture_rect:
		return
		
	texture_rect.texture = custom_expression.texture
	if custom_expression.texture_color:
		texture_rect.modulate = custom_expression.texture_color
