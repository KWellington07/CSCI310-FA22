extends Area2D

var speed = 100
var moveable = true

func _ready():
	#if Player.animatedSprite.flip_h == false:
	#	speed = 100
	#elif Player.animatedSprite.flip_h == true:
	#	speed = -100
	speed = 100
	
func _physics_process(delta):
	if moveable == true:
		position.x += speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("Enemy"):
		body.remove()
		speed = 0
		moveable = false
		remove()
		
func remove():
	yield(get_tree().create_timer(0.01), "timeout")
	queue_free()
