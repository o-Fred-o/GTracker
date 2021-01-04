extends Control

signal tick_change

var prev_tick = 0
	
func _ready():
#	var err
	# se connecter a chaque piste 
	connect("tick_change", $VBoxMain/HBoxMain/PanelMain/VBoxContainer/Track1, "_on_tick_change")
	connect("tick_change", $VBoxMain/HBoxMain/PanelMain/VBoxContainer/Track2, "_on_tick_change")
	connect("tick_change", $VBoxMain/HBoxMain/PanelMain/VBoxContainer/Track3, "_on_tick_change")
	connect("tick_change", $VBoxMain/HBoxMain/PanelMain/VBoxContainer/Rythm1, "_on_tick_change")
	connect("tick_change", $VBoxMain/HBoxMain/PanelMain/VBoxContainer/Rythm2, "_on_tick_change")
	connect("tick_change", $VBoxMain/HBoxMain/PanelMain/VBoxContainer/Rythm3, "_on_tick_change")


func _process(delta):
	if (!Global.play):
		return
	
	var time = 0.0
	
	# Obtain from ticks.
	time = (OS.get_ticks_usec() - Global.time_begin) / 1000000.0
	# Compensate.
	time -= Global.time_delay
	# 1 noire : 1 temp
	var beat = int(time * Global.bpm / 60.0)
	# 1 double croche : 1/4 temps
	var tick = int(time * Global.bpm / 15.0)
		
	Global.current_beat = (beat% Global.nb_temps_par_mesure) +1
	Global.current_tick = tick % (Global.nb_temps_par_mesure*Global.nb_tick_par_temps*Global.nb_pattern)
	# envoyer un signal a chaque changement de tick
	if (prev_tick != Global.current_tick):
		prev_tick = Global.current_tick
		emit_signal("tick_change",Global.current_tick)


