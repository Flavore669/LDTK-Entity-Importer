# Flexible LDTK Entity Post-Importer (Godot Plugin)

Enhances [LDTK Importer](https://github.com/heygleeson/godot-ldtk-importer) functionality with better entity processing.

## Key Features

- **Scene Auto-Instantiation**: Creates scenes based on LDTK entity identifiers
- **Runtime Configuration**: Applies LDTK field values to entity properties
- **Multi-Type Support**: Handles various data types
- **Debug Tools**: Troubleshooting mode included

## Installation Guide

1. Place `EntityImporter.gd` in `res://addons/`
2. Set up `EntityDict.tscn` as an autoload

## Usage Notes

⚠ **Important**: Script variables must match LDTK field names (case-insensitive)

### Scene Configuration
Map your entities in `EntityDict.tscn` using:  
`LDTKEntityName : YourPackedSceneReference`

### Import Methods

**Automatic Mode** *(Simplest workflow)*  
✔️ Zero configuration needed  
✖️ Limited in-editor adjustments

**Manual Mode** *(Maximum control)*  
✔️ Full placement/property control  
✔️ Easier level fine-tuning  

### Implementation

**Automatic Setup:**
1. Attach import script via inspector's import tab

**Manual Setup:**
1. Add `EntityImporter` node to inherited `LDTKLevel`
2. Assign `entity_layer` to your `LDTKEntityLayer` in inspector
