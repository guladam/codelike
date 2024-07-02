extends EditorInspectorPlugin

var InstructionEditor = preload("res://addons/csv_data_importer/instruction_editor.gd")
var GoalEditor = preload("res://addons/csv_data_importer/goal_editor.gd")


func _can_handle(object):
	return object is CSVImporter


func _parse_category(object: Object, category: String) -> void:
	var importer = object as CSVImporter
	
	if category == "Instructions":
		var instruction_editor = InstructionEditor.new()
		instruction_editor.csv_importer_data = importer
		add_custom_control(instruction_editor)
	if category == "Goals":
		var goal_editor = GoalEditor.new()
		goal_editor.csv_importer_data = importer
		add_custom_control(goal_editor)
