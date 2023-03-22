extends CharacterBody3D

const FORWARDSPEED = 4.0
const BACKSPEED = 5.0
const PREJUMP = 4
const JUMPSTRENGTH = 10.0

var TIMER = 0

var INPUTSTATE
var PREV_INPUTSTATE

var MOVEMENTSTATE = "TEST"
var ATTACKSTATE = "IDLE"

var PREV_MOVEMENTSTATE = "IDLE"
var PREV_ATTACKSTATE = "IDLE"

func boolToBinary(bool):
	match bool:
		true:
			return 1
		false:
			return 0
	
func intToLetter(int,capital,lowercase):
	match int:
		1:
			return lowercase
		2:
			return capital
		0:
			return ""

func _physics_process(delta):
	PREV_INPUTSTATE = INPUTSTATE
	PREV_MOVEMENTSTATE = MOVEMENTSTATE
	
	INPUTSTATE = [
		Input.get_axis("input_left","input_right"),
		Input.get_axis("input_down","input_up"),
		boolToBinary(Input.is_action_just_pressed("input_attack_a")) + boolToBinary(Input.is_action_pressed("input_attack_a")),
		boolToBinary(Input.is_action_just_pressed("input_attack_b")) + boolToBinary(Input.is_action_pressed("input_attack_b")),
		boolToBinary(Input.is_action_just_pressed("input_attack_c")) + boolToBinary(Input.is_action_pressed("input_attack_c")),
		boolToBinary(Input.is_action_just_pressed("input_attack_d")) + boolToBinary(Input.is_action_pressed("input_attack_d"))
	]
	match [Input.is_action_pressed("input_down"),Input.is_action_pressed("input_up")]:
		[true,true]: INPUTSTATE[1] = 1
		_: pass

	var INPUTDEBUG = str(5 + (INPUTSTATE[1] * 3) + INPUTSTATE[0])
	var ATTACKDEBUG = str(
		intToLetter(INPUTSTATE[2],"A","a"),
		intToLetter(INPUTSTATE[3],"B","b"),
		intToLetter(INPUTSTATE[4],"C","c"),
		intToLetter(INPUTSTATE[5],"D","d"),
	)

	$DebugLabel.text = str(INPUTDEBUG," ",ATTACKDEBUG,"\n",INPUTSTATE,"\n",velocity.x)
	
	
	match INPUTSTATE[1]:
		1.0:
				MOVEMENTSTATE = "JUMPSQUAT"
				velocity.x = move_toward(velocity.x,0,1)
		-1.0:
			MOVEMENTSTATE = "CROUCH"
			velocity.x = move_toward(velocity.x,0,1)
		0.0:
			match INPUTSTATE[0]:
				0.0: 
					MOVEMENTSTATE =  "IDLE"
					velocity.x = move_toward(velocity.x,0,1)
				-1.0: 
					MOVEMENTSTATE = "MOVE_BACKWARDS"
					velocity.x = move_toward(velocity.x, INPUTSTATE[0] * BACKSPEED, 1)
				1.0: 
					MOVEMENTSTATE = "MOVE_FORWARDS"
					velocity.x = move_toward(velocity.x, INPUTSTATE[0] * FORWARDSPEED, 1)
			if abs(velocity.x) < 0.1:
				velocity.x = 0
	
	if MOVEMENTSTATE == PREV_MOVEMENTSTATE:
		TIMER += 1
	else:
		TIMER = 0
	move_and_slide()
	$StateLabel.text = str(MOVEMENTSTATE,"\n",ATTACKSTATE,"\n",TIMER)
	
	
	
	
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= GRAVITY * delta
#
#	# Handle Jump.
#	if Input.is_action_pressed("input_up") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var input_dir = Input.get_axis("input_left", "input_right")
#	if input_dir:
#		velocity.x = move_toward(velocity.x, input_dir * SPEED, FRICTION)
#	else:
#		velocity.x = move_toward(velocity.x, 0, FRICTION)
#
#	move_and_slide()
