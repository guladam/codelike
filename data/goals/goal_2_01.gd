extends Goal


func are_goals_met() -> bool:
	return VAR_B.value >= 4 and VAR_D.value < 0