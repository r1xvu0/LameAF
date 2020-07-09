extends Sprite


var choice = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	position = Vector2(0, 0)
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		choice += 1
	elif Input.is_action_just_pressed("ui_up"):
		choice -= 1
		
	check_choice()
	
	
		
func check_choice():
	if choice < 0:
		choice = 2
	
	if choice == 0:
		position = Vector2(500, 325)
	
	if choice == 1:
		position = Vector2(500, 355)
	
	if choice == 2:
		position = Vector2(500, 385)
	
	if choice > 2:
		choice = 0

