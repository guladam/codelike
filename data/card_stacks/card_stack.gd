class_name CardStack
extends Resource

signal size_changed(new_size: int)

@export_category("Instructions")
@export_file var csv_file: String
@export var instructions: Array[Instruction] = []


func empty() -> bool:
	return instructions.is_empty()


func draw() -> Instruction:
	var instruction = instructions.pop_front()
	size_changed.emit(instructions.size())
	return instruction


func add(instruction: Instruction) -> void:
	instructions.append(instruction)
	size_changed.emit(instructions.size())


func shuffle() -> void:
	instructions.shuffle()


func clear() -> void:
	instructions.clear()
	size_changed.emit(instructions.size())


func reset_to_default(card_stack: CardStack) -> void:
	instructions.clear()
	
	for instruction: Instruction in card_stack.instructions:
		instructions.append(instruction)
		
	size_changed.emit(instructions.size())
