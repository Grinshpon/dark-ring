class_name Level

var scale := 5
var map: Array
var width: int
var height: int

var start: Vector2
var end: Vector2

class Room:
  var origin: Vector2
  var width: int
  var height: int
  func _init(o: Vector2, w: int, h: int) -> void:
    self.origin = o
    self.width = w
    self.height = h

func rand_veci() -> Vector2:
  return Vector2(randi()%width, randi()%height)

func mget(m: Array, x: int, y: int) -> int:
  return m[y][x]
func mset(m: Array, x: int, y: int, n: int) -> int:
  m[y][x] = n
  return n
func mgetv(m: Array, v: Vector2) -> int:
  return m[int(v.y)][int(v.x)]
func msetv(m: Array, v: Vector2, n: int) -> int:
  m[int(v.y)][int(v.x)] = n
  return n

func _init(x: int, y: int) -> void:
  width = x
  height = y

func gen_map() -> void:
  randomize()
  map.clear()
  
  for y in range(height):
    map.push_back([])
    for _x in range(width):
      map[y].push_back(0)

  start = rand_veci()
  end = rand_veci()
  while(start.distance_squared_to(end) < pow(max(width,height)/2,2)):
    end = rand_veci()
  msetv(map,start,1)
  msetv(map,end,1)
  var rooms := make_rooms_init()
  for room in rooms:
    put_on_map(room)
  make_halls(rooms)
  final_pass()
  format()

func make_rooms_init() -> Array:
  var rooms := [Room.new(start,3,3), Room.new(end,3,3)]
  var num_of_rooms := int(round(log(width*height)))
  print(num_of_rooms+2, " rooms")
  for i in range( num_of_rooms ):#randi()%6+4): #range(randi()%((width*height/20)-4)+4):
    var w := randi()%4+3
    var h := randi()%4+3
    var x := randi()%(width-w/2-1)+w/2+1
    var y := randi()%(height-h/2-1)+h/2+1
    var timeout := 10
    var room_collision := true
    while room_collision && timeout > 0:
      room_collision = false
      for room in rooms:
        var px1: bool = (x > room.origin.x) && (x-w/2-1 < room.origin.x+room.width/2+1) #||
        var px2: bool = (x < room.origin.x) && (x+w/2+1 > room.origin.x-room.width/2-1)
        var py1: bool = (y > room.origin.y) && (y-h/2-1 < room.origin.y+room.height/2+1) #||
        var py2: bool = (y < room.origin.y) && (y+h/2+1 > room.origin.y-room.height/2-1)
        #if (px1 && (py1 || py2)) || (px2 && (py1 || py2)):
        if (py1 || py2) && (px1 || px2):
          room_collision = true
        else:
          room_collision = room_collision || false
      if room_collision:
        timeout -= 1
        x = randi()%(width-w/2-1)+w/2+1
        y = randi()%(height-h/2-1)+h/2+1
    #print("t ", timeout)
    rooms.append(Room.new(Vector2(x,y),w,h))
  return rooms

func put_on_map(room: Room) -> void:
  #print("h: ", room.height)
  for y in range(-room.height/2, room.height/2+1):
    if !(y == room.height/2 && room.height%2 == 0):
      #print(y)
      for x in range(-room.width/2, room.width/2+1):
        if !(x == room.width && room.width%2 == 0) && !isOTB(room.origin.y+y,room.origin.x+x):
          mset(map,room.origin.x+x, room.origin.y+y,9)
  #print("------")

func make_halls(rooms: Array) -> void:
  var points := PoolVector2Array()
  for room in rooms:
    points.append(room.origin)
  var tri_indices := Geometry.triangulate_delaunay_2d(points)
  if tri_indices.empty():
    print("hallway generation failed")
  var halls := {}
  for i in range(0,tri_indices.size(),3):
    var mask := randi()%7+1 # between 1-7 (001-111)
    if ((mask & 1) == 1) && !(halls.has(Vector2(tri_indices[i], tri_indices[i+1])) || halls.has(Vector2(tri_indices[i+1],tri_indices[i]))):
      halls[Vector2(tri_indices[i],tri_indices[i+1])] = true
      gen_hall(rooms[tri_indices[i]], rooms[tri_indices[i+1]])
    if ((mask & 2) == 2) && !(halls.has(Vector2(tri_indices[i], tri_indices[i+2])) || halls.has(Vector2(tri_indices[i+2],tri_indices[i]))):
      halls[Vector2(tri_indices[i],tri_indices[i+2])] = true
      gen_hall(rooms[tri_indices[i]],rooms[tri_indices[i+2]])
    if ((mask & 4) == 4) && !(halls.has(Vector2(tri_indices[i+1], tri_indices[i+2])) || halls.has(Vector2(tri_indices[i+2],tri_indices[i+1]))):
      halls[Vector2(tri_indices[i+1],tri_indices[i+2])] = true
      gen_hall(rooms[tri_indices[i+1]],rooms[tri_indices[i+2]])
    
func gen_hall(start: Room, end: Room) -> void:
  #print(start,end)
  var current := start.origin
  while current.x != end.origin.x || current.y != end.origin.y:
    if current.x < end.origin.x:
      current.x += 1
    elif current.x > end.origin.x:
      current.x -= 1
    elif current.y < end.origin.y:
      current.y += 1
    elif current.y > end.origin.y:
      current.y -= 1
    msetv(map,current,9) 
  
func final_pass() -> void: #create some random holes
  for y in range(1,height):
    for x in range(1,width):
      if (x != start.x || y != start.y) && (x != end.x || y != end.y) && gtz(x,y) && surrounded_by_n(x,y) > 6 && randi()%5 == 1:
        mset(map,x,y, 0)

func surrounded(x: int, y: int) -> bool:
  for i in range(-1,2):
    for j in range(-1,2):
      if !gtz(x+j,y+i):
        return false
  return true

func surrounded_by_n(x: int, y: int) -> int:
  var n := 0
  for i in range(-1,2):
    for j in range(-1,2):
      if gtz(x+j,y+i):
        n += 1
  return n-1 # -1 to account for center point (x,y) being counted

func isOTB(x: int, y: int) -> bool: # is out of bounds?
  return x >= width || x < 0 || y >= height || y < 0

func isZero(x: int, y: int) -> bool:
  if x >= width || x < 0 || y >= height || y < 0:
    return false
  else:
    return mget(map,x,y) == 0

func gtz(x: int, y: int) -> bool: # greater than zero
  if x >= width || x < 0 || y >= height || y < 0:
    return false
  else:
    return mget(map,x,y) > 0

func format() -> void:
  for y in range(height):
    for x in range(width):
      if gtz(x,y):
        var t := 0
        if gtz(x+1,y):
          t += 1
        if gtz(x,y+1):
          t += 2
        if gtz(x-1,y):
          t += 4
        if gtz(x,y-1):
          t += 8
        mset(map,x,y, t)



func print_map() -> void:
  for slice in map:
    print(show_map(slice))

## Delet this before anyone sees it
func show_map(map: Array) -> String:
  return fs(str(map).replace("],", "]\n").replace(" 0","  .").replace("[0", "[ .").replace(" 0]","  .]").replace(","," ").replace("[["," [").replace("]]","]"))

func fs(s: String) -> String:
  return ds(de(df(s)))

func df(s: String) -> String:
  return s.replace(" 1 ", " 01 ").replace(" 2 ", " 02 ").replace(" 3 ", " 03 ").replace(" 4 ", " 04 ").replace(" 5 ", " 05 ").replace(" 6 ", " 06 ").replace(" 7 ", " 07 ").replace(" 8 ", " 08 ").replace(" 9 ", " 09 ")

func de(s: String) -> String:
  return s.replace(" 1]", " 01]").replace(" 2]", " 02]").replace(" 3]", " 03]").replace(" 4]", " 04]").replace(" 5]", " 05]").replace(" 6]", " 06]").replace(" 7]", " 07]").replace(" 8]", " 08]").replace(" 9]", " 09]")

func ds(s: String) -> String:
  return s.replace("[1 ", "[01 ").replace("[2 ", "[02 ").replace("[3 ", "[03 ").replace("[4 ", "[04 ").replace("[5 ", "[05 ").replace("[6 ", "[06 ").replace("[7 ", "[07 ").replace("[8 ", "[08 ").replace("[9 ", "[09 ")
