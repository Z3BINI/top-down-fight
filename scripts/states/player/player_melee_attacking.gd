extends State
class_name PlayerMeleeAttacking

@export var MELEE_MOVE_SPEED : float = 35

func enter_state():
	self_body.equipped_main_hand.toggle_damage_box_disabled.call(false)  # Turn ON weapon collision
	self_body.animation_player.play('attack')
	await self_body.animation_player.animation_finished
	
	if self_body.direction == Vector2.ZERO:
		state_changed.emit(self, 'playeridle')
	else:
		state_changed.emit(self, 'playermoving')
		
func exit_state():
	if self_body.equipped_main_hand:
		self_body.equipped_main_hand.toggle_damage_box_disabled.call(true)  # Turn OFF weapon collision

func physics_update(_delta : float):
	# For now slow player down to MELEE_MOVE_SPEED while attacking
	self_body.velocity = self_body.velocity.move_toward(self_body.direction * MELEE_MOVE_SPEED, 10)  
