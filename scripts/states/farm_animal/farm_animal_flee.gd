extends State
class_name FarmAnimalFlee

@export var FLEE_SPEED : float = 50

var player_body : CharacterBody2D
var flee_direction : Vector2 

func enter_state():
	pass

func exit_state():
	pass

func update(_delta):
	pass

func physics_update(_delta):
	var player_dir : Vector2 = self_body.player_body.global_position - self_body.global_position
	
	if player_dir.length() >= 45:
		state_changed.emit(self, 'npcroam')
	elif player_dir.length() < 45 and player_dir.length() > 25:
		flee_direction = -(player_dir.normalized())
	elif player_dir.length() <= 25:
		if self_body.is_on_wall():
			if self_body.get_wall_normal() == Vector2.UP or self_body.get_wall_normal() == Vector2.DOWN: 
				flee_direction.x = get_random_dir()
				flee_direction.y = self_body.get_wall_normal().y
			elif self_body.get_wall_normal() == Vector2.LEFT or self_body.get_wall_normal() == Vector2.RIGHT: 
				flee_direction.x = self_body.get_wall_normal().x   
				flee_direction.y = get_random_dir()

	self_body.velocity = self_body.velocity.move_toward(flee_direction * FLEE_SPEED, 2)

func get_random_dir():
	var dirs : Array = [-1, 1]
	return dirs[randi_range(0, 1)]

