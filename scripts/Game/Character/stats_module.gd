extends Node
@export_category("Values")
@export var MaxHealth: float = 100
@export var Health: float = 100
@export var MaxMagic: float = 100
@export var Magic: float = 100
@export var Speed: Vector2 = Vector2(300,200)

@export_category("Extras")
@export var dmgBoost: float = 0
@export var DefBoost: float = 0
@export var SpeedBoost: float = 0

@export_category("Others")
@export var ignoresKnockback: bool = false
@export var ignoresStun: bool = false ## Turn IgnoreKnockbackWithIt
@export var Jpower: float = 20
@export var gravity: float = 1
