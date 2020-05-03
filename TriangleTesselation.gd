extends MeshInstance

# Member variables
export var side_length = 2.0
export(int) var freq = 1
export(Vector3) var start_point = Vector3(0,0,0)

var vertices = []
var st = SurfaceTool.new()

const hcoff = 0.86602540378

func up_neighbours(i,j):
	var left
	var right
	left = [i+1,j]
	right = [i+1,j+1]
	return([left,right])

func down_neighbours(i,j):
	var left
	var right
	left = [i,j+1]
	right = [i+1,j+1]
	return([left,right])
	pass

func meshify():
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#Ensimmäinen kolmio
	st.add_color(Color.red)
	st.add_vertex(vertices[0][0])
	st.add_vertex(vertices[1][1])
	st.add_vertex(vertices[1][0])
	var f = freq+1
	for i in range(1, freq):
		for j in range(i+1):
			#Ensin ylöspäin osoittavat kolmiot
			st.add_color(Color.red)
			st.add_vertex(vertices[i][j])
			st.add_vertex(vertices[i+1][j+1])
			st.add_vertex(vertices[i+1][j])
			#Sitten alaspäin osoittavat kolmiot
		for j in range(i):
			st.add_color(Color.blue)
			st.add_vertex(vertices[i][j])
			st.add_vertex(vertices[i][j+1])
			st.add_vertex(vertices[i+1][j+1])
	st.generate_normals()
	mesh = st.commit()


func _ready():
	
	var down = Vector3(-0.5*side_length, -1.0*hcoff*side_length, 0.0)
	var right = Vector3(side_length, 0.0, 0.0)
	
	var t_down = down/freq
	var t_right = right/freq
	
	var f = freq+1
	
	vertices.resize(f) 
	for i in range(f):
		vertices[i] = []
		vertices[i].resize(i+1)
	
	for i in range(f):
		#print(i)
		for j in range(i+1):
			#print("    "+str(j))
			vertices[i][j]=(i*t_down + j*t_right)
	#print(vertices)
	for i in range(f+1):
		for j in range(i+1):
			pass
	meshify()
