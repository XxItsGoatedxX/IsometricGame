extends CharacterBody2D

const speed = 100
const sprint_multiplier = 1.5
const max_stamina = 100
var player_state
var direction = Vector2.ZERO
var stamina = max_stamina
var is_sprinting = false


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
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
		
