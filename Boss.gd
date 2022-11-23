extends KinematicBody2D

var direction = Vector2.LEFT
var velocity = Vector2.ZERO

onready var animated_sprite = $AnimatedSprite

func _physics_process(delta):
	var found_wall = is_on_wall()
	
	
	if found_wall:
		direction *= -1
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
	
	velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)
	animated_sprite.play("BossWalk")


func _on_Hurtbox_body_entered(body):
	if body is KinematicBody2D:
		var is_dead = true
		$Hitbox/CollisionShape2D.disabled = true
		$Hurtbox/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		remove()
		
func remove():
	yield(get_tree().create_timer(0.1), "timeout")
	#animated_sprite.play("Die")
	queue_free()

func _on_Hitbox_body_entered(body):
	if body is Player:
		get_path()
