define ["underscore", "jquery", "Chain"], (_, $, Chain) ->

  # The actual Singleton class
  class Board

    # class variables
    @EMPTY: 0
    @BLACK: 1
    @WHITE: 2
    @CURRENT_STONE: @BLACK

    constructor: (@size) ->

      @EMPTY = 0
      @BLACK = 1
      @WHITE = 2
      @CURRENT_STONE = @BLACK
      @KO_POINT = []

      if typeof @size != "number"
        @size = 0


      # create virtual board      
      get_this = this
      @virtual_board = new Array(@size)
      _.each _.range(@size), (i) ->
        get_this.virtual_board[i] = new Array(get_this.size)
        _.each _.range(get_this.size), (j) ->
          get_this.virtual_board[i][j] = get_this.EMPTY

      return

    get_adjacent_points: (_point) ->

      _x = _point[0]
      _y = _point[1]

      neighbours = []
      neighbours.push [_x - 1, _y]  if _x > 0
      neighbours.push [_x + 1, _y]  if _x < @size - 1
      neighbours.push [_x, _y - 1]  if _y > 0
      neighbours.push [_x, _y + 1]  if _y < @size - 1
      return neighbours

    get_color: (_virtual_board, point) ->

      n_x = point[0]
      n_y = point[1]
      return _virtual_board[n_x][n_y]

    set_color: (_virtual_board, point, _color) ->

      n_x = point[0]
      n_y = point[1]
      _virtual_board[n_x][n_y] = _color
      return _virtual_board

    get_opposite_color: (_color) ->

      # Switch to an opposite colour
      _color_opp = @EMPTY
      switch _color
        when @EMPTY
          _color_opp = @EMPTY
        when @WHITE
          _color_opp = @BLACK
        when @BLACK
          _color_opp = @WHITE
        else
          _color_opp = @EMPTY
      return _color_opp

    get_chain: (_coord) ->

      chain_info =
        liberties: {}
        chain_members: {}

      # current_color
      current_color = @get_color(@virtual_board, _coord)

      # this coord isn't part of a chain
      if current_color is @EMPTY
        return chain_info

      # fill_color
      fill_color = @get_opposite_color(_coord)

      # Deepcopy current board
      virtual_board_clone = $.extend(true, [], @virtual_board)

      # continue from http://lodev.org/cgtutor/floodfill.html#4-Way_Method_With_Stack

      return

    is_move_legal: (_coord) ->

      # check if the move is legal

      # get adjacent points
      adjacent_points = @get_adjacent_points(_coord)

      # check if adjacent points are occupied by enemy
      # if it is, check its chain and liberty count
      get_this = this
      _.each adjacent_points, (adjacent_point) ->
        get_this.get_chain(adjacent_point)

      legal_results = 
        legal: true
        dead: []

      return legal_results

    move: (_coord) ->

      move_results = 
        color: @EMPTY
        x: _coord[0]
        y: _coord[1]
        dead: []

      # check if move is legal
      legal_results = @is_move_legal(_coord)

      if legal_results.legal is true
        move_results.dead = $.extend(true, [], legal_results.dead)
      else
        return move_results

      point_color = @get_color(@virtual_board, _coord)

      # update board state
      # TODO: track placement and removal of stones
      # TODO: dedicated history class?

      if point_color is @EMPTY
        if @CURRENT_STONE is @BLACK

          @virtual_board = @set_color(@virtual_board, _coord, @BLACK)
          move_results.color = @BLACK
          @CURRENT_STONE = @WHITE

        else
          @virtual_board = @set_color(@virtual_board, _coord, @WHITE)
          move_results.color = @WHITE
          @CURRENT_STONE = @BLACK


      return move_results




  return Board