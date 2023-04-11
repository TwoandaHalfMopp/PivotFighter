extends Object

const _interfaces = {
	"IHitbox" : {
		"methods" : ["activate", "deactivate", "set_source"],
		"signals" : ["hitbox_entered", "hitbox_exited"],
	},
}

func _init() -> void:
	assert(false, "Thiss class only provides pseudo-interface membership test and is not intended to be instantiated")
	free()


static func implements(obj: Object, interface: String) -> bool:
	if not _interfaces.has(interface):
		push_error("Failed to check interface. Interface '%s' is not defined." % interface)
		return false 
	
	return _get_missing_members(obj, interface).is_empty()


static func assert_implements(obj: Object, interface: String) -> void:
	var script_name: String = obj.get_script().resource_path.get_file()
	var has_implementation := implements(obj, interface)

	if not has_implementation:
		for missing_member in _get_missing_members(obj, interface):
			push_error(missing_member)

	assert(has_implementation, "Script '%s' does not implement interface '%s'" % [script_name, interface])

	
static func _get_missing_members(obj: Object, interface: String) -> PackedStringArray:
	var script_name: String = obj.get_script().resource_path.get_file()
	var missing_members: PackedStringArray = []

	for method in _interfaces[interface]["methods"]:
		if not obj.has_method(method):
			missing_members.append("'%s' does not implement interface method '%s.%s'" % [script_name, interface, method])

	for sig in _interfaces[interface]["signals"]:
		if not obj.has_signal(sig):
			missing_members.append("'%s' does not implement interface signal '%s.%s'" % [script_name, interface, sig])
	
	return missing_members
