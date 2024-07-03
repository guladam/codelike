class_name CustomExpression
extends RefCounted

enum Type {TEXT, TEXTURE}

const LABEL_SETTINGS := preload("res://game/expression_builder/expr_builder_default_label_settings.tres")
const TEXTURES := {
	"ARROW": preload("res://game/expression_builder/arrow.png"),
	"ARROW_BIG": preload("res://game/expression_builder/arrow_big.png"),
	"ARROW_SMALL": preload("res://game/expression_builder/arrow_small.png")
}

var type: Type
var texture: Texture
var texture_color := Color("c384b3")
var text: String
var label_settings: LabelSettings


func _init(which_type: Type) -> void:
	type = which_type


static func str_to_expr(expression_string: String) -> CustomExpression:
	var expr: CustomExpression
	
	if expression_string.begins_with("$"):
		expr = new(Type.TEXTURE)
		var texture_options := expression_string.substr(1).split("#")
		expr.texture = TEXTURES[texture_options[0]]
		if texture_options.size() == 2:
			print(texture_options[1])
			expr.texture_color = Color(texture_options[1])
	else:
		expr = new(Type.TEXT)
		expr.text = expression_string
		expr.label_settings = LABEL_SETTINGS
		
	return expr


static func str_to_expr_array(expression_string: String) -> Array[CustomExpression]:
	var new_array: Array[CustomExpression] = []
	var pieces := expression_string.split("|")
	
	for piece: String in pieces:
		new_array.append(CustomExpression.str_to_expr(piece))
		
	return new_array
