extends CanvasLayer

func _process(_delta):
	
	# Inventory logic
	if Input.is_action_just_pressed('toggle_inventory'):
		$Inventory.visible = !($Inventory.visible)
	
	
	# Weapon wheel UI logic
	if Input.is_action_just_pressed('show_weapon_wheel'):
		$SelectionWheel.show()
	elif Input.is_action_just_released('show_weapon_wheel'):
		$SelectionWheel.Close()
