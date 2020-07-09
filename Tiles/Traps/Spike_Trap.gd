extends Area2D

var dmg = 10
var armor_dmg = 5
func _on_SpikeTrap_body_entered(body):
	if body.name == "Player_main":
		body.take_damage(dmg, armor_dmg)
