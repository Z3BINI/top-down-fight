extends Area2D

@export var health_component : HealthComponent

func _ready():
	area_entered.connect(on_took_damage)

func on_took_damage(damagebox_area2d):
	var weapon = damagebox_area2d.get_parent()
	print(weapon.item_details.DAMAGE)
