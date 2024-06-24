tool
extends EditorPlugin


onready var editor_interface = EditorInterface


func _enter_tree():
	add_custom_type( \
		"MultiMeshLibrary", \
		"Spatial", \
		preload("res://addons/multimesh_library/nodes/multimesh_library.gd"), \
		get_editor_interface().get_base_control().theme.get_icon("Spatial", "EditorIcons")
	)

	add_custom_type( \
		"MultiMeshLibraryChild", \
		"Spatial", \
		preload("res://addons/multimesh_library/nodes/multimesh_library_child.gd"), \
		get_editor_interface().get_base_control().theme.get_icon("Spatial", "EditorIcons")
	)


func _exit_tree():
	remove_custom_type("MultiMeshLibrary")
	remove_custom_type("MultiMeshLibraryChild")
