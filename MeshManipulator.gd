class MeshManipulator: #What should it extend? MeshDataTool?

	var mmesh #Ehkä turha
	var mdt = MeshDataTool.new() #Voitaisiin ehkä välittää viittauksena, eikä luoda uutta


	func _init(mesh0):
		mmesh = mesh0
		mdt.create_from_surface(mmesh, 0)

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
	
	func copy_vertex(v):
		pass
	
	
	func combine_vertices(v, u):
		pass
		
	func proximity_indexer(separation): #Combines close by vertexes and reindexes mesh
		var arrays = mmesh.surface_get_arrays(0)
		var vertices = arrays[ArrayMesh.ARRAY_VERTEX]
		var indices = arrays[ArrayMesh.ARRAY_INDEX]
		#var colors = arrays[ArrayMesh.ARRAY_COLOR]
		var vcount = vertices.size()
		var ss = separation*separation
		
		for v in range(vcount):
			for u in range (v+1, vcount):
				if (vertices[v]-vertices[u]).length_squared()<ss:
					vertices[u] = vertices[v]
					#print(str(v)+ ", " +str(u))
					if indices!=null:
						for i in range(indices.size()):
							if indices[i] == u:
								indices[i] = v
								#print(i)
		var arr_mesh = ArrayMesh.new()
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		arrays[ArrayMesh.ARRAY_INDEX] = indices
		#arrays[ArrayMesh.ARRAY_COLOR] = null
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		mmesh = arr_mesh
		mdt.create_from_surface(mmesh, 0)
		return mmesh
