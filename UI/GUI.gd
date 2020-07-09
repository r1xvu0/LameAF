extends CanvasLayer

onready var dialogue = get_node('Dialogue')

func _process(_delta):
	pass
	
func _physics_process(delta): # Just to update the Variables label
	var text = 'Variables: \n' + str(PROGRESS.variables) + '\n \n Dialogues: \n' + str(PROGRESS.dialogues)
	if Input.is_action_just_pressed("ui_attack"):
		press_next()
		
func press_next():
	dialogue.next()

func _on_Stats_hp_change(hp):
	$HP_Bar.value = hp
	$HP_Label/Counter.clear()
	$HP_Label/Counter.add_text(str(hp))
	pass # Replace with function body.


func _on_Stats_exp_change(p_exp):
	$Exp_Bar.value = p_exp
	pass # Replace with function body.


func _on_Stats_armor_change(armor):
	$Armor_Bar.value = armor
	$Armor_Label/Counter.clear()
	$Armor_Label/Counter.add_text(str(armor))
	pass # Replace with function body.


func _on_Stats_lvl_change(lvl):
	$LVL_Label/Counter.clear()
	$LVL_Label/Counter.add_text(str(lvl))
	pass # Replace with function body.


func _on_Stats_gold_change(gold):
	$Gold_Label/Counter.clear()
	$Gold_Label/Counter.add_text(str(gold))
	pass # Replace with function body.


func _on_Stats_lvl_up(max_hp, lvl_threshold):
	$HP_Bar.max_value = max_hp
	$HP_Bar.value = $HP_Bar.max_value
	$Exp_Bar.max_value = lvl_threshold
	pass # Replace with function body.


func _on_Dialogue_body_entered(body):
	print(body)
	pass # Replace with function body.
