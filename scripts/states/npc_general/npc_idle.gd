extends State
class_name  NpcIdle

var idle_time : float

func randomize_idle_time():
	idle_time = randf_range(5, 10)

func enter_state():
	randomize_idle_time()

func update(delta):
	if idle_time > 0:
		idle_time -= delta
	else:
		state_changed.emit(self, 'npcroam')

func physics_update(_delta):
	if self_body:
		self_body.velocity = Vector2.ZERO
		
		var player_dir = self_body.player_body.global_position - self_body.global_position
		if player_dir.length() <= 35:
			state_changed.emit(self, 'farmanimalflee')
