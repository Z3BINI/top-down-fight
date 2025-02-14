@tool
extends Control

const SPRITE_SIZE = Vector2(8, 18)

@export var bg_color : Color
@export var line_color : Color
@export var highlight_color : Color
@export var line_width : float = 1
@export var outer_radius : int = 64
@export var inner_radius : int = 16

var options = []
var selection = 0

func Close():
	hide()
	print(options[selection]) 
	# Send data (make a text/int value that will be linked to a obj and then spawn objs from that value)
	# Like this the wheel and inventory only needs text/ints (maybe just store Sprite for ilustration of item)

func _draw():
	
	var offset = SPRITE_SIZE / -2
	
	draw_circle(Vector2.ZERO, outer_radius, bg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 128, line_color, line_width, true)
	
	if len(options) >= 1:
		for i in range(len(options) - 1):
			var rads =  TAU * i / (len(options) - 1)
			var point = Vector2.from_angle(rads)
			draw_line(
				point * inner_radius,
				point * outer_radius,
				line_color,
				line_width,
				true
			)
		
		if selection == 0:
			draw_circle(Vector2.ZERO, inner_radius, highlight_color)	
		
		draw_texture_rect(
			options[0][0].texture,
			Rect2(offset, SPRITE_SIZE),
			true
		)
		
		for i in range(1, len(options)):
			var start_rads = (TAU * (i - 1)) / (len(options) - 1)
			var end_rads = (TAU * i) / (len(options) - 1)
			var mid_rads = (start_rads + end_rads) / 2.0 * - 1
			var radius_mid = (inner_radius + outer_radius) / 2
			
			if selection == i:
				var points_per_arc = 16
				var points_inner = PackedVector2Array()
				var points_outer = PackedVector2Array()
				
				for j in range(points_per_arc + 1):
					var angle = start_rads + j * (end_rads - start_rads) / points_per_arc
					points_inner.append(inner_radius * Vector2.from_angle(TAU - angle))
					points_outer.append(outer_radius * Vector2.from_angle(TAU - angle))
					
				points_outer.reverse()
				draw_polygon(
					points_inner + points_outer,
					PackedColorArray([highlight_color])
				)
					
			var draw_pos = radius_mid * Vector2.from_angle(mid_rads) + offset
			draw_texture_rect(
				options[i][0].texture,
				Rect2(draw_pos, SPRITE_SIZE),
				true
			)
	
func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	var mouse_radius = mouse_pos.length()
	
	if mouse_radius < inner_radius:
		selection = 0
	else:
		var mouse_rads = fposmod(mouse_pos.angle() * - 1, TAU)
		selection = ceil((mouse_rads / TAU) * (len(options) - 1))
		
	
	
	queue_redraw()
