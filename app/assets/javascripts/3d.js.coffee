container   = undefined
stats       = undefined
camera      = undefined
scene       = undefined
renderer    = undefined
mesh        = undefined
group1      = undefined
group2      = undefined
group3      = undefined
light       = undefined
mouseX      = 0
mouseY      = 0
windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2

init = ->
  container = document.getElementById("container")
  camera = new THREE.PerspectiveCamera(20, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.z = 1800
  scene = new THREE.Scene()
  light = new THREE.DirectionalLight(0xffffff)
  light.position.set 0, 0, 1
  light.position.normalize()
  scene.add light
  shadowMaterial = new THREE.MeshBasicMaterial(map: THREE.ImageUtils.loadTexture("textures/shadow.png"))
  shadowGeo = new THREE.PlaneGeometry(300, 300, 1, 1)
  mesh = new THREE.Mesh(shadowGeo, shadowMaterial)
  mesh.position.y = -250
  mesh.rotation.x = -90 * Math.PI / 180
  scene.add mesh
  mesh = new THREE.Mesh(shadowGeo, shadowMaterial)
  mesh.position.y = -250
  mesh.position.x = -400
  mesh.rotation.x = -90 * Math.PI / 180
  scene.add mesh
  mesh = new THREE.Mesh(shadowGeo, shadowMaterial)
  mesh.position.y = -250
  mesh.position.x = 400
  mesh.rotation.x = -90 * Math.PI / 180
  scene.add mesh

  faceIndices = [ "a", "b", "c", "d" ]
  color       = undefined
  f           = undefined
  f2          = undefined
  f3          = undefined
  p           = undefined
  n           = undefined
  vertexIndex = undefined
  geometry    = new THREE.IcosahedronGeometry(1)
  geometry2   = new THREE.IcosahedronGeometry(1)
  geometry3   = new THREE.IcosahedronGeometry(1)
  i           = 0

  while i < geometry.faces.length
    f = geometry.faces[i]
    f2 = geometry2.faces[i]
    f3 = geometry3.faces[i]
    n = (if (f instanceof THREE.Face3) then 3 else 4)
    j = 0

    while j < n
      vertexIndex = f[faceIndices[j]]
      p = geometry.vertices[vertexIndex].position
      color = new THREE.Color(0xffffff)
      color.setHSV (p.y + 1) / 2, 1.0, 1.0
      f.vertexColors[j] = color
      color = new THREE.Color(0xffffff)
      color.setHSV 0.0, (p.y + 1) / 2, 1.0
      f2.vertexColors[j] = color
      color = new THREE.Color(0xffffff)
      color.setHSV 0.125 * vertexIndex / geometry.vertices.length, 1.0, 1.0
      f3.vertexColors[j] = color
      j++
    i++
  materials = [ new THREE.MeshLambertMaterial(
    color: 0xffffff
    shading: THREE.FlatShading
    vertexColors: THREE.VertexColors
  ), new THREE.MeshBasicMaterial(
    color: 0x000000
    shading: THREE.FlatShading
    wireframe: true
    transparent: true
  ) ]
  group1 = THREE.SceneUtils.createMultiMaterialObject(geometry, materials)
  group1.position.x = -400
  group1.rotation.x = -1.87
  group1.scale.set 200, 200, 200
  scene.add group1
  group2 = THREE.SceneUtils.createMultiMaterialObject(geometry2, materials)
  group2.position.x = 400
  group2.rotation.x = 0
  group2.scale = group1.scale
  scene.add group2
  group3 = THREE.SceneUtils.createMultiMaterialObject(geometry3, materials)
  group3.position.x = 0
  group3.rotation.x = 0
  group3.scale = group1.scale
  scene.add group3
  renderer = new THREE.WebGLRenderer(antialias: true)
  renderer.setSize window.innerWidth, window.innerHeight
  container.appendChild renderer.domElement
  stats = new Stats()
  stats.domElement.style.position = "absolute"
  stats.domElement.style.top = "0px"
  container.appendChild stats.domElement
  document.addEventListener "mousemove", onDocumentMouseMove, false
onDocumentMouseMove = (event) ->
  mouseX = (event.clientX - windowHalfX)
  mouseY = (event.clientY - windowHalfY)

animate = ->
  requestAnimationFrame animate
  render()
  stats.update()

render = ->
  camera.position.x += (mouseX - camera.position.x) * 0.05
  camera.position.y += (-mouseY - camera.position.y) * 0.05
  camera.lookAt scene.position
  renderer.render scene, camera

Detector.addGetWebGLMessage() unless Detector.webgl

$ ->
  init()
  animate()
