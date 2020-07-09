extends Area2D

var show_timer = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Location_Sign_body_entered(body):
	if body.name == "Player_main":
		$Text.visible = true
	pass # Replace with function body.


func _on_Location_Sign_body_exited(body):
	if body.name == "Player_main":
		$Text.visible = false
	pass # Replace with function body.
