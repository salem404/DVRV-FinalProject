extends Node

@onready var playerModule: Node = get_parent()

func takeDamage(damage: int, stundur: float, knockback: Vector3):
	playerModule.StatsModule.Health -= damage
	playerModule.StatusModule.applyStun(stundur)
	applyKnockback(knockback)

func applyKnockback(knockback: Vector3):
	if playerModule.StatsModule and not playerModule.StatsModule.ignoresKnockback:
		playerModule.MovementModule.moveTo(Vector2.ZERO)
		playerModule.MovementModule.applyForce(Vector2(knockback.x, knockback.z), knockback.y)
