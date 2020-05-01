class MeshManipulator: #What should it extend? MeshDataTool?

	var mmesh
	var mdt = MeshDataTool.new()


	func _init(mesh0):
		mmesh = mesh0
		mdt.create_from_surface(mmesh, 0)
		print(mdt.get_vertex_count())


	func get_neighbours(index):
		var edges = mdt.get_vertex_edges(index)
		var vertices = []
		for e in edges:
			if mdt.get_edge_vertex(e,0)!=index:
				vertices.append(mdt.get_edge_vertex(e, 0))
			if mdt.get_edge_vertex(e,1)!=index:
				vertices.append(mdt.get_edge_vertex(e, 1))
		return vertices

	func dijkstra(start_index):
		var vcount = mdt.get_vertex_count()
		var dist = []
		dist.resize(vcount)
		var prev = []
		prev.resize(vcount)
		var q = []
		q.resize(vcount)
		for i in range(vcount):
			dist[i] = 9223372036854775807
			q[i] = i 
		dist[start_index] = 0
		while q.size()>0:
			var min_dist = 9223372036854775807
			var u
			for v in q:
				if dist[v]<min_dist:
					min_dist = dist[v]
					u = v
			q.remove(q.find(u))
			
			
			var neighbours = get_neighbours(u)
			for v in neighbours:
				var alt = dist[u] + 1
				if alt<dist[v]:
					dist[v] = alt
					prev[v] = u
		return([dist, prev])
				
		
		
	func _ready():
		pass # Replace with function body.
