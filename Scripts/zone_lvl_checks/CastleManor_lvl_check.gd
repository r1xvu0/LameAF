extends RichTextLabel

var zone_level = 3


func _on_Stats_zone_level_check(lvl):
	if lvl - zone_level == 0:
		modulate = Color(1, 1, 1)
	elif lvl - zone_level == 1:
		modulate = Color(0.85, 1, 0.85)
	elif lvl - zone_level == 2:
		modulate = Color(0.5, 1, 0.5)
	elif lvl - zone_level >= 3:
		modulate = Color(0,1,0)
	elif lvl - zone_level == -1:
		modulate = Color(1, 0.8, 0.8)
	elif lvl - zone_level == -2:
		modulate = Color(1, 0.5, 0.5)
	elif lvl - zone_level <= -3:
		modulate = Color(1, 0.1, 0.1)

