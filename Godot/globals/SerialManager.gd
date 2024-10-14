extends Node

@export var port := "/dev/pts/0"
@export var baudrate := 9600
var serial := SerialPort.new()

func _on_error(where, what) -> void:
	printerr("Got error when %s: %s" % [where, what])

func _on_data_received(data: PackedByteArray) -> void:
	print("Received data %s" % [data.get_string_from_ascii()])
	


func _ready() -> void:
	serial.got_error.connect(_on_error)
	serial.port = port
	serial.baudrate = baudrate
	
	serial.data_received.connect(_on_data_received)
	serial.start_monitoring(20_000)
	serial.open(port)
	
	print("Trying to connect to serial: %s" % "true" if serial.is_open() else "false")
	
	
