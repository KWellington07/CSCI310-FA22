extends KinematicBody2D
class_name Player

enum { MOVE, CLIMB }

export(int) var JUMP_FORCE = -130
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4

var velocity = Vector2.ZERO
var state = MOVE

onready var animatedSprite = $AnimatedSprite
onready var ladderCheck = $LadderCheck

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)
	
func move_state(input):
	if is_on_ladder() and Input.is_action_pressed("ui_up"): state = CLIMB
	
	apply_gravity()
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
	
	var was_in_air = not is_on_floor()	
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Landing"
	
func climb_state(input):
	if not is_on_ladder(): state = MOVE
	#if input.length() != 0:
	#	animatedSprite.animation = "Climb"
	#else:
	#	animatedSprite.stop()
		
	velocity = input * 50
	velocity = move_and_slide(velocity, Vector2.UP)
	animatedSprite.animation = "Climb"

func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 100)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
