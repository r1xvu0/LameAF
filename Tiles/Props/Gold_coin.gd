extends Area2D

signal add_gold(amount)


func _on_Gold_coin_body_entered(body):
	if body.name == "Player_main":
		emit_signal("add_gold")
		queue_free()
	pass # Replace with function body.
