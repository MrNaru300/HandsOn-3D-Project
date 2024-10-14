extends Control

@export var sliders_scene: PackedScene

func _ready() -> void:
	%port.text_set.connect(_on_text_set)
	
	for id in Sensor.Names.keys():
		var scene_instace := sliders_scene.instantiate()
		var label := scene_instace.get_node("Label") as Label
		var slider := scene_instace.get_node("Slider") as Slider
		label.text = str(id)
		%Sliders.add_child(scene_instace)
		


func _on_text_set(text: String):
	SerialManager.start_serial(text)
