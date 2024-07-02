extends EditorInspectorPlugin

const DATA_IMPORTER := preload("res://data/csv/csv_importer.tres")

var InstructionEditor = preload("res://addons/csv_data_importer/instruction_editor.gd")
var GoalEditor = preload("res://addons/csv_data_importer/goal_editor.gd")
var DeckLoader = preload("res://addons/csv_data_importer/deck_editor.gd")


func _can_handle(object):
	return object is CSVImporter or object is CardStack


func _parse_category(object: Object, category: String) -> void:
	var importer = object as CSVImporter
	var card_stack = object as CardStack
	
	if importer:
		_handle_csv_importer(importer, category)
	if card_stack:
		_handle_card_stack(card_stack, category)


func _handle_csv_importer(importer: CSVImporter, category: String) -> void:
	if category == "Instructions":
		var instruction_editor = InstructionEditor.new()
		instruction_editor.csv_importer_data = importer
		add_custom_control(instruction_editor)
	if category == "Goals":
		var goal_editor = GoalEditor.new()
		goal_editor.csv_importer_data = importer
		add_custom_control(goal_editor)


func _handle_card_stack(card_stack: CardStack, category: String) -> void:
	if category == "Instructions":
		var deck_loader = DeckLoader.new()
		deck_loader.csv_importer_data = DATA_IMPORTER
		deck_loader.deck = card_stack
		add_custom_control(deck_loader)
