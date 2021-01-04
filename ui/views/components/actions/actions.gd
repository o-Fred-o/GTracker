extends Control

func _on_Play_button_down() -> void :
	Global.time_init()
	Global.play=!Global.play

func _on_Pause_button_down() -> void :
	Global.play=!Global.play
