extends CharacterBody2D
class_name FarmAnimal

@onready var animation_player = $AnimationPlayer

var facing_dir : String
var player_body : CharacterBody2D

func _ready():
	player_body = get_tree().get_first_node_in_group('player')

func _process(_delta):
	get_facing_dir()
	update_animations()

func _physics_process(_delta):
	move_and_slide()

func get_facing_dir():
	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):  # Check which axis is dominating in current movement
			if velocity.x > 0: facing_dir = 'right'
			else: facing_dir = 'left'
		else:
			if velocity.y > 0: facing_dir = 'down'
			else: facing_dir = 'up'

func update_animations():
	if velocity == Vector2.ZERO:
		animation_player.play('idle_' + facing_dir)
	else:
		animation_player.play('roaming_' + facing_dir)
