extends MarginContainer

@onready var HpBar: TextureProgressBar = $PanelContainer/VBoxContainer/HealthBar
@onready var ManaBar: TextureProgressBar = $PanelContainer/VBoxContainer/ManaBar

var playerStats: Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerStats:
		HpBar.max_value = playerStats.MaxHealth
		HpBar.value = playerStats.Health
		ManaBar.max_value = playerStats.MaxMagic
		ManaBar.value = playerStats.Magic
