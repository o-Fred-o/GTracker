tool
extends Control

export var width = 16
export var height = 16
export var cell_size = 12
export(Color) var intrument_color
export(Color) var current_time_color
export var pattern_indice = 0

var notes = []
var current_time = 0

var note_component = load("res://ui/views/components/note/note.tscn")
var cell
var current_time_rect
var mouse_pos
var array_pos
var active_pattern
var pattern_pos


func _ready() -> void:
	# cellule active
	cell = note_component.instance()
	cell.note_size=cell_size
	cell.intrument_color=intrument_color
	cell.visible=false
	add_child(cell)

	# bande pour la position actuelle du temps
	current_time_rect=ColorRect.new()
	#current_time_rect.rect_position=Vector2(current_time*cell_size-1,0)
	#current_time_rect.rect_size=Vector2(cell_size,height*cell_size)
	current_time_rect.color=current_time_color
	current_time_rect.mouse_filter=Control.MOUSE_FILTER_IGNORE
	current_time_rect.visible=false
	add_child(current_time_rect)
	draw_notes()

	if $options_menu.get_item_count() == 0 :
		$options_menu.add_item("Copy")
		$options_menu.add_item("Cut")
		$options_menu.add_item("Paste")
		$options_menu.add_item("Delete")


func _gui_input(event) -> void:
	mouse_pos = get_local_mouse_position()
	array_pos = Vector2(int(mouse_pos.x/cell_size),int(mouse_pos.y/cell_size))
	
	if event is InputEventMouseMotion:
		if $options_menu.visible == false:
			draw_mouse()
			
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed() and $options_menu.visible == false:
			if (array_pos.x >= 0 and array_pos.y >= 0 and array_pos.x < width and array_pos.y < height):
				if (notes.count(array_pos)==0):
					notes.append(array_pos)
				else:
					notes.erase(array_pos)
			draw_notes()
		if event.button_index == BUTTON_RIGHT and event.pressed:
			$options_menu.set_position(get_global_mouse_position())
			$options_menu.popup()


# dessine le canvas du pattern : une grille
func _draw() -> void:
	rect_min_size=Vector2(width*cell_size, height*cell_size)
	for i in width+1:
		var deb = Vector2(i*cell_size,0)
		var fin = Vector2(i*cell_size,height*cell_size)

		if (i%4 == 0):
			draw_line(deb,fin,Color.gray,2)
		else:
			draw_line(deb,fin,Color.gray,1)

	for j in height+1:
		var deb = Vector2(0, j*cell_size)
		var fin = Vector2(width*cell_size,j*cell_size)
		draw_line(deb,fin,Color.gray)


func get_minimum_size() -> Vector2:
	return Vector2(width*cell_size, height*cell_size)


# affiche le curseur de la souris et la note 
func draw_mouse() -> void:
	cell.visible=true
	cell.rect_position=Vector2(array_pos.x*cell_size,array_pos.y*cell_size+1)


func draw_notes() -> void:
	#ajout des note_component pour les notes 
	delete_children($liste_notes)
	var global_position= get_global_rect().position
	for n in notes:
		var note = note_component.instance()
		note.note_size=cell_size
		note.rect_position=Vector2(global_position.x+n.x*cell_size,global_position.y+n.y*cell_size+1)
		#note.rect_position=Vector2(local_position.x+array_pos.x+n.x*cell_size,local_position.y+array_pos.y+n.y*cell_size)
		note.intrument_color=intrument_color
		note.note_time=n.x
		note.note_value=n.y
		$liste_notes.add_child(note)


# affiche une barre vertical pour le current_time du tick
# retounr la liste des notes du temps
func show_current_time(current_pattern,time_in_pattern) -> Array:
	var res = []
	if (pattern_indice == current_pattern):
		current_time_rect.rect_position=Vector2(time_in_pattern*cell_size,0)
		current_time_rect.rect_size=Vector2(cell_size,height*cell_size)
		current_time_rect.visible=true
		for n in $liste_notes.get_children():
			if (n.note_time == time_in_pattern):
				res.push_back(n.note_value)
				
	else:
		current_time_rect.visible=false

	return res


func delete_children(node) -> void:
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func _on_options_menu_id_pressed(id): 
	# copy
	if id == 0:
		Global.pattern_buffer = [] + notes
	# paste
	if id == 2:
		notes = [] + Global.pattern_buffer
		draw_notes()
	# delete
	if id == 3:
		notes = []
		draw_notes()
	
	$options_menu.visible = false


func _on_pattern_mouse_exited():
	cell.visible=false


func _on_drum_mouse_exited():
	cell.visible=false
