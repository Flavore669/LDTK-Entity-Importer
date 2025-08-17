extends LDTKLevel

@onready var entity_importer: EntityImporter = $"@Node2D@24030"

func _ready() -> void:
	print(entity_importer.scene_mappings)
