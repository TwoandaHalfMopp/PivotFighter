@tool
class_name FrayCombinationInput
extends FrayCompositeInput
## A composite input used to create combination inputs
##
## A combination will be considered as press when
## all components are pressed according to the mode.

enum Mode {
	SYNC, ## Components must all be pressed at the same time.
	ASYNC, ## Components can be pressed at any time so long as they are all pressed.
	ORDERED, ## Like asynchronous but the presses must occur in order.
}

## Determines press condition necessary to trigger combination
var mode: Mode = Mode.SYNC

func _is_pressed_impl(device: int, input_interface: FrayInputInterface) -> bool:
	match mode:
		Mode.SYNC: 
			return _is_combination_quick_enough(device, input_interface)
		Mode.ASYNC: 
			return _is_all_components_pressed(device, input_interface)
		Mode.ORDERED: 
			return _is_combination_in_order(device, input_interface)
		_:
			push_error("Failed to check combination. Unknown mode '%d'" % mode)

	return false


func _decompose_impl(device: int, input_interface: FrayInputInterface) -> Array[StringName]:
	# Returns all components decomposed and joined
	var binds: Array[StringName]
	for component in _components:
		binds.append_array(component.decompose(device, input_interface))
	return binds

## Returns a builder instance
static func builder() -> Builder:
	return Builder.new()

# Returns: InputState[]
func _get_decomposed_states(device: int, input_interface: FrayInputInterface) -> Array:
	var decomposed_states := []
	for bind in decompose(device, input_interface):
		decomposed_states.append(input_interface.get_bind_state(bind, device))
	return decomposed_states


func _is_all_components_pressed(device: int, input_interface: FrayInputInterface) -> bool:
	for component in _components:
		if not component.is_pressed(device, input_interface):
			return false
	return true


func _is_combination_quick_enough(device: int, input_interface: FrayInputInterface, tolerance: float = 10) -> bool:
	var decomposed_states := _get_decomposed_states(device, input_interface)
	var avg_difference := 0

	for i in len(decomposed_states):
		if i > 0:
			var input1: FrayInputState = decomposed_states[i]
			var input2: FrayInputState = decomposed_states[i - 1]

			if not input1.is_pressed or not input2.is_pressed:
				return false

			avg_difference += abs(input1.time_pressed - input2.time_pressed)

	avg_difference /= float(decomposed_states.size())
	return avg_difference <= tolerance


func _is_combination_in_order(device: int, input_interface: FrayInputInterface, tolerance: float = 10) -> bool:
	var decomposed_states := _get_decomposed_states(device, input_interface)

	for i in len(decomposed_states):
		if i > 0:
			var input1: FrayInputState = decomposed_states[i]
			var input2: FrayInputState = decomposed_states[i - 1]

			if not input1.is_pressed or not input2.is_pressed:
				return false

			if input2.time_pressed - tolerance > input1.time_pressed:
				return false

	return true


class Builder:
	extends RefCounted

	var _composite_input = FrayCombinationInput.new()

	## Builds the composite input
	##
	## Returns a reference to the newly built CompositeInput
	func build() -> FrayCombinationInput:
		return _composite_input

	## Adds a composite input as a component of this combination
	##
	## Returns a reference to this ComponentBuilder
	func add_component(composite_input: FrayCompositeInput) -> Builder:
		_composite_input.add_component(composite_input)
		return self

	## Sets whether the input will be virtual or not
	##
	## Returns a reference to this ComponentBuilder
	func is_virtual(value: bool = true) -> Builder:
		_composite_input.is_virtual = value
		return self

	## Sets the composite input's process priority. Higher priority composites are processed first.
	##
	## Returns a reference to this ComponentBuilder
	func priority(value: int) -> Builder:
		_composite_input.priority = value
		return self

	## Sets the combination to async mode
	func mode_async() -> Builder:
		_composite_input.mode = FrayCombinationInput.Mode.ASYNC
		return self
		
	## Sets the combination to sync mode
	func mode_sync() -> Builder:
		_composite_input.mode = FrayCombinationInput.Mode.SYNC
		return self
		
	## Sets the combination to ordered mode
	func mode_ordered() -> Builder:
		_composite_input.mode = FrayCombinationInput.Mode.ORDERED
		return self
