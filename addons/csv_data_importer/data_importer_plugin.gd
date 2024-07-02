extends EditorInspectorPlugin

var InstructionEditor = preload("res://addons/csv_data_importer/instruction_editor.gd")


func _can_handle(object):
	return object is CSVImporter


func _parse_category(object: Object, category: String) -> void:
	var importer = object as CSVImporter
	
	if category == "Instructions":
		var instruction_editor = InstructionEditor.new()
		instruction_editor.csv_importer_data = importer
		add_custom_control(instruction_editor)
	if category == "Goals":
		pass
		#add_custom_control(InstructionEditor.new())
