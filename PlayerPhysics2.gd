extends KinematicBody2D

const MOVE_SPEED = 900
const JUMP_FORCE = 900 

const GRAVITY = 50
const MAX_FALL_SPEED = 1000

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_velo = 0
var facing_right = false
var jumping = false
var jumpPower = 0.0
var crouch = false
var velocity = Vector2()
var jump_dir = 0

func _physics_process(delta):
	var move_dir = 0
	var grounded = is_on_floor()
	
	if Input.is_action_pressed("move_right") && !crouch:
		move_dir += 1

	if Input.is_action_pressed("move_left") && !crouch:
		move_dir -= 1
		
	if Input.is_action_pressed("move_right") && grounded && crouch:
		jump_dir = 1
		
	if Input.is_action_pressed("move_left") && grounded && crouch:
		jump_dir = -1

	if grounded:
		velocity = move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1))
	else:
		velocity = move_and_slide(Vector2(jump_dir * MOVE_SPEED, y_velo), Vector2(0, -1))

	y_velo += GRAVITY
	
	if grounded && Input.is_action_pressed("jump"):
		#longer hold = higher jumpPower
		jumpPower += delta
		#Stops the frog from moving after jump is pressed
		crouch = true
	if grounded && Input.is_action_just_released("jump"):
		#maximum jump multiplier, we can tweak this later
		if jumpPower > 1:
			jumpPower = 1
		y_velo = -JUMP_FORCE * (jumpPower + 1) #held jump will max out at 1.5 * original jump force
		jumping = true
		#reset multiplier after jump
		jumpPower = 0
		#Let the game know the player can move again
		crouch = false
	
	y_velo += GRAVITY * delta
	
	if jumping && grounded:
		jumping = false

	if grounded and y_velo >= 5:
		y_velo = 5
		jump_dir = 0
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
	
	if grounded:
		if facing_right and move_dir < 0:
			flip()
		if !facing_right and move_dir > 0:
			flip()

	if grounded:
		if move_dir == 0:
			play_anim("idle")
		else:
			play_anim("walk")
	else:
		play_anim("jump")

func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
	
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)

