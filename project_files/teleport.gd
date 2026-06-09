extends XRController3D

@onready var ray: RayCast3D = $TeleporterRay
@onready var marker: MeshInstance3D = $TeleporterMarker
var xr_origin: XROrigin3D
var xr_camera: XRCamera3D
var teleported = false;

func _ready() -> void:
	xr_origin = get_parent() as XROrigin3D
	xr_camera = xr_origin.get_node("XRCamera3D") as XRCamera3D
	marker.visible = false
	button_pressed.connect(self._on_right_controller_button_pressed)
	button_released.connect(self._on_right_controller_button_released)

func _process(_delta: float) -> void:
	if ray.is_colliding():
		marker.global_transform.origin = ray.get_collision_point()
		marker.visible = true
	else:
		marker.visible = false

func _on_right_controller_button_released(button:String):
	if(button=="trigger"):
		teleported=false

func _on_right_controller_button_pressed(button:String):
	if(button=="trigger" and not teleported):
		teleport_now()
		teleported = true

func teleport_now() -> void:
	if not ray.is_colliding():
		return
		
	var target: Vector3 = ray.get_collision_point()

	var origin_tf := xr_origin.global_transform
	var cam_tf := xr_camera.global_transform
	var cam_offset := cam_tf.origin - origin_tf.origin
	cam_offset.y = 0.0

	# 2) Ustal wysokość miejsca docelowego według trafienia (lub stałe 0.0, jeśli podłoże jest płaskie):
	#origin_tf.origin = Vector3(target.x - cam_offset.x, target.y, target.z - cam_offset.z)
	# (alternatywnie) 
	origin_tf.origin = Vector3(target.x - cam_offset.x, 0.0, target.z - cam_offset.z)
	xr_origin.global_transform = origin_tf
