extends Node

var bpm = 116

const nb_temps_par_mesure = 4
const nb_tick_par_temps = 4
const nb_pattern = 4
var active_loop = 0

var volume = 0
var mute = false
var play = false

var current_tick:int
var current_beat:int

# Used by system clock
var time_begin:float
var time_delay:float

# pattern buffer 
var pattern_buffer = []

# https://en.wikipedia.org/wiki/Interval_(music)#Frequency_ratios
# do re mi fa sol la si do
var major_pitch = [1 , 1.125, 1.25, 1.333, 1.5, 1.66, 1.875, 2]
# all notes
var all_notes_pitch = [1, 1.066, 1.125, 1.2, 1.25, 1.333, 1.406, 1.5, 1.6, 1.666, 1.777, 1.875, 2 ]
# todo : a completer pour avoir la grille complete

func time_init():
	Global.time_begin = OS.get_ticks_usec()
	Global.time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
