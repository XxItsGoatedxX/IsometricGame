extends Node2D

const hand_count = 3
const card_scene_path = "res://scenes/card.tscn"

var player_hand = []
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card_scene = preload(card_scene_path)
	

	for i in range(hand_count):
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
				"art": "res://assets/CardTemplate.png"
			}
		elif random_card == 3:
			card_data = {
				"title": "Poison Mist",
				"art": "res://assets/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt.png"
			}

		$"../CanvasLayer/UI/CardHand".add_child(new_card)
		new_card.name = "card"
		new_card.setup($"../CardManager", card_data)
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)

func remove_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
