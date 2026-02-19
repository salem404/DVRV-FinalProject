extends Node

var character: CharacterBody2D

func moveTo(movement: Vector2, speed: Vector2):
	if movement != Vector2.ZERO:
		character.isMoving = true
		character.moveXTo(movement.x * speed.x)
		if character.onFloor:
			character.moveYTo(movement.y * speed.y)
	else: 
		character.isMoving = false

func jump(jPower: float):
	if character.onFloor:
		character.onFloor = false
		character.moveYTo(0)
		character.applyForce(Vector2(0, jPower))
