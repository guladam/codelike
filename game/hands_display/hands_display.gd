class_name HandsDisplay
extends Label

@export var run_stats: RunStats : set = set_run_stats


func set_run_stats(value: RunStats) -> void:
	run_stats = value
	run_stats.hands_changed.connect(_update_text)
	_update_text()


func _update_text() -> void:
	text = tr("HANDS_DISPLAY") % run_stats.current_hands
