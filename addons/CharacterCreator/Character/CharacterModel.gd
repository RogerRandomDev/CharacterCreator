@tool
extends Node3D
class_name CharacterModel
##a node that takes the data for a character and builds it into a functional model


@export var reload:bool:
	set(v):
		initModel()
	get:return reload

@export var characterData:CharacterResource
##stores the components used by the model
var componentList:Dictionary


func _ready():
	initModel()
	characterData.connect('shaderParameterChanged',updateModelShaders)
	characterData.connect('meshParameterChanged',updateModelMesh)

##creates the structure for the meshes
func initModel():
	for child in get_children():child.queue_free()
	var head=MeshInstance3D.new()
	head.mesh=SphereMesh.new()
	head.name="Head"
	add_child(head)
	componentList["Head"]=head
	componentList["LeftEye"]=characterData.getEye(true,head)
	componentList["RightEye"]=characterData.getEye(false,head)
	
##returns the relevant part from it's related path
func getPartFromPath(partName:String)->Node:
	var part=partName.split("/")
	if !componentList.has(part[0]):return
	var component=componentList[part[0]]
	#allows you to access hidden children
	for child in range(1,part.size()):component=component.get_node(part[child])
	return component


##updates the shader parameter of the relevant mesh part(s)
func updateModelShaders(partName:String,parameter:String,value)->void:
	var component=getPartFromPath(partName)
	if !component:return
	component.mesh.surface_get_material(0).set_shader_parameter(parameter,value)
##updates the mesh parameters for the relevant part(s)
func updateModelMesh(partName:String,parameter:String,value)->void:
	var component=getPartFromPath(partName)
	if !component:return
	var paramParts=parameter.split(":")
	var compToChange=component
	for part in range(0,paramParts.size()-1):
		compToChange=compToChange.get(paramParts[part])
	compToChange.set(paramParts[paramParts.size()-1],value)
