extends Area2D

export(String, FILE, "*.tscn") var target_level_path = ""

func _on_MiniGameDoor_body_entered(body):
	if not body is Player: return
	if target_level_path.empty(): return
	get_tree().change_scene(target_level_path)
	
