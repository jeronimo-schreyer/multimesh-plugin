tool
extends Spatial


export var mesh_id := 0 setget set_mesh_id


var parent
var multimesh
var multimesh_id


# Called when the node enters the scene tree for the first time.
func _ready():
	set_notify_transform(true)
	parent.update_child_mesh(self)


func set_mesh_id(value):
	mesh_id = value
	if parent and parent.has_mesh_id(value):
			parent.update_child_mesh(self)


func _notification(what):
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			if parent:
				parent.update_child_transform(self)

		NOTIFICATION_PARENTED:
			# revisar si es un MultiMeshLibraryNode o buscar para arriba
			parent = get_parent()

		NOTIFICATION_UNPARENTED:
			parent.remove_multimesh_child(self)


func _get_configuration_warning():
	if not parent is MultiMeshLibrary:
		return "Parent is not MultiMeshLibrary"
	return ""
