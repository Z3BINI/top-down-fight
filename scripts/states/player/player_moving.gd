extends State
class_name PlayerMoving

@onready var curr_stamina : float = self_body.MAX_STAMINA

@export var RUN_SPEED : float = 80
@export var WALK_SPEED : float = 50

var current_speed : float

func update(delta : float):
	update_moving_animations()
	
	if Input.is_action_pressed('run') && !self_body.stamina_depleted:
		sprint()
		self_body.use_stamina(delta)
	else:
		walk()
		if !self_body.stamina_depleted && self_body.current_stamina < self_body.MAX_STAMINA: 
			self_body.replenish_stamina(delta)
			
	if Input.is_action_just_pressed('melee_attack') && self_body.equipped_main_hand:
		if self_body.equipped_main_hand.ITEM_TYPE == 'WEAPON':
			state_changed.emit(self, 'playermeleeattacking')

func physics_update(_delta : float):
	self_body.velocity = self_body.velocity.move_toward(self_body.direction * current_speed, 10)
	
	if self_body.direction == Vector2.ZERO:
		state_changed.emit(self, 'playeridle')

func update_moving_animations():
	if self_body.direction_input_arr.size() > 1:  # Going in an angle, look at latest press dir
		self_body.animation_player.play('walk_' + self_body.direction_input_arr[self_body.direction_input_arr.size() - 1])
	elif self_body.direction_input_arr.size() == 1:  # Going 1D (Check to avoid accessing [0] when non existant)
		self_body.animation_player.play('walk_' + self_body.direction_input_arr[0])

func sprint():
	current_speed = RUN_SPEED

func walk():
	current_speed = WALK_SPEED
