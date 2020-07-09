extends KinematicBody2D

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2.ZERO
var direction = 1
var player = null

var lvl = 1
var hp = 20
var hp_max = 20
var experience = 20
var dmg = 20
var armor_dmg = 10

var stunned = 0
var stun_timer = 0


func _ready():
	var ran_direction
	$hp_bar.max_value = hp_max
	$hp_bar.value = hp
	$lvl_label.clear()
	$lvl_label.add_text("LVL: ")
	$lvl_label.add_text(str(lvl))
	
	ran_direction = randi() % 5
	if ran_direction >= 3:
		direction = 1
	else:
		direction = -1
		
	if direction == 1:
		$RayCast2D.position.x = 8
	if direction == -1:
		$RayCast2D.position.x = -8

func _physics_process(delta):	
	if hp <= 0:
		queue_free()
		if player:
			player.take_exp(experience)
	
	if player:
		velocity = position.direction_to(player.position) * SPEED
		if velocity.x > 0:
			direction = 1
			$AnimatedSprite.flip_h = false
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
			direction = -1
	if direction == 1 && stunned == 0:
		$AnimatedSprite.flip_h = false
		velocity.x = SPEED
	if direction == -1 && stunned == 0:
		$AnimatedSprite.flip_h = true
		velocity.x = -SPEED
	
	if stunned == 1:
		stun_timer += 1*delta
		velocity.x -= 200 * direction
		if stun_timer >= 0.25:
			stun_timer = 0
			stunned = 0
	
	velocity.y = GRAVITY * 25
	
	velocity = move_and_slide(velocity, FLOOR)	
	
	if is_on_wall() == true:
		direction *= -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction *= -1
		$RayCast2D.position.x *= -1


func _on_Area2D_area_entered(area):
	if area.name == "Player_Area2D":
		area.get_parent().take_damage(dmg, armor_dmg)


func get_hit(dmg):
	stunned = 1
	hp -= dmg
	$hp_bar.value = hp
	return hp


func _on_Player_detector_body_entered(body):
	if body.name == "Player_main":
		player = body
	pass # Replace with function body.


func _on_Player_detector_body_exited(body):
	if body.name == "Player_main":
		player = null
	pass # Replace with function body.
