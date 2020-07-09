extends Sprite

var time_wait = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = 860
	position.x = 635
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	position.y -= 2
	time_wait += 1 * delta
	print(time_wait)
	if position.y <= 360:
		position.y = 360
		#if Input.is_action_just_pressed("ui_accept"):
		if time_wait >= 5:
			get_tree().change_scene("res://Scenes/Main_Menu.tscn")
