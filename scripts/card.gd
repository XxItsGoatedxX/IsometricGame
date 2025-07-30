extends Control

signal hovered
signal hovered_off

@export var label: String
@export var card_art: String

var hand_pos

func setup(manager, data := {}):
	manager.connect_card_signals(self)
	
	if "title" in data:
		$Panel/VBoxContainer/Label.text = data["title"]
	if "art" in data:
		var tex = load(data["art"])
		$Panel/VBoxContainer/CardArt.texture = tex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_mouse_exited() -> void:
	emit_signal("hovered_off", self)
