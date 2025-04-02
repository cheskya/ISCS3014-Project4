extends CanvasLayer

@onready var action_list = $PanelContainer/MarginContainer/ActionList
@onready var attack_list = $PanelContainer/MarginContainer/AttackList
@onready var skills_list = $PanelContainer/MarginContainer/SkillsList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_action_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select attack menu
		action_list.hide()
		if (attack_list.is_anything_selected() == true):
			attack_list.deselect_all()
		attack_list.show()
	elif (index == 1): # select skills menu
		action_list.hide()
		if (skills_list.is_anything_selected() == true):
			skills_list.deselect_all()
		skills_list.show()


func _on_attack_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		attack_list.hide()
		if (action_list.is_anything_selected() == true):
			action_list.deselect_all()
		action_list.show()


func _on_skills_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		skills_list.hide()
		if (action_list.is_anything_selected() == true):
			action_list.deselect_all()
		action_list.show()
