extends Node

@export var node: Node = get_parent()
@export_category("Values")
@export var lifeTime: float = -2

func _on_initialized():
	await get_tree().create_timer(0.1).timeout
	if lifeTime >= 0:
		await get_tree().create_timer(lifeTime).timeout 
		node.queue_free()
