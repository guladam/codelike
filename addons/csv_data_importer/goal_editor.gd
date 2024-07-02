extends EditorProperty

const SCRIPT_TEMPLATE = """
extends Goal


func are_goals_met() -> bool:
	return %s"""

var property_control = Button.new()
var updating = false
var csv_importer_data: CSVImporter


func _init():
	label = "IMPORT BUTTON -->"
	property_control.text = "Import Goal Data"
	add_child(property_control)
	add_focusable(property_control)
	property_control.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	if (updating):
		return
		
	updating = true
	property_control.disabled = true
	
	var f := FileAccess.open(csv_importer_data.goals_csv, FileAccess.READ)
	f.get_csv_line() # ignore first
	
	while not f.eof_reached():
		var line = f.get_csv_line()
		
		if line.size() <= 1: # skip last line
			continue
		
		var goal_path = csv_importer_data.goals_path + "/" + line[0] + ".tres"
		var script_path = csv_importer_data.goals_path + "/" + line[0] + ".gd"
		var goal
		var script
		
		if ResourceLoader.exists(goal_path): # update goal
			goal = ResourceLoader.load(goal_path)
		else: # create new goal
			goal = Resource.new()
		
		# script
		if ResourceLoader.exists(script_path): # update script
			script = ResourceLoader.load(script_path)
		else: # create new script
			script = GDScript.new()
		
		# set source code and save it either way
		script.source_code = SCRIPT_TEMPLATE.lstrip("\n") % line[3]
		ResourceSaver.save(script, script_path)
		
		goal.set_script(script)
		goal.level = int(line[1])
		goal.text = line[2]
		
		# finally, save resource either way
		ResourceSaver.save(goal, goal_path)
		
	f.close()
	
	property_control.disabled = false
	updating = false
