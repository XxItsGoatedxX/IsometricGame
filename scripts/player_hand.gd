extends Node2D

const hand_count = 5
const card_scene_path = "res://scenes/card.tscn"

var player_hand = []
var rng = RandomNumberGenerator.new()
var is_waiting_for_card = false
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if !is_waiting_for_card && $"../CanvasLayer/UI/CardHand".get_child_count() < 5 && $"../CanvasLayer/UI".get_child_count() == 1:
		is_waiting_for_card = true
		await get_tree().create_timer(1).timeout
		create_card()
		is_waiting_for_card = false
		
func _ready() -> void:
	generate_starting_hand()

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)

func remove_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)

func create_card():
	var card_scene = preload(card_scene_path)
	var random_card = rng.randi_range(1, 3)
	rng.randomize()
	var new_card = card_scene.instantiate()
	var card_data = {}
	
	if random_card == 1:
		card_data = {
			"title": "Fireball",
			"art": "res://assets/Fireball.png"
	}
	elif random_card == 2:
		card_data = {
			"title": "Ice Ray",
			"art": "res://assets/IceRay.png"
	}
	elif random_card == 3:
		card_data = {
			"title": "Poison Mist",
			"art": "res://assets/PoisonMist.png"
	}
	$"../CanvasLayer/UI/CardHand".add_child(new_card)
	new_card.name = "card"
	new_card.setup($"../CardManager", card_data)
	add_card_to_hand(new_card)
			
func generate_starting_hand():
	for i in range(hand_count):
		create_card()
				
		
