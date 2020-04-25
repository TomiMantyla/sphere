extends MeshInstance

# Member variables
export var side_length = 1.0
export(int) var freq = 1
export(Vector3) var start_point = Vector3(0,0,0)

var vertices = []

const hcoff = 0.86602540378

func up_neighbours(i,j):
	var left
	var right
	left = [i+1,j]
	right = [i+1,j+1]
	return([left,right])

func down_neighbours(i,j): #Ei määritelty ensimmäiselle verteksille!
	var left
	var right
	left = [i,j+1]
	right = [i+1,j+1]
	return([left,right])
	pass

func _ready():
	
	#print(vertex_at(0,2))
	
	var top = Vector3(0.5*side_length, hcoff*side_length, 0.0)
	var adj = Vector3(side_length, 0.0, 0.0)
	
	var t_top = top/freq
	var t_adj = adj/freq
	
	var f = freq+1
	print(freq)
	
	vertices.resize(f+1) #Eli freq+2, jotta saataisiin null loppuun
	for i in range(f+1):
		vertices[i] = []
		vertices[i].resize(i+2) #Taas yksi ylimääräinen nullia varten
	print(vertices)
	
	for i in range(f):
		#print(i)
		for j in range(i+1):
			#print("    "+str(j))
			vertices[i][j]=(j*t_adj + i*t_top)
	#print(vertices)
	for i in range(f+1):
		for j in range(i+1):
			print(str(i)+","+str(j)+"   "+str(up_neighbours(i,j))+"   "+str(down_neighbours(i,j)))
		#print(vertices[i])
	
