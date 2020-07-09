extends KinematicBody2D

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1

var hp = 20
var hp_max = 20
var experience = 500
var dmg = 20
var armor_dmg = 10

var emit = 1
var emit_timer = 0

signal deal_damage(dmg, armor_dmg)
signal grant_exp(experience)


func _ready():
	add_to_group("Enemy")
	print(get_node(".").name)
	pass

func _physics_process(delta):
	if emit == 0:
		$get_hit_particle2.emitting = true
		emit_timer += 1
	if emit == 1:
		$get_hit_particle2.emitting = false
		
	if hp <= 0:
		queue_free()
		emit_signal("grant_exp", experience)
	if direction == 1:
		$AnimatedSprite.flip_h = false
		velocity.x = SPEED
	if direction == -1:
		$AnimatedSprite.flip_h = true
		velocity.x = -SPEED
	
	velocity.y = GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)	
	
	if is_on_wall() == true:
		direction *= -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction *= -1
		$RayCast2D.position.x *= -1


func _on_Area2D_area_entered(area):
	if area.name == "Player_Area2D":
		emit_signal("deal_damage", dmg, armor_dmg)


func _on_Player_main_deal_damage(damage, en):
	print(get_node(".").name)
	if en == get_node(".").name:
		self.queue_free()
		
func get_hit(dmg):

	emit = 0
	
	if emit_timer == 1:
		emit == 1
		emit_timer = 0
	hp -= dmg
	print(hp)
	return hp

