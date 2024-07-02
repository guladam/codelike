extends EditorProperty

var property_control = Button.new()
var updating = false
var csv_importer_data: CSVImporter


func _init():
	label = "IMPORT BUTTON -->"
	property_control.text = "Import Instruction Data"
	add_child(property_control)
	add_focusable(property_control)
	property_control.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	if (updating):
		return
		
	updating = true
	property_control.disabled = true
	
	var f := FileAccess.open(csv_importer_data.instruction_csv, FileAccess.READ)
	f.get_csv_line() # ignore first
	
	while not f.eof_reached():
		var line = f.get_csv_line()
		
		if line.size() <= 1: # skip last line
			continue
		
		var instruction_path = csv_importer_data.instruction_path + "/" + line[0] + ".tres"
		var script_path = csv_importer_data.instruction_code_path + "/" + line[1]
		var variable_path = csv_importer_data.variables_path + "/" + line[3] + ".tres"
		var instruction
		
		if ResourceLoader.exists(instruction_path): # update
			instruction = ResourceLoader.load(instruction_path)
		else: # create new
			instruction = Resource.new()
		
		# set common instruction data
		instruction.set_script(ResourceLoader.load(script_path))
		instruction.name = line[2]
		instruction.variable_to_set = ResourceLoader.load(variable_path)
		
		# set second_variable if present
		if line[4].strip_edges().length() > 0:
			var second_var_path = csv_importer_data.variables_path + "/" + line[4] + ".tres"
			instruction.second_variable = ResourceLoader.load(second_var_path)
		
		# finally, save resource either way
		ResourceSaver.save(instruction, instruction_path)
		
	f.close()
	
	property_control.disabled = false
	updating = false
