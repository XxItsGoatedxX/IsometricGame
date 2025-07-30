extends CharacterBody2D

const speed = 100
const sprint_multiplier = 1.5
var player_state
var direction = Vector2.ZERO


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
	var current_speed = speed
	$AnimatedSprite2D.speed_scale = 1
	# Check if sprinting
	if Input.is_action_pressed("sprint"):
		current_speed *= sprint_multiplier
		$AnimatedSprite2D.speed_scale = 2
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
		
