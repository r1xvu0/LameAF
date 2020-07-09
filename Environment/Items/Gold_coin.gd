extends Area2D


signal add_gold(money)
var money

func _on_Gold_coin_body_entered(body):
	if body.name == "Player_main":
		money = randi() % 3
		emit_signal("add_gold", money)
		queue_free()
	pass # Replace with function body.
