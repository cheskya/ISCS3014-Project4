extends CharacterBody2D

@onready var game = $".."
@onready var ui_node = $"../UI"
@onready var health_label = $HealthLabel

signal move_done
signal move_wait

var is_defending : bool = false
var is_skipped : bool = false

var actions = {
	"Attack": {
		"Bonk": {
			"Damage": 2,
			"Target": 1,
		},
	},
	"Skill": {
		"Lightning": {
			"Damage": 8,
			"Target": 1,
			"Uses": 2,
			"Roll": 0.8,
		},
		"Acid": {
			"Damage": 3,
			"Target": 1,
			"Uses": 3,
		},
	}
}

var health = 20


func _ready():
	ui_node.move_received.connect(player_move)
	self.move_wait.connect(action)
	add_to_group("player")
	health_label.text = str(health)


func player_move(name, data, target):
	if self == data:
		game.accept_move = false
		ui_node.disable_menu()
		game.player_moves.append([self.name, name, target])
		if name == "Defend":
			is_defending = true
		if name == "Acid":
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if enemy != null and enemy.name == target:
					enemy.has_acid = 0
		emit_signal("move_wait")


func action() -> void:
	await self.move_wait
	await get_tree().create_timer(1.0).timeout
	emit_signal("move_done")


func get_attacks():
	return actions["Attack"]


func get_skills():
	return actions["Skill"]


func get_attack_info(attack: String):
	return actions["Attack"][attack]


func get_skill_info(skill: String):
	return actions["Skill"][skill]


func get_action_info(action: String):
	var action_info
	if action in actions["Attack"]:
		action_info = get_attack_info(action)
	elif action in actions["Skill"]:
		action_info = get_skill_info(action)
	else:
		action_info = null
	return action_info


func deplete_health(amt: int):
	health -= amt
	health_label.text = str(health)
