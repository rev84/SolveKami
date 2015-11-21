class Kami
  board = []
  constructor:()->
    @board = [
      [1,1,1,2,2]
      [1,1,1,2,2]
      [1,1,1,2,2]
      [1,1,1,2,2]
    ]
  # ボードをノードに分割する
  board2node:(board)->
    nodes = []
    xMax = board.length
    yMax = board[0].length

    # ノード化再帰関数
    check = (x, y, v, board, nodeList)->
      return [board, nodeList] if board[x][y] isnt v
      nodeList.push [x, y]
      board[x][y] = null
      # 縦横
      for p in [[-1,0], [1,0],[0,-1],[0,1]]
        [plusX, plusY] = p
        continue if x+plusX < 0 or board.length <= x+plusX
        continue if y+plusY < 0 or board[0].length <= y+plusY
        [board, nodeList] = check(x+plusX, y+plusY, v, board, nodeList)
      [board, nodeList]

    # board走査
    for x in [0...xMax]
      for y in [0...yMax]
        # 値
        v = board[x][y]
        # もうノード化済み
        continue if v is null
        # ノード化
        [board, node] = check(x, y, v, board, [])
        # ノードを保存
        res = 
          value : v
          node  : node
          link  : []
        nodes.push res
    
    # ノードの繋がりを計測
    isLink = (node1, node2)=>
      makeMap = (node)=>
        xMax = 0
        yMax = 0
        for xy in node
          [x, y] = xy
          xMax = x if xMax < x
          yMax = y if yMax < y
        map = @getEmptyBoard(xMax+1, yMax+1)
        for xy in node
          [x, y] = xy
          map[x][y] = true
        map
      map2 = makeMap node2
      for xy in node1
        [x, y] = xy
        for p in [[-1,0], [1,0],[0,-1],[0,1]]
          [plusX, plusY] = p
          continue if x+plusX < 0 or map2.length <= x+plusX
          continue if y+plusY < 0 or map2[0].length <= y+plusY
          return true if map2[x+plusX][y+plusY]
      false
    for nIndex1 in [0...nodes.length]
      node1 = nodes[nIndex1].node
      for nIndex2 in [nIndex1+1...nodes.length]
        node2 = nodes[nIndex2].node
        if isLink node1, node2
          nodes[nIndex1].link.push nIndex2
          nodes[nIndex2].link.push nIndex1
    nodes

  getEmptyBoard:(xMax, yMax, value = false)->
    res = []
    for x in [0...xMax]
      res[x] = []
      for y in [0...yMax]
        res[x][y] = value
    res
