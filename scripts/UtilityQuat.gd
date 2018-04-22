extends Object
var a
var i
var j
var k

#Gets the axis of rotation of this quaternion
func get_axis():
	var rawVector = Vector3(i, j, k)
	if(rawVector.length() > 0):
		if(a > 0):
			return rawVector / rawVector.magnitude
		else:
			return -1 * rawVector / rawVector.magnitude
	else:
		return Vector3(0,0,1)

#Constructor
func _init(a, i, j, k):
	self.a = a
	self.i = i
	self.j = j
	self.k = k
	
#Constructor wrapper - needed for instance methods to work
static func create(a, i, j, k):
	return new(a, i, j, k)

#Converts a Vector3 to a quaternion in the proper format for rotation math
static func convert_vector3(vector_to_convert):
	var a = 0
	var i = vector_to_convert.x
	var j = vector_to_convert.y
	var k = vector_to_convert.z
	return new(a, i, j, k)
	
#Creates a UtilityQuat from a Godot Quat
static func convert_quat(convertTo):
	var a = convertTo.w
	var i = convertTo.x
	var j = convertTo.y
	var k = convertTo.z
	return new(a, i, j, k)

#Creates a UtilityQuat that will rotate the Vector3 from to the Vector3 to in the same plane
static func rotation_map(from, to):
	var vectorBase = from.cross(to)
	var i = vectorBase.x
	var j = vectorBase.y
	var k = vectorBase.z
	
	var a = cos(acos(from.dot(to) / from.length() / to.length()) / 2)
	
	var scale = 1
	if (0 != (i * i + j * j + k * k)):
		scale = sqrt((1 - a * a) / (i * i + j * j + k * k))
		i = i * scale
		j = j * scale
		k = k * scale
	return new(a,i,j,k)

#Performs the hamilton product between self as the left operand and right as the right operand
func hamilton(right): 
	var a = self.a * right.a - self.i * right.i - self.j * right.j - self.k * right.k
	var i = self.a * right.i + self.i * right.a + self.j * right.k - self.k * right.j
	var j = self.a * right.j - self.i * right.k + self.j * right.a + self.k * right.i
	var k = self.a * right.k + self.i * right.j - self.j * right.i + self.k * right.a
	
	return create(a,i,j,k)

#Rotates a Vector3 using self
func rotate(toRotate):
	var preRotateQuaternion = convert_vector3(toRotate)
	var intermediate = self.hamilton(preRotateQuaternion)
	var rotatedQuaternion = intermediate.hamilton(self.reciprocal())
	return Vector3(rotatedQuaternion.i, rotatedQuaternion.j, rotatedQuaternion.k)

#Creates a UtilityQuat to be the reciprocal of self
func reciprocal():
	var recip_a = self.a / self.length_squared()
	var recip_i = -1 * self.i / self.length_squared()
	var recip_j = -1 * self.j / self.length_squared()
	var recip_k = -1 * self.k / self.length_squared()
	return create(recip_a, recip_i, recip_j, recip_k)

#Returns the length of self squared
func length_squared():
	return self.a * self.a + self.i * self.i + self.j * self.j + self.k * self.k

#Returns self converted to a godot quaternion
func to_godot_quaternion():
	return Quat(self.i, self.j, self.k, self.a)

#Returns the rotation that self represents represented as an Euler rotation
func to_euler():
	var sineAlphaHalf = sqrt(1 - a * a)
	var x = acos(i / sineAlphaHalf)
	var y = acos(j / sineAlphaHalf)
	var z = acos(k / sineAlphaHalf)
	return Vector3(x, y, z)

#Returns the combined rotation of self and doNext
func add_rotation(doNext):
	return doNext.hamilton(self)


func to_string():
	return "a: " + a + ", i: " + i +", j: " + j +", k: " + k
	
#Computes the a value needed to perform a rotation in the given radians
static func a_for_radian(radian):
	return cos(radian/2)
	
#Creates a unit quaternion with the same a value, and the i, j, and k values scaled
static func unit_for_angle_and_axis(radian, i, j, k):
	var a = a_for_radian(radian)
	var scale = 1
	if(0 > sin(radian/2)):
		scale = -1
	if (0 != (i * i + j * j + k * k)):
		scale = scale * sqrt((1 - a * a) / (i * i + j * j + k * k))
		i = i * scale
		j = j * scale
		k = k * scale
	return new(a, i, j, k)
	
#Constructs a UtilityQuat representing a rotation in YXZ rotation notation (Rotatae along the z-axis, then the x-axis, then the y-axis)
static func quat_from_YXZ(vector):
	var z_quat = unit_for_angle_and_axis(vector.z,0,0,1)
	var x_quat = unit_for_angle_and_axis(vector.x,1,0,0)
	var y_quat = unit_for_angle_and_axis(vector.y,0,1,0)
	
	var xz_quat = z_quat.add_rotation(x_quat)
	var yxz_quat = xz_quat.add_rotation(y_quat)
	return yxz_quat