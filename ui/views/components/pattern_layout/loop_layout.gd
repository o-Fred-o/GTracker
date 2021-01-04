extends VBoxContainer

var texture


func _ready() -> void:
	texture = load("res://ui/icons/baseline_loop_white_18dp.png")


func _on_LoopPattern1_button_down() -> void:
	activate_loop(1)


func _on_LoopPattern2_button_down() -> void:
	activate_loop(2)


func _on_LoopPattern3_button_down() -> void:
	activate_loop(3)
	

func _on_LoopPattern4_button_down():
	activate_loop(4)


func activate_loop(pattern) -> void:
	desactivate_loop(Global.active_loop)
	if (pattern == Global.active_loop):
		Global.active_loop=0
		return
		
	var button = find_node("LoopPattern"+String(pattern))
	button.icon = texture
	button.text = ""
	Global.active_loop = pattern
	# reinit le temps
	Global.time_init()
	

func desactivate_loop(pattern):
	if (pattern == 0):
		return
		
	var button = find_node("LoopPattern"+String(pattern))
	button.icon = null
	button.text = String(pattern)
	# reinit le temps
	Global.time_init()
