extends Area2D

signal Activated()

var active: bool = true

func _on_body_entered(body):
	if active and body.is_in_group("Player"):
		Activated.emit()
		active = false
