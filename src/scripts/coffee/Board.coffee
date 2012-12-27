define ["underscore", "jquery", "Chain"], (_, $, Chain) ->

  # The publicly accessible Singleton fetcher
  class Board
    _instance = undefined # Must be declared here to force the closure on the class
    @get: (size) -> # Must be a static method
      _instance ?= new _Board size

  # The actual Singleton class
  class _Board

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

    get_neighbors: (_point) ->

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

    get_chain_points: (_virtual_board, point) ->

      # object of form stones[point] = point
      stones = {}
      stones[point] = point


      my_color = @get_color(_virtual_board, point)

      flood_fill_color = @get_opposite_color(my_color)

      _virtual_board = @set_color(_virtual_board, point, flood_fill_color)

      get_this = this
      _.each @get_neighbors(point), (neighbor)->


        n_color = get_this.get_color(_virtual_board, point)


        if (n_color is my_color)
          if !(_.contains(_.keys(stones), neighbor.toString()))

            _.each get_this.get_chain_points(_virtual_board, neighbor), (_neighbor) ->
              stones[_neighbor] = _neighbor

      return stones



    # returns Chain class
    get_chain: (_virtual_board, point) ->

      # Deepcopy _virtual_board
      virtual_board_clone = $.extend(true, [], _virtual_board)

      # stones is object of stone[point] = point
      stones = @get_chain_points(virtual_board_clone, point)

      # object of form liberties[point] = point
      liberties = {}

      get_this = this
      _.each stones, (stone) ->
        _.each get_this.get_neighbors(stone), (point) ->

          if get_this.get_color(_virtual_board, point) is get_this.EMPTY
            liberties[point] = point
            

      #console.log liberties
      return new Chain(stones, liberties)


    move: (_coord) ->

      capturedStones = {}

      # Deepcopy current board
      virtual_board_clone = $.extend(true, [], @virtual_board)

      _x = _coord[0]
      _y = _coord[1]
      point_color = @get_color(virtual_board_clone, _coord)


      move_results = 
        color: @EMPTY
        x: _x
        y: _y
        dead: []


      if (_x is @KO_POINT[0] && _y is @KO_POINT[1])
        return move_results


      # Is the point already occupied?
      if point_color is @EMPTY

        # is the move suicide?
        suicide = true
        get_this = this
        _.each @get_neighbors(_coord), (neighbor) ->

          n_color = get_this.get_color(virtual_board_clone, neighbor)

          # if any neighbor is VACANT, suicide = false
          if (n_color is get_this.EMPTY)
            suicide = false

          # if any neighbor is an ally that isn't in atari
          else if n_color is get_this.CURRENT_STONE
            if !get_this.get_chain(virtual_board_clone, neighbor).in_atari()
              suicide = false

          # if any neighbor is an enemy and that enemy is in atari
          else if n_color is get_this.get_opposite_color(get_this.CURRENT_STONE)

            enemy = get_this.get_chain(virtual_board_clone, neighbor)

              
            if(enemy.in_atari())
              suicide = false

              # remove the enemy stones from the board
              _.each enemy.get_stones(), (stone) ->
                get_this.set_color(virtual_board_clone,stone, get_this.EMPTY)
                capturedStones[stone] = stone
                move_results.dead.push stone
                

        if suicide
          return move_results

        # If the point is not occupied, the move is not ko, and not suicide
        # it is a legal move.
        if @CURRENT_STONE is @BLACK

          virtual_board_clone = @set_color(virtual_board_clone, _coord, @BLACK)
          move_results.color = @BLACK
          @CURRENT_STONE = @WHITE

        else
          virtual_board_clone = @set_color(virtual_board_clone, _coord, @WHITE)
          move_results.color = @WHITE
          @CURRENT_STONE = @BLACK

        # If this move captured exactly one stone, that stone is the new ko point
        if _.size(capturedStones) is 1
          @KO_POINT = capturedStones[_.keys(capturedStones)[0]]
        else
          @KO_POINT = []

        # update board state
        @virtual_board = virtual_board_clone


      # return move results

      return move_results



  return Board