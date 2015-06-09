ig.getData = ->
  data = ig.data.matrix.split "\n" .map ->
    it
      .split "\t"
      .map parseInt _, 10
  matrix = [0 til 28].map -> []
  inverseData = [0 til 28].map -> []
  for x in [0 til 28]
    for y in [0 to x]
      matrix[y][x] = matrix[x][y] = data[y][x] + data[x][y]
    for y in [0 til 28]
      inverseData[y][x] = data[x][y]
  {matrix, data, inverseData}
