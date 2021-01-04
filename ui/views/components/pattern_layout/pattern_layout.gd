extends VBoxContainer

export var width = 16
export var height = 16
export var cell_size = 12
export(Color) var intrument_color
export(String, DIR) var instrument_dir

var instrument : String
var active_loop = 0

func _ready() -> void:
	rect_min_size=Vector2(width*cell_size, height*cell_size)
	
	var liste_patterns = $HBoxContainer/PatternList.get_children()	
	for pattern in liste_patterns:
		pattern.height=height
		pattern.width=width
		pattern.cell_size=cell_size
		pattern.intrument_color=intrument_color
	
	#si height==1 alors on affiche l'interface pour le rythme
	if (height==1):
		var rythmChoiceContainer=find_node('RythmChoice')
		rythmChoiceContainer.visible=true
		var EffectChoiceContainer=find_node('EffectChoice')
		EffectChoiceContainer.visible=false
		var PresetList=find_node('RythmPreset')
		PresetList.add_item("Preset 1")
		PresetList.add_item("Preset 2")
		
	#Recupere la liste des instruments
	var dir = Directory.new()
	if dir.open(instrument_dir) == OK:
		var instrument_list=find_node('InstrumentOption')
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() in ["wav", "ogg"]:
				instrument_list.add_item(file_name.get_basename())
			file_name = dir.get_next()
		dir.list_dir_end()
		instrument = instrument_dir + "/" + instrument_list.get_item_text(0) + ".wav"


func _on_RythmPreset_item_selected(index) -> void:
	if (index == 0):
		#ajouter des notes dans patternList
		var liste_patterns = $HBoxContainer/PatternList.get_children()
		for pattern in liste_patterns:
			pattern.notes=[Vector2(0,0),Vector2(4,0),Vector2(8,0),Vector2(12,0)]
			pattern.draw_notes()


# se connecter au changement de tick et determiner quel pattern changer
func _on_tick_change(current_tick) -> void:
	var liste_pattern=$HBoxContainer/PatternList.get_children()
	var current_pattern=current_tick/16
	var tick_in_pattern=current_tick%16
	var liste_notes
	var pitch
	
	if (Global.active_loop!=0):
		current_pattern=Global.active_loop-1
		
	#liste_pattern[current_pattern].show_current_time(current_pattern,tick_in_pattern)
	for pattern in liste_pattern:
		liste_notes=pattern.show_current_time(current_pattern,tick_in_pattern)
		if (!liste_notes.empty()):
			for note in liste_notes:
				# in a drum layout, only 1 height
				if height == 1:
					pitch = 1
				else:
					pitch=Global.all_notes_pitch[15-note]
				AudioManager.play(instrument,pitch)
				


func _on_InstrumentOption_item_selected(index):
	var instrument_list=find_node('InstrumentOption')
	instrument = instrument_dir + "/" + instrument_list.get_item_text(index) + ".wav"

