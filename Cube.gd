extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tmpmesh = Mesh.new()
var vertices = null
var color = Color(0.9, 0.1, 0.1)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	vertices = []
	# bottom
	vertices.append( Vector3( -1, -1, -1 ) )
	vertices.append( Vector3( 1, -1, -1 ) )
	vertices.append( Vector3( 1, -1, -1 ) )
	vertices.append( Vector3( 1, -1, 1 ) )
	vertices.append( Vector3( 1, -1, 1 ) )
	vertices.append( Vector3( -1, -1, 1 ) )
	vertices.append( Vector3( -1, -1, 1 ) )
	vertices.append( Vector3( -1, -1, -1 ) )
	# top
	vertices.append( Vector3( -1, 1, -1 ) )
	vertices.append( Vector3( 1, 1, -1 ) )
	vertices.append( Vector3( 1, 1, -1 ) )
	vertices.append( Vector3( 1, 1, 1 ) )
	vertices.append( Vector3( 1, 1, 1 ) )
	vertices.append( Vector3( -1, 1, 1 ) )
	vertices.append( Vector3( -1, 1, 1 ) )
	vertices.append( Vector3( -1, 1, -1 ) )
	# sides
	vertices.append( Vector3( -1, -1, -1 ) )
	vertices.append( Vector3( -1, 1, -1 ) )
	vertices.append( Vector3( 1, -1, -1 ) )
	vertices.append( Vector3( 1, 1, -1 ) )
	vertices.append( Vector3( 1, -1, 1 ) )
	vertices.append( Vector3( 1, 1, 1 ) )
	vertices.append( Vector3( -1, -1, 1 ) )
	vertices.append( Vector3( -1, 1, 1 ) )

	var surf = SurfaceTool.new()

	surf.begin(Mesh.PRIMITIVE_LINES)
	
	surf.add_color(Color(1, 0, 0))
	#surf.add_uv(Vector2(0, 0))
	
	for v in vertices:
		surf.add_vertex(v)
	surf.index()
	surf.commit(tmpmesh)
	
	mesh = tmpmesh
	
