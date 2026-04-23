extends Node

@export var this: Area2D = get_parent()
@onready var imaginaryHitbox: Sprite2D = $ImaginaryHitbox
@onready var defaultSize: Vector2 = imaginaryHitbox.scale

# Called when the node enters the scene tree for the first time.
	
func _on_initialized():
	if not this: this = get_parent()
	var realHitbox = this.get_node("CollisionShape2D")
	var radio = realHitbox.shape.radius
	imaginaryHitbox.global_position.y -= this.get_node("HitboxModule").height
