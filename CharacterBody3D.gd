extends CharacterBody3D

const SPEED = 5
const JUMPVEL = 8.5
const GROUNDCONTROL = 100.0
const AIRCONTROL = 5.0
const GRAVITY = 20

const MaxHealth = 150
var CurrentHealth = 150

const MaxMeter = 300
const CurrentMeter = 0

@onready var combat_state_machine: FrayCombatStateMachine = $FrayCombatStateMachine


func _process(delta):
	FrayInputMap.add_bind_action("left","input_left")
	FrayInputMap.add_bind_action("right","input_right")
	FrayInputMap.add_bind_action("up","input_up")
	FrayInputMap.add_bind_action("down","input_down")
	
	FrayInputMap.add_bind_action("attackA","input_attack_a")
	FrayInputMap.add_bind_action("attackB","input_attack_b")
	FrayInputMap.add_bind_action("attackC","input_attack_c")
	FrayInputMap.add_bind_action("attackD","input_attack_d")
	
	FrayInputMap.add_composite_input("ThrowMacro",FrayCombinationInput.builder()
	.add_component(FraySimpleInput.from_bind("attackA"))
	.add_component(FraySimpleInput.from_bind("attackB"))
	.mode_sync()
	.build()
	)
	
	FrayInputMap.add_composite_input("DashMacro",FrayCombinationInput.builder()
	.add_component(FraySimpleInput.from_bind("attackC"))
	.add_component(FraySimpleInput.from_bind("attackD"))
	.mode_sync()
	.build()
	)
	
	combat_state_machine.add_situation("on_ground", FrayRootState.builder()
	.transition_button("groundMovement","attack_A", {input="attackA"})
	.transition_button("groundMovement","jumpSquat", {input="jump"})
	.start_at("groundMovement")
	.build()
	)
