extends EditorProperty

var property_control = Button.new()
var updating = false
var csv_importer_data: CSVImporter
var deck: CardStack


func _init():
	label = "Load Deck From CSV -->"
	property_control.text = "Load Deck CSV"
	add_child(property_control)
	add_focusable(property_control)
	property_control.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	if (updating):
		return
		
	updating = true
	property_control.disabled = true
	
	var f := FileAccess.open(deck.csv_file, FileAccess.READ)
	f.get_csv_line() # ignore first
	var new_array: Array[Instruction] = []
	
	while not f.eof_reached():
		var line = f.get_csv_line()
		
		if line[0] == "": # skip last line
			continue
		
		var instruction_path = csv_importer_data.instruction_path + "/" + line[0] + ".tres"
		var instruction
		
		if ResourceLoader.exists(instruction_path):
			instruction = ResourceLoader.load(instruction_path)
			new_array.append(instruction)
		
		deck.instructions = new_array
		ResourceSaver.save(deck, deck.resource_path)
		
	f.close()
	
	property_control.disabled = false
	updating = false
