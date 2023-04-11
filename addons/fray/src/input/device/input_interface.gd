class_name FrayInputInterface
extends RefCounted
## Helper class for composite inputs to safely interface with the FrayInput singleton.
##
## Used to fetch the state of certain data in the fray input singleton.


var _fray_input: WeakRef

func _init(fray_input_ref: WeakRef) -> void:
	_fray_input = fray_input_ref

## Returns the bind state of a given [kbd]bind[/kbd].
func get_bind_state(bind: StringName, device: int) -> FrayInputState:
	return _fray_input.get_ref()._get_bind_state(bind, device)

## Returns the value of a condition in this node if it exists.
func is_condition_true(condition: StringName, device: int) -> bool:
	return _fray_input.get_ref().is_condition_true(condition, device)
