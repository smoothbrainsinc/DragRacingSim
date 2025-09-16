
extends RigidBody3D

var acceleration = 50.0  # Slower than player for testing

func _physics_process(_delta):
	apply_central_force(transform.basis.z * -acceleration)  # Always accelerating forward
