extends Area2D

signal heal_hp(hp)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HP_Potion_body_entered(body):
	if body.name == "Player_main":
		emit_signal("heal_hp", 50)
		queue_free()
	
