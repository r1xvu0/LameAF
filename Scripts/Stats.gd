extends Node2D

var gold = 0
var hp = 100
var max_hp = 100
var armor = 100
var max_armor = 100
var lvl = 1
var p_exp = 0
var lvl_threshold = 100
var heal_timer = 0
var repair_timer = 0

signal zone_level_check(lvl)
signal hp_change(hp)
signal armor_change(armor)
signal lvl_change(lvl)
signal lvl_up(max_hp, lvl_threshold)
signal exp_change(p_exp)
signal gold_change(gold)

func _ready():
	gold = 0
	max_hp = 100
	hp = 100
	max_armor = 100
	armor = 50
	lvl = 1
	lvl_threshold = 200
	p_exp = 0
	emit_signal("lvl_change", lvl)
	emit_signal("exp_change", p_exp)
	emit_signal("zone_level_check", lvl)
	emit_signal("hp_change", hp)
	emit_signal("armor_change", armor)
	emit_signal("gold_change", gold)
	emit_signal("lvl_up", max_hp, lvl_threshold)
	
func _process(delta):
	heal_timer += 1 * delta
	repair_timer += 1 * delta
	
	if p_exp >= lvl_threshold:
		lvl_threshold *= 2
		max_hp += 20
		hp = max_hp
		lvl += 1
		p_exp = 0
		emit_signal("hp_change", hp)
		emit_signal("exp_change", p_exp)
		emit_signal("zone_level_check", lvl)
		emit_signal("lvl_up", max_hp, lvl_threshold)
		emit_signal("lvl_change", lvl)
		print(max_hp)
	
	# REGENERATION // MAKING SURE HP/ARMOR AINT MORE THAN MAX
	if hp >= max_hp:
		hp = max_hp
	if hp <= 0:
		hp = 0
	if armor >= max_armor:
		armor = max_armor
	if armor <= 0:
		armor = 0
	
	if hp >= 1 && hp <= max_hp:
		emit_signal("hp_change", hp)
		if heal_timer >= 3:
			hp += 1
			heal_timer = 0
	
	if armor < max_armor && hp >= 1:
		emit_signal("armor_change", armor)
		if repair_timer >= 5:
			armor += 1
			repair_timer = 0
