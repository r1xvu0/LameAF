extends KinematicBody2D

# warning-ignore:unused_signal
signal health_changed
var move_speed = 150
var jump_force = 225
var jump_timer = 0
var jumped = 1
var d_jumped = 1
var d_jump_timer = 0
var on_wall = 0
var direction = 0
var in_air = 0

var p_health = 1


var p_attacks = 0
const GRAVITY = 225
const GRAV_MULT = 1.15
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = 0
	# CHECK FOR ACTION INPUT
	check_input(delta)
	
	# FINAL MOVE
	detection()
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2(0, -1))
	# Debug Prints
	
func detection():
	if p_health == 0:
		queue_free()
	
	if velocity.x == 0 && is_on_floor() && p_attacks <= 0:
		$AnimatedSprite.play("idle")
	
	if is_on_wall():
		$AnimatedSprite.play("hold_wall")
	
	if is_on_floor() == false && is_on_wall() == false && velocity.y == GRAVITY*GRAV_MULT:
		$AnimatedSprite.play("fall")
	
	
	if velocity.y > 0: #Disable Infinite Jumps
		jumped = 1
		jump_timer = 0.4
	# DETECT FLOOR
	if is_on_floor():
		jumped = 0
		jump_timer = 0
	# DETECT WALLS
	elif is_on_wall():
		velocity.y = (GRAVITY * GRAV_MULT) / 5 #REDUCE GRAVITY ON WALL
		jumped = 0
		jump_timer = 0
		on_wall = 1
	# DETECT CEILING
	elif is_on_ceiling(): #Disable Jump
		jumped = 1
		jump_timer = 2
	else:
		on_wall = 0

func check_input(delta):
	# CONTROLS
	
	# ATTACKS
	if Input.is_action_just_pressed("ui_attack") && is_on_floor() && p_attacks == 0:
		p_attacks = 1
		$AnimatedSprite.play("attack01")
	elif Input.is_action_just_pressed("ui_attack") && is_on_floor() && p_attacks == 1:
		$AnimatedSprite.play("attack02")
		p_attacks = 2
	elif Input.is_action_just_pressed("ui_attack") && is_on_floor() && p_attacks == 2 && $AnimatedSprite.frame >=4:
		$AnimatedSprite.play("attack03")
		
	# RIGHT / LEFT
	if Input.is_action_pressed("ui_right") && p_attacks <= 0:
		velocity.x = move_speed
		$AnimatedSprite.flip_h = false
		if is_on_floor():
			$AnimatedSprite.play("run")
		elif is_on_wall():
			$AnimatedSprite.play("hold_wall")
	
	elif Input.is_action_pressed("ui_left") && p_attacks <= 0:
		velocity.x = -move_speed
		$AnimatedSprite.flip_h = true
		if is_on_floor():
			$AnimatedSprite.play("run")
		elif is_on_wall():
			$AnimatedSprite.play("hold_wall")
		
	# JUMP
	if Input.is_action_pressed("ui_up") && jumped == 0 && jump_timer < 2 && p_attacks <= 0:
		if on_wall == 0:
			$AnimatedSprite.play("jump")
		
		jump_timer += 1 * delta
		velocity.y = 0
		velocity.y -= jump_force
		
		if jump_timer >= 0.4:
			jumped = 1
			d_jumped = 0
	else:
		velocity.y = GRAVITY * GRAV_MULT

func _on_AnimatedSprite_animation_finished():
	p_attacks = 0
