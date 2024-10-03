extends Node

@export var port := "/dev/USB0"
@export var baudrate := 9600
var serial := SerialPort.new()

func _on_error(where, what) -> void:
	print_debug("Got error when %s: %s" % [where, what])

func _on_data_received(data: PackedByteArray) -> void:
	print_debug("Received data %s" % [data.get_string_from_ascii()])
	


func _ready() -> void:
	serial.got_error.connect(_on_error)
	serial.port = port
	serial.baudrate = baudrate
	
	serial.data_received.connect(_on_data_received)
	serial.start_monitoring(20_000)
	
	
