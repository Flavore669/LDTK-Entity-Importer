# Flexible LDTK Entity Post-Importer (Godot Plugin)

Enhances [LDTK Importer](https://github.com/heygleeson/godot-ldtk-importer) functionality with better entity processing.

## Key Features

- **Scene Auto-Instantiation**: Creates scenes based on LDTK entity identifiers
- **Runtime Configuration**: Applies LDTK field values to entity properties
- **Multi-Type Support**: Handles various data types
- **Debug Tools**: Troubleshooting mode included

## Installation

1. Download the latest release from the `releases` tab
2. Extract the contents into your `res://addons/` directory
3. Enable the plugin in Godot's `Project → Plugins` tab

## Usage

⚠ **Important**: Script variable names must match LDTK field names (case-insensitive)

### Scene Configuration

Map your LDTK entities to Godot scenes in `EntityDict.tscn` using the format:
`LDTKEntityName : YourPackedSceneReference`

### Import Methods

**Automatic Mode** *(Simplest workflow)*  
✅ Zero configuration required  
✅ Automatic scene instantiation and configuration  
❌ Limited in-editor adjustments

**Manual Mode** *(Maximum control / Fast Prototyping)*  
✅ Full control over placement and properties  
✅ Easier level fine-tuning and customization

### Automatic Setup

1. **Create Entity Dictionary**: Create an `EntityDictionary` resource (`.tres` file) to map your LDTK entity identifiers to Godot scenes
2. **Configure Import Script**: Add the following post-import script to your LDTK import settings
3. **Update Resource Reference**: Replace the `EXAMPLE` constant with the path to your saved `EntityDictionary` resource

```gdscript
@tool
# Replace with your actual EntityDictionary resource path
const ENTITY_DICT = preload("res://path/to/your/entity_dictionary.tres")

func post_import(level: LDTKLevel) -> LDTKLevel:
    var entity_importer : EntityImporter = EntityImporter.new()
    level.add_child(entity_importer)
    entity_importer.name = "EntityImporter"
    var entity_layer : LDTKEntityLayer = level.get_node_or_null("Entities")
    
    if entity_layer:
        entity_importer.entity_dict = ENTITY_DICT
        entity_importer.import(entity_layer)
    else:
        print("Error: No Entity Layer Found in Scene Tree")
    
    return level
```

**Manual Setup:**
1. **Add Importer Node**: Add an `EntityImporter` node to your inherited LDTK level scene
2. **Create Entity Mapping**: Create and configure an `EntityDictionary` resource in the inspector to map LDTK entities to your Godot scenes
3. **Connect Entity Layer**: Assign your level's `LDTKEntityLayer` node to the importer's `entity_layer` property in the inspector

### **Compatibility Notes**

**Tested & Supported:**
- All native Godot types (int, float, string, bool, Vec2, etc)
- Enums and enumeration values  
- Entity references and relationships
- Arrays of the above supported types

**Currently Untested:**
- Color type fields
- FilePath type fields  
- Tile type fields

### **Feedback & Support**

Please report any bugs or suggest new features through the plugin's GitHub repository.
