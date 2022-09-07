extends KinematicBody2D

var speed = 400
var maxSpeed = 150
var jumpSpeed = 250
var gravity = 500
var friction = 0.5
var velocity = Vector2()
var resistance = 0.7
var jumpNumber = 2

#const dashSpeed = 500
#const dashLength = .2

#onready var dash = $Dash

var wallJump = 150
var jumpWall = 60

var dash = 1000
var l_dash = -1000

var dashDirection = Vector2(1, 0)
var canDash = false
var dashing = false

onready var animatedSprite = get_node("AnimatedSprite")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta: float):
	dash()
	
	
	var movement_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
#	if Input.is_action_just_pressed("ui_dash"):
#		dash.start_dash(dashLength)
#		animatedSprite.play("dash")
#	var normalspeed = dashSpeed if dash.is_dashing() else maxSpeed
			
	if movement_x != 0:
		animatedSprite.play("walk")
		velocity.x += movement_x * speed * delta
		velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
		animatedSprite.flip_h = movement_x < 0
	
	if is_on_floor() or nextToWall():
		jumpNumber = 2
		if movement_x == 0:
			velocity.x = lerp(velocity.x, 0, friction)
			animatedSprite.play("idle")
		if Input.is_action_just_pressed("ui_accept") and jumpNumber > 0:
			velocity.y -= jumpSpeed
			jumpNumber -= 1
			animatedSprite.play("jump")
			if not is_on_floor() and nextToRightWall():
				velocity.x -= wallJump
				velocity.y -= jumpWall
			if not is_on_floor() and nextToLeftWall():
				velocity.x += wallJump
				velocity.y -= jumpWall
		if nextToWall() and velocity.y > 30:
			velocity.y = 30
			if nextToRightWall():
				animatedSprite.flip_h = true
				animatedSprite.play("wallSliding")
			elif nextToLeftWall():
				animatedSprite.flip_h = false
				animatedSprite.play("wallSliding")
	else:
		if movement_x == 0:
			animatedSprite.play("jump")
			velocity.x = lerp(velocity.x, 0, resistance)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)	
	
# warning-ignore:function_conflicts_variable
func dash():
	if is_on_floor():	canDash = true
	
	if Input.is_action_pressed("ui_right"):
		dashDirection = Vector2(1, 0)
		animatedSprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		dashDirection = Vector2(-1, 0)
		animatedSprite.flip_h = true
	if Input.is_action_just_pressed("ui_dash") and canDash:
		velocity = dashDirection.normalized() * 4000
		canDash = false
		dashing = true
		yield(get_tree().create_timer(0.2), "timeout")
		dashing = false
		animatedSprite.play("dash")
	
func nextToWall():
	return nextToRightWall() or nextToLeftWall()
	
func nextToRightWall():
	return $RightWall.is_colliding()

func nextToLeftWall():
	return $LeftWall.is_colliding()
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

