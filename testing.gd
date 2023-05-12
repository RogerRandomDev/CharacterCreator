extends Control

@onready var resource:CharacterResource=$SubViewportContainer/SubViewport/CharacterModel.characterData







func _on_h_slider_value_changed(value):
	resource.EyeType=int(value)


func _on_h_slider_2_value_changed(value):
	resource.PupilType=int(value)


func _on_h_slider_3_value_changed(value):
	resource.EyeGap=value


func _on_h_slider_4_value_changed(value):
	resource.EyeScale.x=value


func _on_h_slider_5_value_changed(value):
	resource.EyeScale.y=value


func _on_h_slider_6_value_changed(value):
	resource.EyeRotation=value


func _on_color_picker_button_2_color_changed(color):
	resource.PupilColor=color


func _on_color_picker_button_color_changed(color):
	resource.EyeColor=color


func _on_h_slider_7_value_changed(value):
	resource.EyePosition=value
