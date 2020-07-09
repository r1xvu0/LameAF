extends Area2D

var money
signal add_money(money)

func _on_BlueCrystal_body_entered(body):
	money = randi() % 50
	if body.name == "Player_main":
		emit_signal("add_money", money)
		queue_free()
