extends KinematicBody2D

const MOVE_SPEED = 600
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
var jump_dir = 0
var velocity = Vector2()
var up_direction = Vector2(0,0)
var timez = 0
var jumped = false
var area2 = false


func _physics_process(delta):
	area2 = Globals.area2
	
	#Change the frogs jumps for the second area
	if area2:
		var move_dir = 0
		var grounded = is_on_floor()

		#Change the move direction based on the key pressed
		if Input.is_action_pressed("move_right") && !crouch:
			move_dir += 1

		if Input.is_action_pressed("move_left") && !crouch:
			move_dir -= 1
		
		#Change the jump direction only if the frog is currently on the ground and crouching
		if Input.is_action_pressed("move_right") && grounded && crouch:
			jump_dir = 1
			
		if Input.is_action_pressed("move_left") && grounded && crouch:
			jump_dir = -1

		#If on the ground, use move direction to change velocity, if not in the air, use the jump direction so you can't move mid air
		#Reverse direction on wall collision if in the air
		if !grounded:
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				#bounce off the bottoms of platforms
				if is_on_ceiling():
					y_velo *= -1 #this could be tweaked to bounce slower/faster
				#for all other collisions flip jump_dir
				else:
					if jump_dir == -1 or collision.collider.name == "LeftWall": #weird LeftWall bug fix
						jump_dir = 1
					else: 
						jump_dir = -1	
			velocity = move_and_slide(Vector2(jump_dir * MOVE_SPEED, y_velo), Vector2(0, -1))	
		else:
			velocity = move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1))
		
		
		#Adds gravity to y velocity before the frog jumps
		y_velo += GRAVITY
		
		if grounded && Input.is_action_pressed("jump"):
			#incrementing the variable to play the sound at given time
			timez = timez + .025
			#playing the sound at the incremented variable time
			$JumpSound3.play(timez)
			#longer hold = higher jumpPower
			jumpPower += delta
			#Stops the frog from moving after jump is pressed
			crouch = true
		if grounded && Input.is_action_just_released("jump"):
			jumped = true
			#Ending the charge sound when released
			$JumpSound3.seek(100)
			#setting the time of the charge sound back to 0
			timez = 0
			#play the jump sound
			$JumpSound.play()
			if jumpPower > 1:
				jumpPower = 1
			y_velo = -JUMP_FORCE * (jumpPower + 1) #held jump will max out at 1.5 * original jump force
			jumping = true
			#reset multiplier after jump
			jumpPower = 0
			#Let the game know the player can move again
			crouch = false
		
		#Change y velocity of frog
		y_velo += GRAVITY * delta
		
		#Set jumping back to false when the frog hits the ground
		if jumping && grounded:
			jumping = false

		#Set the y velocity to 5 when frog lands on the ground, reset jump direction when it lands so it can turn again
		if grounded and y_velo >= 5:
			y_velo = 5
			jump_dir = 0
			
		#Set a max fall speed for the frog if the y velocity would get too high
		if y_velo > MAX_FALL_SPEED:
			y_velo = MAX_FALL_SPEED
		
		#Flip the frog's sprite animation when moving left and right
		if grounded:
			if facing_right and move_dir < 0:
				flip()
			if !facing_right and move_dir > 0:
				flip()

		#Set the animation for the frog based on it's move direction and grounded state
		if grounded:
			if move_dir == 0 && !crouch:
				play_anim("idle")
			elif crouch == true:
				play_anim("crouch")
			else:
				if facing_right:
					play_anim("rWalk")
				else:
					play_anim("lWalk")
		elif !grounded && jump_dir == 0:
			play_anim("idleJump")
		elif !grounded && jump_dir == 1:
			play_anim("rJump")
		else:
			play_anim("lJump")
			
	#If the frog is not in the second area, use original physics
	else:		
		var move_dir = 0
		var jump_dir = 0
		var grounded = is_on_floor()

		#Change the move direction based on the key pressed
		if Input.is_action_pressed("move_right") && !crouch:
			move_dir += 1
		if Input.is_action_pressed("move_left") && !crouch:
			move_dir -=1
		
		#Use move direction to set velocity of the frog	
		move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1))
		
		#Adds gravity to y velocity before the frog jumps
		y_velo += GRAVITY
		
		if grounded && Input.is_action_pressed("jump"):
			#incrementing the variable to play the sound at given time
			timez = timez + .025
			#playing the sound at the incremented variable time
			$JumpSound3.play(timez)
			#longer hold = higher jumpPower
			jumpPower += delta
			
			#Stops the frog from moving after jump is pressed
			crouch = true
		if grounded && Input.is_action_just_released("jump"):
			#Ending the charge sound when released
			$JumpSound3.seek(100)
			#setting the time of the charge sound back to 0
			timez = 0
			#play the jump sound
			$JumpSound.play()
			#maximum jump multiplier, we can tweak this later
			jumped = true
			if jumpPower > 0.5:
				jumpPower = 0.5
			y_velo = -JUMP_FORCE * (jumpPower + 1) #held jump will max out at 1.5 * original jump force
			jumping = true
			#reset multiplier after jump
			jumpPower = 0
			#Let the game know the player can move again
			crouch = false
		
		#Change y velocity of frog
		y_velo += GRAVITY * delta
		
		#Set jumping back to false when the frog hits the ground
		if jumping && grounded:
			jumping = false
		
		#Set the y velocity to 5 when frog lands on the ground, reset jump direction when it lands so it can turn again
		if grounded and y_velo >= 5:
			y_velo = 5
		if y_velo > MAX_FALL_SPEED:
			y_velo = MAX_FALL_SPEED
		
		#Flip the frog's sprite animation when moving left and right
		if facing_right and move_dir < 0:
			flip()
		if !facing_right and move_dir > 0:
			flip()

		#Set the animation for the frog based on it's move direction and grounded state
		if grounded:
			if jumped:
				$JumpSound.play()
				jumped = false
			if move_dir == 0 && !crouch:
				play_anim("idle")
			elif crouch:
				play_anim("crouch")
			else:
				if facing_right:
					play_anim("rWalk")
				else:
					play_anim("lWalk")
		if move_dir == 0 && !grounded:
			play_anim("idleJump")
		elif facing_right && !grounded:
			play_anim("rJump")
		elif !facing_right && !grounded:
			play_anim("lJump")

#Flips frog's sprite so he looks left or right
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

#Play an animation is it's not already playing
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)

#Sets the global variable area2 to false at the start of the game
func _on_World_ready():
	Globals.area2 = false
	Globals.area2Prompt = false
	
#Sets the area2 variable to false when touching the Area1Flag
func _on_Area1Flag_body_entered(body):
	Globals.area2 = false
	Globals.area2Prompt = false

#Sets a flag if the frog reaches the second area
func _on_Area2Flag_body_entered(body):
	Globals.area2 = true
	Globals.area2Prompt = true

#Sets a flag if the frog reaches the end of the game and changes to the end screen
func _on_EndFlag_body_entered(body):
	Globals.gameOver = true
	Globals.area2 = false
	get_tree().change_scene("res://EndScreen.tscn")

#Hides the area 2 prompt once reaching the collider
func _on_PromptFlag_body_entered(body):
	Globals.area2Prompt = false
