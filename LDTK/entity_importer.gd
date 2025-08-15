## Flexible Entity Post-Import Template for LDTK-Importer
@tool
extends Node2D
class_name EntityImporter

# Configuration
@export var entity_layer: LDTKEntityLayer: set = _set_entity_layer
@export var scene_mappings: Dictionary[String, PackedScene] = EntityDict.scene_mappings #ldtk_name: PackedScene

# Runtime
var _instance_references: Dictionary[String, Node] = {}	# iid -> Node

func _set_entity_layer(value: LDTKEntityLayer) -> void:
	entity_layer = value
	if Engine.is_editor_hint() and entity_layer != null:
		_post_import(entity_layer)

func _post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	_clear_import_data()
	
	# First pass: Create all instances
	for entity in entity_layer.entities:
		if not entity is Dictionary:
			continue
			
		_process_entity(entity)
	
	# Second pass: Configure relationships
	for entity in entity_layer.entities:
		if not entity is Dictionary:
			continue
			
		_configure_entity(entity)
	
	return entity_layer

func _clear_import_data() -> void:
	_instance_references.clear()
	
	# Clear existing children
	for child in get_children():
		child.queue_free()

func _process_entity(entity: Dictionary) -> void:
	var identifier : String = entity["identifier"]
	var scene : PackedScene = scene_mappings[identifier]
	
	if not scene:
		push_warning("Missing scene mapping for: ", identifier)
		return
	
	var instance : Node = scene.instantiate()
	if not instance:
		return
		
	instance.global_position = entity["position"]
	instance.name = identifier
	add_child(instance)
	instance.set_owner(get_tree().edited_scene_root)
	
	_instance_references[entity["iid"]] = instance

func _configure_entity(entity: Dictionary) -> void:
	var iid = entity["iid"]
	var instance = _instance_references[iid]
	if not instance:
		return
	
	var fields = entity["fields"]
	
	# Generic configuration based on node type
	_auto_configure_node(instance, fields)

func _parse_enum_value(enum_string: String, node: Node) -> Variant:
	if not "." in enum_string:
		return null
		
	var parts = enum_string.split(".")
	if parts.size() != 2:
		return null
		
	var enum_dict_name = parts[0]  # EX. "MyEnum" 
	var value_name = parts[1]     # EX. "FIRST"
	
	# Try to get the enum dictionary from the node
	var enum_dict = node.get(enum_dict_name)
	if not enum_dict is Dictionary:
		return null
		
	# Return the specific enum value if found
	return enum_dict.get(value_name)

func _auto_configure_node(node: Node, fields: Dictionary) -> void:
	for field_name in fields:
		var value = fields[field_name]
		if value == null:
			continue
		
		if node.has_property(field_name):
			# Handle enum strings (Strings that represent enums) (EX. MyEnum.FIRST is an enum string)
			if typeof(value) == TYPE_STRING and "." in value:
				var enum_value = _parse_enum_value(value, node)
				if enum_value != null:
					node.set(field_name, enum_value)
			
			
			# Else Handle singular node paths by finding entities with their iids
			elif typeof(node.get(field_name)) == TYPE_NODE_PATH:
				var node_ref = get_entity_by_iid(value)
				if node_ref:
					node.set(field_name, node.get_path_to(node_ref))
			
			# Else Handle Arrays of Nodepaths by finding entities with their iids
			elif typeof(value) == TYPE_ARRAY:
				if value.size() > 0:
					var first_element_type = typeof(value[0])
					
					# Detect IID references
					if first_element_type is NodePath:
						var node_paths: Array[NodePath] = []
						for iid in value:
							var ref_node = get_entity_by_iid(iid)
							if ref_node:
								node_paths.append(node.get_path_to(ref_node))
						node.set(field_name, node_paths)
			
			# Handle regular values
			else:
				node.set(field_name, value)

func get_entity_by_iid(iid: String) -> Node:
	return _instance_references.get(iid)
