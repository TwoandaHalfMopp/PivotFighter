extends RefCounted
## Simple wrapper around [AStar2D] class that stores points as string names.

# Type: Dictionary<StringName, int>
# Hint: <state name, point id>
var _point_id_by_node: Dictionary

# Type: Dictionary<int, StringName
# Hint: <point id, state name>
var _node_by_point_id: Dictionary

var _astar: _CustomAStar
var _astar_point_id := 0
var _travel_path: PackedStringArray
var _travel_index: int

# func_get_transition_cost: func(StringName, StringName) -> float
func _init(func_get_transition_cost: Callable) -> void:
	_astar = _CustomAStar.new(func_get_transition_cost, _get_node_from_id)

## Adds point to graph.
func add_point(state_name: StringName) -> void:
	_point_id_by_node[state_name] = _astar_point_id
	_node_by_point_id[_astar_point_id] = state_name
	_astar.add_point(_astar_point_id, Vector2.ZERO)
	_astar_point_id += 1

## Removes point from graph.
func remove_point(state_name: StringName) -> void:
	var point_id: int = _point_id_by_node[state_name]
	_astar.remove_point(point_id)
	_point_id_by_node.erase(state_name)
	_node_by_point_id.erase(point_id)

## Renames point on graph.
func rename_point(old_name: StringName, new_name: StringName) -> void:
	if _point_id_by_node.has(old_name) and not _point_id_by_node.has(new_name):
		var id: int = _point_id_by_node[old_name]
		
		_point_id_by_node.erase(old_name)
		_node_by_point_id.erase(id)

		_point_id_by_node[new_name] = id
		_node_by_point_id[id] = new_name

## Connects [kbd]from[/kbd] one point [kbd]to[/kbd] another point.
## [br]
## if [kbd]bidirectional[/kbd] is true then transitions are allowed in both directions.
func connect_points(from: StringName, to: StringName, bidirectional: bool) -> void:
	_astar.connect_points(_point_id_by_node[from], _point_id_by_node[to], bidirectional)

## Disconnects [kbd]from[/kbd] one point [kbd]to[/kbd] another point.
## [br]
## if [kbd]bidirectional[/kbd] is true then transitions are disconnected in both directions.
func disconnect_points(from: StringName, to: StringName, bidirectional: bool) -> void:
	_astar.disconnect_points(_point_id_by_node[from], _point_id_by_node[to], bidirectional)

## Determines the optimal travel path [kbd]from[/kbd] one point [kbd]to[/kbd] another point.
func compute_travel_path(from: StringName, to: StringName) -> PackedStringArray:
	var id_path := _astar.get_id_path(_point_id_by_node[from], _point_id_by_node[to])
	var path := PackedStringArray()

	for id in id_path:
		path.append(_node_by_point_id[id])
	
	_travel_index = 0
	_travel_path = path
	return path

## Returns the cached path of a previous computation.
func get_computed_travel_path() -> PackedStringArray:
	return _travel_path

## Clears the previously cached travel path.
func clear_travel_path() -> void:
	_travel_path = PackedStringArray()

## Returns [code]true[/code] if there is a next point to fetch using [member get_next_travel_node].
func has_next_travel_point() -> bool:
	return _travel_index < _travel_path.size()

## Returns the name of the next node on the calculated travel path.
func get_next_travel_point() -> StringName:
	if not has_next_travel_point():
		return ""
	var next_state := _travel_path[_travel_index]
	_travel_index += 1
	return next_state


func _get_node_from_id(id: int) -> StringName:
	return _node_by_point_id[id]


class _CustomAStar:
	extends AStar2D

	# Type: func(StringName, StringName) -> int
	var _func_get_transition_cost: Callable

	# Type: func(int) -> StringName
	var _func_get_node_from_id: Callable

	func _init(func_get_transition_cost: Callable, func_get_node_from_id: Callable) -> void:
		_func_get_transition_cost = func_get_transition_cost
		_func_get_node_from_id = func_get_node_from_id

	func _compute_cost(from_id: int, to_id: int) -> float:
		var from: StringName = _func_get_node_from_id.call(from_id)
		var to: StringName = _func_get_node_from_id.call(to_id)
		return _func_get_transition_cost.call(from, to)
