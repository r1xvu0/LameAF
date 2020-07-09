extends KinematicBody2D

signal deal_damage(damage, en)

var move_speed = 150
var jump_force = 225
var jump_timer = 0
var jumped = 1
var d_jumped = 1
var d_jump_timer = 0
var on_wall = 0
var direction = 1
var in_air = 0
var p_can_control = 1
var teleported = 0
var can_teleport = 1
var tp_timer = 0

var damage = 10

var p_health = 100
var p_attacks = 0
const GRAVITY = 225
const GRAV_MULT = 1.15
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = 0
	
	# CHECK FOR ACTION INPUT
	check_input(delta)
	
	# ACTION PINPOINT
	detection()
	
	# FINAL MOVE
	move_and_slide(velocity, Vector2(0, -1))
	# Debug Prints
	
func detection(): # Detection for floors/walls/ceilings
	var raycast_base = 30
	# CHECK IF WE LIVE
	if $Stats.hp >= 1:
		
		if direction == 1:
			$Damage_Raycast.cast_to.x = raycast_base
			$Damage_Raycast.position.x = -3
			$AnimatedSprite.flip_h = false
		
		if direction == -1:
			$Damage_Raycast.cast_to.x = -raycast_base
			$Damage_Raycast.position.x = 3
			$AnimatedSprite.flip_h = true
		
		if velocity.x == 0 && is_on_floor() && p_attacks <= 0:
			$AnimatedSprite.play("idle")
			
		#if velocity.x > 0.1 && is_on_floor() && p_burst == 0:
		#	$AnimatedSprite.play("run")
		#if velocity.x < -0.1 && is_on_floor() && p_burst == 0:
		#	$AnimatedSprite.play("run")
		
		if is_on_wall() && is_on_floor() == false:
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
	else:
		$AnimatedSprite.play("die")
		$AnimatedSprite/Player_Aura.modulate = Color(205,0,0)
		p_can_control = 0
		velocity.y = GRAVITY * GRAV_MULT

func check_input(delta):
	# CONTROLS
	if p_can_control == 1:
		
		cast_teleport(delta)
		
		# DIRECTION
		if Input.is_action_just_pressed("ui_left"):
			direction = -1
			
		elif Input.is_action_just_pressed("ui_right"):
			direction = 1
			
		# ATTACKS
		if Input.is_action_just_pressed("ui_attack") && is_on_floor() && p_attacks == 0:
			check_enemy()
			p_attacks = 1
			$AnimatedSprite.play("attack01")
		elif Input.is_action_just_pressed("ui_attack") && is_on_floor() && p_attacks == 1:
			check_enemy()
			$AnimatedSprite.play("attack02")
			p_attacks = 2
		elif Input.is_action_just_pressed("ui_attack") && is_on_floor() && p_attacks == 2 && $AnimatedSprite.frame >=3:
			check_enemy()
			$AnimatedSprite.play("attack03")
			
		
		# RIGHT / LEFT
		if Input.is_action_pressed("ui_right") && p_attacks <= 0:
			velocity.x = move_speed
			$AnimatedSprite.play("run")

		
		elif Input.is_action_pressed("ui_left") && p_attacks <= 0:
			velocity.x = -move_speed
			$AnimatedSprite.play("run")

			
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
	if teleported == 1:
		tp_timer += 1 * delta
	if tp_timer >= 3:
		teleported = 0
		tp_timer = 0

func cast_teleport(delta):
	var tele_time = 0
	if Input.is_action_just_pressed("ui_cast") && teleported == 0 && p_attacks == 0:
		$AnimatedSprite/tp_circle.emitting = true
		$AnimatedSprite.play("cast")
		teleported = 1
		p_attacks = 1
		velocity.x = 0
		if direction == 1:
			velocity.x += 7500
		elif direction == -1:
			velocity.x -= 7500

func check_enemy():
	var en = $Damage_Raycast.get_collider()
	if en:
		if en.is_in_group("Enemies"):
			print(en.get_name())
			en.get_hit(damage)

func take_damage(dmg, armor_dmg):
	print("damage taken")
	print(dmg)
	print(armor_dmg)
	pass

func _on_AnimatedSprite_animation_finished():
	p_attacks = 0


func _on_HP_Potion_heal_hp(hp):
	$Stats.hp += hp


func _on_BlueCrystal_add_money(money):
	$Stats.gold += money
	$Stats.emit_signal("gold_change", $Stats.gold)


func _on_Gold_coin_add_gold(money):
	$Stats.gold += money
	$Stats.emit_signal("gold_change", $Stats.gold)



func _on_SpikeTrap_deal_damage(dmg, armor_dmg):
	if $Stats.hp >= 1:
		$Stats.hp -= dmg
		
	if $Stats.armor < armor_dmg:
		$Stats.hp += $Stats.armor - armor_dmg 
		$Stats.armor = 0
	elif $Stats.armor >= armor_dmg:
		$Stats.armor -= armor_dmg
	$Stats.emit_signal("hp_change", $Stats.hp)
	$Stats.emit_signal("armor_change", $Stats.armor)


func _on_Flaming_Skull_deal_damage(dmg, armor_dmg):
	if $Stats.hp >= 1:
		$Stats.hp -= dmg
		
	if $Stats.armor < armor_dmg:
		$Stats.hp += $Stats.armor - armor_dmg 
		$Stats.armor = 0
	elif $Stats.armor >= armor_dmg:
		$Stats.armor -= armor_dmg
	$Stats.emit_signal("hp_change", $Stats.hp)
	$Stats.emit_signal("armor_change", $Stats.armor)


func _on_Flaming_Skull_grant_exp(experience):
	$Stats.p_exp += experience
	$Stats.emit_signal("exp_change", $Stats.p_exp)
