extends CharacterBody3D
const Speed = 5
const Gravity = 20
const JumpForce = 8

var MaxHealth = 150
var CurrentHealth = MaxHealth


var InputLeft = 0
var InputRight = 0
var InputUp = 0
var InputDown = 0
var InputStartAttackA = 0
var InputStartAttackB = 0
var InputStartAttackC = 0
var InputStartAttackD = 0
var InputStopAttackA = 0
var InputStopAttackB = 0
var InputStopAttackC = 0
var InputStopAttackD = 0

func _physics_process(delta):
	updateInputs()
	
	if not is_on_floor():
		velocity.y -= Gravity * delta
		
	if Input.is_action_just_pressed("input_up") and is_on_floor():
		velocity.y = JumpForce
	
	var InputDir = getInputDir()
	velocity.x = move_toward(velocity.x, InputDir * Speed,1)
	move_and_slide()
	
	if InputStartAttackA:
		print("Attack A pressed")
	
	if InputStartAttackB:
		print("Attack B pressed")
	
	if InputStartAttackC:
		print("Attack C pressed")
	
	if InputStartAttackD:
		print("Attack D pressed")
		takeDamage(1)


func updateInputs():
	InputLeft = Input.is_action_pressed("input_left")
	InputRight = Input.is_action_pressed("input_right")
	InputUp = Input.is_action_pressed("input_up")
	InputDown = Input.is_action_pressed("input_down")
	InputStartAttackA = Input.is_action_just_pressed("input_attack_a")
	InputStartAttackB = Input.is_action_just_pressed("input_attack_b")
	InputStartAttackC = Input.is_action_just_pressed("input_attack_c")
	InputStartAttackD = Input.is_action_just_pressed("input_attack_d")
	InputStopAttackA = Input.is_action_just_released("input_attack_a")
	InputStopAttackB = Input.is_action_just_released("input_attack_b")
	InputStopAttackC = Input.is_action_just_released("input_attack_c")
	InputStopAttackD = Input.is_action_just_released("input_attack_d")

func getInputDir():
	match [InputLeft,InputRight]:
		[false,false]: return 0
		[true, false]: return -1
		[false, true]: return 1
		[true, true]: return 0

func takeDamage(damageAmount):
	print("Taking " + str(damageAmount) + " damage")
	CurrentHealth = move_toward(CurrentHealth,0,damageAmount)
