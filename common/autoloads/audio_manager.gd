extends Node

# Adapted from SFXPlayer by TheDuriel
# https://github.com/TheDuriel/DurielsGodotUtilities

#use : 	AudioStreamManager.play(path)

var num_players = 8
var bus = "master"

var available = []
var queue = []


func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus


func _on_stream_finished(stream):
	available.append(stream)


func play(sound_path,pitch):
	queue.append([sound_path,pitch])


func _process(delta):
	if not queue.empty() and not available.empty():
		var note = queue.pop_front()
		available[0].stream = load(note[0])
		available[0].set_pitch_scale(note[1])
		available[0].play()
		available.pop_front()
