extends CharacterBody2D

const speed = 100
const sprint_multiplier = 1.5
const max_stamina = 100
const FIREBALL = preload("res://scenes/fireball.tscn")

@onready var card_hand = $"../CanvasLayer/UI/CardHand"
@onready var marker_2d = $Marker2D
var player_state
var direction = Vector2.ZERO
var stamina = max_stamina
var is_sprinting = false

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - marker_2d.global_position
	marker_2d.rotation = direction.angle()

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
	
	if Input.is_action_just_pressed("shoot") && card_hand.selected_card:
		var card = card_hand.selected_card
		if card.label == "Fireball":
			shoot_fireball()
			#needs to remove the card from the hand array
			player_hand.remove_from_hand(card)
			card.queue_free()
			#sets selected card back to being unassigned
			player_hand.selected_card = null
	
	var current_speed = speed
	var anim_speed = 1.0
	var sprint_cost = 20 * delta
	var can_sprint = Input.is_action_pressed("sprint") && direction != Vector2.ZERO && stamina > 0
	$AnimatedSprite2D.speed_scale = 1
	# Check if sprinting
	if can_sprint:
		is_sprinting = true
		current_speed *= sprint_multiplier
		anim_speed = 2.0
		
		stamina -= sprint_cost
		if stamina <= 0:
			stamina = 0
			is_sprinting = false
			current_speed = speed
			anim_speed = 1.0
	else:
		is_sprinting = false
		current_speed = speed
		anim_speed = 1.0
		
	if !is_sprinting && stamina < max_stamina:			
		stamina += 10 * delta
		
	stamina = clamp(stamina, 0, max_stamina)		
	$AnimatedSprite2D.speed_scale = anim_speed
	$"../CanvasLayer/StatusUI/StaminaBar".value = stamina
	
	play_animation(direction)
	velocity = direction * current_speed
	move_and_slide()

func play_animation(direction):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if direction.y == -1:
			$AnimatedSprite2D.play("walk-n")
		if direction.y == 1:
			$AnimatedSprite2D.play("walk-s")
		if direction.x == -1:
			$AnimatedSprite2D.play("walk-w")
		if direction.x == 1:
			$AnimatedSprite2D.play("walk-e")
		if direction.x > 0.5 and direction.y < -0.5:
			$AnimatedSprite2D.play("walk-ne")
		if direction.x > 0.5 and direction.y > 0.5:
			$AnimatedSprite2D.play("walk-se")
		if direction.x < -0.5 and direction.y < -0.5:
			$AnimatedSprite2D.play("walk-nw")
		if direction.x < -0.5 and direction.y > 0.5:
			$AnimatedSprite2D.play("walk-sw")
		
func dash_animation(direction):
	if direction.y == -1:
		$AnimatedSprite2D.play("walk-n")
	if direction.y == 1:
		$AnimatedSprite2D.play("walk-s")
	if direction.x == -1:
		$AnimatedSprite2D.play("walk-w")
	if direction.x == 1:
		$AnimatedSprite2D.play("walk-e")
	if direction.x > 0.5 and direction.y < -0.5:
		$AnimatedSprite2D.play("walk-ne")
	if direction.x > 0.5 and direction.y > 0.5:
		$AnimatedSprite2D.play("walk-se")
	if direction.x < -0.5 and direction.y < -0.5:
		$AnimatedSprite2D.play("walk-nw")
	if direction.x < -0.5 and direction.y > 0.5:
		$AnimatedSprite2D.play("walk-sw")

func shoot_fireball():
	var fireball = FIREBALL.instantiate()
	get_tree().current_scene.add_child(fireball)
	fireball.transform = $Marker2D.global_transform
