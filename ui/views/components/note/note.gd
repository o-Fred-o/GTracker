extends Control

export(Color) var intrument_color
export(Color) var base_color
export(int) var note_size
export(int) var note_time
export(int) var note_value

func _ready() -> void:
	$ReferenceRect.color=intrument_color
	#$ReferenceRect.rect_size=Vector2(note_size,note_size)

func _on_ColorRect_mouse_entered() -> void:
	$ReferenceRect.color=intrument_color

func _on_ColorRect_mouse_exited() -> void:
	$ReferenceRect.color=intrument_color
