@tool
extends EditorPlugin

var plugin


func _enter_tree() -> void:
	plugin = preload("res://addons/csv_data_importer/data_importer_plugin.gd").new()
	add_inspector_plugin(plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(plugin)
