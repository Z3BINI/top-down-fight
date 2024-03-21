extends Node
class_name StateMachine

@export var starting_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	# Store all of StateMachine's children in dictionary
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_changed.connect(on_state_transition)  # Connect all of state's "state_changed" signal to on_state_transition()
	
	if starting_state:  # If starting state isn't empty load it
		starting_state.enter_state()
		current_state = starting_state

func _process(delta):
	if current_state:  # Load current_state's update()
		current_state.update(delta)

func _physics_process(delta):
	if current_state:  # Load current_state's phyisics_update()
		current_state.physics_update(delta)

func on_state_transition(calling_state : State, new_state_name : String):
	if calling_state != current_state:
		return
	
	var new_state : State = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.exit_state()
	
	new_state.enter_state()
	
	current_state = new_state

