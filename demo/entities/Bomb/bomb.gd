extends Area2D
class_name Bomb

enum BombType {FIRE, ELECTRIC, ICE}

@export var damage_type: BombType = BombType.FIRE
@export var damage_amount: int = 1

func _ready():
	print("Trap type: ", BombType.keys()[damage_type])
	print("Damage: ", damage_amount)
