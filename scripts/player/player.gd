extends CharacterBody2D
class_name Player

@export var MAX_STAMINA : float = 3

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var current_stamina : float = MAX_STAMINA

var direction : Vector2 
var direction_input_arr : Array = []  # To keep sprite facing last pressed direction
var stamina_depleted : bool = false
var equipped_main_hand : PhysicsItemComponent
var inventory : Dictionary = {'WEAPON' : [], 'SHIELD' : [], 'OTHER' : []}


func _process(delta):
	$UI/SelectionWheel.options = inventory['WEAPON']
	direction = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	if current_stamina <= 0: stamina_depleted = true
	if stamina_depleted: reset_stamina(delta)
	
	if $EquippedMainHand.get_child_count() != 0:
		equipped_main_hand = $EquippedMainHand.get_child(0)
		equipped_main_hand.global_position = $EquippedMainHand.global_position
	else:
		equipped_main_hand = null

func _physics_process(_delta):
	move_and_slide()
	
func _unhandled_input(event):  # Keep latest player wish dir (pressed) & last dir left (Only one that isni't released)
	if event.is_action_pressed('move_left'): direction_input_arr.append('left')
	if event.is_action_pressed('move_right'): direction_input_arr.append('right')
	if event.is_action_pressed('move_up'): direction_input_arr.append('up')
	if event.is_action_pressed('move_down'): direction_input_arr.append('down')
	
	if event.is_action_released('move_left'): direction_input_arr.erase('left')
	if event.is_action_released('move_right'): direction_input_arr.erase('right')
	if event.is_action_released('move_up'): direction_input_arr.erase('up')
	if event.is_action_released('move_down'): direction_input_arr.erase('down')


# Stamina management
func reset_stamina(delta):
	current_stamina += delta
	if current_stamina >= MAX_STAMINA * 2:  # *2 punish for depleting 
		stamina_depleted = false
		current_stamina = MAX_STAMINA

func replenish_stamina(delta):
	current_stamina += delta

func use_stamina(delta):
	current_stamina -= delta


