tool
extends Spatial
class_name MultiMeshLibrary


export var mesh_library: MeshLibrary

var multimeshes := {}


func _enter_tree():
	assert(mesh_library, "No Meshlibrary set")
	for id in mesh_library.get_item_list():
		var multimesh_instance := MultiMeshInstance.new()
		multimesh_instance.multimesh = MultiMesh.new()
		multimesh_instance.multimesh.color_format = MultiMesh.COLOR_NONE
		multimesh_instance.multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
		multimesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh_instance.multimesh.instance_count = 0
		multimesh_instance.multimesh.mesh = mesh_library.get_item_mesh(id)

		call_deferred("add_child", multimesh_instance)
		multimeshes[id] = multimesh_instance


func _get_configuration_warning():
	if not is_instance_valid(mesh_library):
		return "MeshLibrary not set"
	return ""


func has_mesh_id(id):
	return mesh_library.get_item_list().find(id) != -1


func update_child_transform(child):
	if is_instance_valid(child.multimesh):
		child.multimesh.set_instance_transform(child.multimesh_id, child.transform)


func update_child_mesh(child):
	assert(mesh_library, "No Meshlibrary set")
	# remove from previous multimesh
	remove_multimesh_child(child)

	# set multimesh and id
	child.multimesh = multimeshes[child.mesh_id].multimesh
	child.multimesh_id = child.multimesh.instance_count

	# add to multimesh
	var multimesh_xforms = child.multimesh.transform_array
	child.multimesh.instance_count += 1
	multimesh_xforms.append_array([
		child.transform.basis.x,
		child.transform.basis.y,
		child.transform.basis.z,
		child.transform.origin,
	])
	child.multimesh.transform_array = multimesh_xforms


func remove_multimesh_child(child):
	# remove from previous multimesh
	if is_instance_valid(child.multimesh):
		var multimesh_xforms = child.multimesh.transform_array
		for i in range(4):
			multimesh_xforms.remove(child.multimesh_id * 4)
		child.multimesh.instance_count -= 1
		child.multimesh.transform_array = multimesh_xforms
