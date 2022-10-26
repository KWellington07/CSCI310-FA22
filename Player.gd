extends KinematicBody2D

export(int) var JUMP_FORCE = -130
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4

var velocity = Vector2.ZERO
var motion = Vector2()

onready var animatedSprite = $AnimatedSprite
var attacking = false
var attack_anim = null
var anim_numb = 1

onready var ladderCheck = $LadderCheck


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	apply_gravity() 
	attack_anim = "Knuckle"+str(anim_numb)
	var input = Vector2.ZERO

	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "Run"
		
		if input.x > 0:
			animatedSprite.flip_h = false
		elif input.x < 0:
			animatedSprite.flip_h = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
			
	else:
		animatedSprite.animation  = "Jump2"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
			
		if velocity.y > 0:
			animatedSprite.animation = "Falling"
			velocity.y += ADDITIONAL_FALL_GRAVITY
	
	if Input.is_action_just_pressed("light_attack"):
		$Timer.start()
		attack()
		
		if $Timer.time_left > 0:
			anim_numb += 1
		if anim_numb == 4:
			anim_numb = 1
			
	
	var was_in_air = not is_on_floor()	
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Landing"


func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 100)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
	
func attack():
	attacking = true
	$AnimatedSprite.play(attack_anim)
	yield($AnimatedSprite, "animation_finished")
	attacking = false
	
func _on_Timer_timeout():
	anim_numb = 1


	
