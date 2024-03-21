extends State
class_name NpcRoam

@export var ROAM_SPEED : float = 10

var move_direction : Vector2
var roam_time : float

func randomize_roam_time():
	roam_time = randf_range(1, 5)

func randomize_roam_dir():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func enter_state():
	randomize_roam_time()
	randomize_roam_dir()

func update(delta):
	if roam_time > 0:
		roam_time -= delta
	else:
		state_changed.emit(self, 'npcidle')

func physics_update(_delta):
	if self_body:
		self_body.velocity = move_direction * ROAM_SPEED
		
		if self_body.is_on_wall():  # Move away from walls
			move_direction = self_body.get_wall_normal()
			
		var player_dir = self_body.player_body.global_position - self_body.global_position
		if player_dir.length() <= 35:
			state_changed.emit(self, 'farmanimalflee')
