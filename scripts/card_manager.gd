extends Node2D

var card_being_dragged: Control
var is_hovering_on_card
var player_hand_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_hand_reference = $"../PlayerHand"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_viewport().get_mouse_position()
		card_being_dragged.position = mouse_pos - card_being_dragged.size / 2

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = get_card_under_mouse()
			if card:
				start_drag(card)
		elif card_being_dragged:
				end_drag()

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	
	var parent = card.get_parent()
	parent.remove_child(card)
	get_tree().root.get_node("Main/CanvasLayer/UI").add_child(card)
	card.move_to_front()

func end_drag():
	var card_hand = get_tree().root.get_node("Main/CanvasLayer/UI/CardHand")
	var playing_field = get_tree().root.get_node("Main/CanvasLayer/PlayingField")
	#Get drop position
	var mouse_pos = get_viewport().get_mouse_position()
	var field_rect = Rect2(playing_field.global_position, playing_field.size)
	var is_over_field = field_rect.has_point(mouse_pos)
	
	if is_over_field:
		trigger_card_effect(card_being_dragged)
		player_hand_reference.remove_from_hand(card_being_dragged)
		card_being_dragged.queue_free() #Add animation later
	else:
		# Return to hand
		card_being_dragged.get_parent().remove_child(card_being_dragged)
		card_hand.add_child(card_being_dragged)
		player_hand_reference.add_card_to_hand(card_being_dragged)
	
	card_being_dragged.scale = Vector2(1.05, 1.05)
	card_being_dragged = null

func get_card_under_mouse():
	for card in player_hand_reference.player_hand:
		var global_rect = Rect2(card.get_global_position(), card.size)
		if global_rect.has_point(get_viewport().get_mouse_position()):
			return card
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_card.z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
	
func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		var new_card_hovered = get_card_under_mouse()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
		
func trigger_card_effect(card):
	var type = card.label
	print(card.label)
	match type:
		"Fireball":
			print("Cast Fireball")
		"Ice Ray":
			print("Cast Ice Ray")
		"Poison Mist":
			print("Cast Poison Mist")
		"Drop on field":
			print("🎯 Card dropped on field effect triggered!")
		_:
			print("No effect for:", type)
