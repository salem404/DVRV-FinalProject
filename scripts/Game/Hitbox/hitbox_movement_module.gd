extends Node

@export var intMovementDir: Vector3
@export var AccelerationDir: Vector3
@export var intHeight: float
@export var deathHeight: float

@onready var proyectile: Area2D = get_parent()

var velocity: Vector3 = Vector3.ZERO
var height: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += AccelerationDir
	proyectile.position += Vector2(velocity.x,-velocity.y+velocity.z)
	height += velocity.y
	
	if height < 0:
		proyectile.queue_free()

func _on_initialized():
	velocity = intMovementDir
	height = intHeight
