class window.Kami
  # 規定ターン数で解答を得る
  @solve = (board, turnNum, pathes = [])->
    console.log 'count:'+(++window.count)
    # 手数不足
    return false if turnNum < 0
    # 解答条件を満たしていれば帰る
    return pathes if @isSolvedBoard board

    # 枝切
    # 残りの色の数-1が残りターン数より大きければ打ち切り
    return false if @board2colors(board).length-1 > turnNum

    colors = @board2colors board
    nodes = @board2node board

    # 全ノードを対象に
    for node in nodes
      myColor = node.color
      # 全色で塗りつぶす
      for color in colors
        boardTemp = board.copy()
        pathesTemp = pathes.copy()
        # 同じ色で塗ってもしょうがない
        continue if myColor is color
        # 塗る
        for path in node.path
          [x, y] = path
          boardTemp[x][y] = color
        # 塗った履歴
        pathesTemp.push [color, node.path[0]]
        # 塗ったので、さらに解答に丸投げ
        res = @solve boardTemp, turnNum-1, pathesTemp
        return res if res isnt false

    false

  # 一色しかないかを確かめる
  @isSolvedBoard = (board)->
    colors = @board2colors board
    colors.length is 1

  # ノードを盤面に変換
  @node2board = (nodes)->
    # ノードを収めるのに必要な盤面
    nodeList = []
    for n in nodes
      for path in n.path
        nodeList.push path
    [xMax, yMax] = @getMaxInNode nodeList
    board = @getEmptyBoard xMax, yMax

    # 色で埋めていく
    for node in nodes
      for n in node.node
        [x, y] = n
        board[x][y] = node.color
    board
  # 色を抽出
  @board2colors = (board)->
    colors = []
    for b in board
      for color in b
        colors.push color unless colors.in_array color
    colors

  # ボードをノードに分割する
  @board2node = (board)->
    nodes = []
    xMax = board.length
    yMax = board[0].length

    # board走査
    boardCheck = @getEmptyBoard xMax, yMax
    for x in [0...xMax]
      for y in [0...yMax]
        # 値
        v = board[x][y]
        # もうノード化済み
        continue if boardCheck[x][y] is null
        # ノード化
        [_, boardCheck, pathes] = @checkNode(x, y, v, board, boardCheck)
        # ノードを保存
        res = 
          color : v
          path  : pathes
          link  : []
        nodes.push res

    for nIndex1 in [0...nodes.length]
      pathes1 = nodes[nIndex1].path
      for nIndex2 in [nIndex1+1...nodes.length]
        pathes2 = nodes[nIndex2].path
        if @isLink pathes1, pathes2
          nodes[nIndex1].link.push nIndex2
          nodes[nIndex2].link.push nIndex1
    nodes

  # ノード化再帰関数
  @checkNode = (x, y, v, board, boardCheck, pathes = [])->
    pathes.push [x, y]
    boardCheck[x][y] = null
    # 縦横
    for p in [[-1,0], [1,0],[0,-1],[0,1]]
      [plusX, plusY] = p
      continue if x+plusX < 0 or board.length <= x+plusX
      continue if y+plusY < 0 or board[0].length <= y+plusY
      continue if board[x+plusX][y+plusY] isnt v
      continue if boardCheck[x+plusX][y+plusY] is null
      [board, boardCheck, pathes] = @checkNode(x+plusX, y+plusY, v, board, boardCheck, pathes)
    [board, boardCheck, pathes]

  # ノードを収納する最小の盤面の縦横数を計算
  @getMaxInPath = (pathes)->
    xMax = 0
    yMax = 0
    for path in pathes
      [x, y] = path
      xMax = x if xMax < x
      yMax = y if yMax < y
    [xMax+1, yMax+1]

  @makeMap = (pathes)->
    [xMax, yMax] = @getMaxInPath(pathes)
    map = @getEmptyBoard(xMax, yMax)
    for path in pathes
      [x, y] = path
      map[x][y] = true
    map

  # ノードの繋がりを計測
  @isLink = (pathes1, pathes2)->
    map2 = @makeMap pathes2
    for path1 in pathes1
      [x, y] = path1
      for p in [[-1,0], [1,0],[0,-1],[0,1]]
        [plusX, plusY] = p
        continue if x+plusX < 0 or map2.length <= x+plusX
        continue if y+plusY < 0 or map2[0].length <= y+plusY
        return true if map2[x+plusX][y+plusY]
    false

  @getEmptyBoard = (xMax, yMax, value = false)->
    res = []
    for x in [0...xMax]
      res[x] = []
      for y in [0...yMax]
        res[x][y] = value
    res
  @printBoard = (board)->
    res = ''
    for x in board
      for y in x
        res += y
      res += "\n"
    console.log res

Array::in_array = (value)->
  for v in @
    return true if v is value
  false
Array::copy = ()->
  res = []
  for v in @
    res2 = []
    for v2 in v
      res2.push v2
    res.push res2
  res