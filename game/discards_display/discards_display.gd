class_name DiscardsDisplay
extends Label

@export var run_stats: RunStats : set = set_run_stats


func set_run_stats(value: RunStats) -> void:
	run_stats = value
	run_stats.discards_changed.connect(_update_text)
	_update_text()


func _update_text() -> void:
	text = "Discards: %s" % run_stats.current_discards
