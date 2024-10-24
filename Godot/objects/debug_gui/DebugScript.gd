extends Control

@export var sliders_scene: PackedScene



func _ready() -> void:
	%send.pressed.connect(_on_text_set)
	
	for id in Sensor.Names.keys():
		var scene_instace := sliders_scene.instantiate()
		var label := scene_instace.get_node("Label") as Label
		var slider := scene_instace.get_node("Slider") as Slider
		label.text = str(id)
		%Sliders.add_child(scene_instace)
	
	%ResetButton.pressed.connect(_on_reset_button)
		

func _on_reset_button():
	for child in %Sliders.get_children():
		var slider := child.get_node("Slider") as Slider
		slider.value = 0

func _on_text_set():
	var text = %port.text
	SerialManager.start_serial(text)
