# sphere
<h1>Creating procedural mesh, approximation of sphere, in Godot</h1>

<p>There was two things I wanted to accomplish in this test.
First I wanted to learn, how to create mesh procedurally. Second, I wanted to make 
sphere which I can use as game map or board.</p>

<h2>Basis of design</h2>
<p>Starting from icosahedron, tesselating it and pushing tesselations outwards
creates simple approximation of sphere or geodesic polyhedron. This is done with unindexed mesh in master branch.</p>
<p>In indexed_mesh branch I created indexed mesh from unindexed mesh merging close vertices. Then it is truncated,
creating Goldberg polyhedron where each face is either pentagon or octahedron. This could be nice map for some strategy game.</p>
