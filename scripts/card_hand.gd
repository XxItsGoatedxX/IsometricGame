extends HBoxContainer

var hightlighted_card

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var index = -1
		match event.keycode:
			KEY_1: index = 0
			KEY_2: index = 1
			KEY_3: index = 2
			KEY_4: index = 3
			KEY_5: index = 4
		
		if index >= 0 and index < get_child_count():
			var selected = get_child(index)
			select_card(selected)
			
func select_card(card):
	var style_box = StyleBoxFlat.new()
	var style_box2 = StyleBoxFlat.new()
	var panel = card.get_node("Panel")
	
	if (hightlighted_card && hightlighted_card != card):
		var old_panel = hightlighted_card.get_node("Panel")
		if old_panel:
			style_box2.bg_color = Color("#e3ad87")
			set_corner_radius(style_box2)
			old_panel.add_theme_stylebox_override("panel", style_box2)
			
	if(card != hightlighted_card):
		style_box.bg_color = Color("#f2d4bf")
		set_corner_radius(style_box)
		if panel:
			panel.add_theme_stylebox_override("panel", style_box)
			print("Selected card: ", card.name)
			hightlighted_card = card
		else:
			print("fail")
	else:
		style_box.bg_color = Color("#e3ad87")
		set_corner_radius(style_box)
		if panel:
			panel.add_theme_stylebox_override("panel", style_box)
			print("Unselected card: ", card.name)
			hightlighted_card = null
		else:
			print("fail")

func set_corner_radius(style_box):
	style_box.corner_radius_bottom_left = 10
	style_box.corner_radius_bottom_right = 10
	style_box.corner_radius_top_left = 10
	style_box.corner_radius_top_right = 10
