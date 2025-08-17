@tool

func post_import(level: LDTKLevel) -> LDTKLevel:
	var entity_importer : EntityImporter = EntityImporter.new()
	level.add_child(entity_importer)
	entity_importer.name = "EntityImporter"
	var entity_layer : LDTKEntityLayer = level.get_node_or_null("Entities")
	
	if entity_layer:
		entity_importer.entity_layer = entity_layer
	else:
		print("Error: No Entity Layer Found in Scene Tree")
	
	return level
