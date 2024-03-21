extends State
class_name PlayerIdle

func enter_state():
	pass  # Play idle animation whenever that exists

func update(delta : float):
	if !self_body.stamina_depleted && self_body.current_stamina < self_body.MAX_STAMINA: 
		self_body.replenish_stamina(delta)
		
	if Input.is_action_just_pressed('melee_attack') && self_body.equipped_main_hand:
		if self_body.equipped_main_hand.ITEM_TYPE == 'WEAPON':
			state_changed.emit(self, 'playermeleeattacking')
		
	if self_body.direction != Vector2.ZERO:
		state_changed.emit(self, 'playermoving')

func physics_update(_delta : float):
	if self_body.velocity != Vector2.ZERO:
		self_body.velocity = self_body.velocity.move_toward(Vector2.ZERO, 2)
