extends RigidBody2D
class_name PhysicsItemComponent

@export_enum('WEAPON', 'SHIELD', 'OTHER') var ITEM_TYPE : String 
@export var item_details : Sprite2D  # Holds the texture & stats...

@onready var interaction_area_component : InteractionAreaComponent = $"InteractionAreaComponent"
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group('player')

var picked_up : bool = false  # Maybe delete? Need to think about picked up, on hand and drop relationship
# Not all physics items will be weapons...
var DAMAGE_BOX : DamageboxComponent = null  
var toggle_damage_box_disabled : Callable = func(_switch : bool):
	return 'No DamageBox to toggle.'

func _ready():
	interaction_area_component.interact = Callable(self, '_pick_up_item')
	if ITEM_TYPE == 'WEAPON':  # Not all physics items will be weapons...
		setup_weapon_dependencies()

func _process(_delta):
	if Input.is_action_just_pressed('drop_item') && picked_up:  # Need to think about picked up, on hand and drop relationship
		_drop_item()
		interaction_area_component.toggle_disable(false)  # Re-enable interaction
		if DAMAGE_BOX:  # Not all physics items will be weapons...
			toggle_damage_box_disabled.call(true) 

func add_item_to_inventory(existing_index = null):  
	#if existing_index == null:  TMP REMOVED STACKING FEATURE TO TEST WHEEL
	player.inventory[ITEM_TYPE].append([item_details.duplicate(), 1, self.scene_file_path])
	#else:
		#player.inventory[ITEM_TYPE][existing_index][1] += 1

func check_for_item_in_inventory():  # Find out if item already exists within inventory
	for index in player.inventory[ITEM_TYPE].size():
		if player.inventory[ITEM_TYPE][index][2] == self.scene_file_path:
			return index
		if index == player.inventory[ITEM_TYPE].size() - 1:
			return -1
			
func _pick_up_item():  # Default callable to interact trigger with item
	if player.inventory[ITEM_TYPE].size() == 0:
		add_item_to_inventory()
	else:
		var found_item_indx = check_for_item_in_inventory()
		if found_item_indx == -1: add_item_to_inventory() 
		else: add_item_to_inventory(found_item_indx)
		
	self.queue_free()
	print(player.inventory['WEAPON'][0][0].DAMAGE)
	
	#get_parent().remove_child(self)
	#player.get_child(0).add_child(self)
	#global_position = player.get_child(0).global_position
	#interaction_area_component.toggle_disable(true)
	#picked_up = true
	
func _drop_item():
	var current_level_node = get_parent().get_parent().get_parent()
	var current_weapon_pos = get_parent().global_position
	var random_drop_dirs : Array = [-1000, 1000]
	
	get_parent().remove_child(self)
	current_level_node.add_child(self)
	
	global_position = current_weapon_pos
	apply_force(Vector2(random_drop_dirs[randi_range(0, 1)], random_drop_dirs[randi_range(0, 1)]))
	picked_up = false

func setup_weapon_dependencies():
	DAMAGE_BOX = $DamageboxComponent
	toggle_damage_box_disabled = func(switch : bool):
		DAMAGE_BOX.get_child(0).disabled = switch
