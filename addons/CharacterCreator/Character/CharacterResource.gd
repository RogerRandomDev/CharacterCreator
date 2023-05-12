@tool
extends Resource
class_name CharacterResource
##used to store the unique data for a character for use by the [CharacterModel]

##sends a signal when a parameter held by the shader gets changed
signal shaderParameterChanged(part:String,parameterName:String,newValue)
##sends a signal when a mesh would need changed
signal meshParameterChanged()


@export_group("Eye")
##changes the eye texture
@export_range(0,2) var EyeType:int=0:
	set(v):
		emit_signal('shaderParameterChanged','LeftEye','tex',getPartTexture('Eye',v))
		emit_signal('shaderParameterChanged','RightEye','tex',getPartTexture('Eye',v))
		EyeType=v
	get:return EyeType

##sets the color of the eye
@export_color_no_alpha var EyeColor:Color:
	set(v):
		emit_signal('shaderParameterChanged','LeftEye','color',v)
		emit_signal('shaderParameterChanged','RightEye','color',v)
		EyeColor=v
	get:return EyeColor

##gap between eyes
@export var EyeGap:float=0.0:
	set(v):
		emit_signal("meshParameterChanged","LeftEye",'position',Vector3(0.2*v,EyePosition,0.375))
		emit_signal("meshParameterChanged","RightEye",'position',Vector3(-0.2*v,EyePosition,0.375))
		EyeGap=v
	get:return EyeGap
##vertical position of the eyes
@export var EyePosition:float=0.0:
	set(v):
		emit_signal("meshParameterChanged","LeftEye","position",Vector3(0.2*EyeGap,v,0.375))
		emit_signal("meshParameterChanged","RightEye","position",Vector3(-0.2*EyeGap,v,0.375))
		EyePosition=v
	get:return EyePosition
##eye rotation
@export var EyeRotation:float=0.0:
	set(v):
		emit_signal("meshParameterChanged","LeftEye","rotation",Vector3(0,0,v))
		emit_signal("meshParameterChanged","RightEye","rotation",Vector3(0,0,-v))
		EyeRotation=v
	get:return EyeRotation

##size of the eye
@export var EyeScale:Vector2=Vector2.ONE:
	set(v):
		emit_signal('meshParameterChanged',"LeftEye",'mesh:size',v*0.1)
		emit_signal('meshParameterChanged',"RightEye",'mesh:size',v*0.1)
		emit_signal('meshParameterChanged',"LeftEye/Pupil",'mesh:size',v*0.1)
		emit_signal('meshParameterChanged',"RightEye/Pupil",'mesh:size',v*0.1)
		EyeScale=v
	get:return EyeScale

##changes the pupil texture
@export_range(0,2) var PupilType:int=0:
	set(v):
		var t=getPartTexture("Pupil",v)
		emit_signal('shaderParameterChanged','LeftEye/Pupil','tex',t)
		emit_signal('shaderParameterChanged','RightEye/Pupil','tex',t)
		PupilType=v
	get:return PupilType

##color of the pupil
@export_color_no_alpha var PupilColor:Color:
	set(v):
		emit_signal('shaderParameterChanged','LeftEye/Pupil','color',v)
		emit_signal('shaderParameterChanged','RightEye/Pupil','color',v)
		PupilColor=v
	get:return PupilColor



##the shader used for most expression components. I.E. the mouth, nose, eyes, and pupils
const expressionShader=preload("res://addons/CharacterCreator/Character/Expressions.gdshader")

#creates the quads used for most components
func _createQuad(size:Vector2,color:Color,texture:Texture2D)->QuadMesh:
	var mesh=QuadMesh.new()
	mesh.size=size
	var mat=ShaderMaterial.new()
	mat.shader=expressionShader
	mat.set_shader_parameter("color",color)
	mat.set_shader_parameter("tex",texture)
	mesh.surface_set_material(0,mat)
	return mesh


##returns the relevant eye
func getEye(isLeft:bool=true,addTo:Node=null)->MeshInstance3D:
	var eye=MeshInstance3D.new()
	var pupil=MeshInstance3D.new()
	eye.name="Eye"
	pupil.name="Pupil"
	
	eye.mesh=_createQuad(EyeScale*0.1,EyeColor,getPartTexture("Eye",EyeType))
	pupil.mesh=_createQuad(EyeScale*0.1,PupilColor,getPartTexture("Pupil",PupilType))
	eye.scale.x=int(!isLeft)*2-1
	eye.add_child(pupil)
	addTo.add_child(eye)
	
	eye.position=Vector3(0.2*EyeGap*(int(isLeft)*2-1),EyePosition,0.375)
	pupil.position=Vector3(0,0,0.001)
	
	eye.rotation.z=EyeRotation
	return eye


##returns texture for the eye
func getPartTexture(part:String,version:int=0)->Texture2D:
	return load("res://addons/CharacterCreator/Editor/Textures/%s.png"%(str(part)+str(version)))
