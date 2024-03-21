extends Node
class_name HealthComponent

signal died

@export var MAX_HEALTH : float

var current_health : float

func _ready():
	current_health = MAX_HEALTH
	
func _process(_delta):
	if current_health <= 0: die()

func take_damage(damage):
	current_health -= damage
	
func heal(amount):
	current_health += amount

func die():
	died.emit()

 
