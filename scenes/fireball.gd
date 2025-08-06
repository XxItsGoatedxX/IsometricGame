extends Area2D
@export var speed = 100
@export var damage = 10
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("mobs"):
		explode()
		body.queue_free()
	
func explode():
	$Sprite2D.play("explosion")
	#Deal damage to all mobs in the tile area
