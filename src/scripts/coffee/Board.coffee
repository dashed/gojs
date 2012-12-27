define ["underscore"], (_) ->

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


    move: (_coord) ->

      _x = _coord[0]
      _y = _coord[1]
      point = @virtual_board[_x][_y]

      move_results = 
        color: @EMPTY
        x: _x
        y: _y

      if point is @EMPTY

        if @CURRENT_STONE is @BLACK

          @virtual_board[_x][_y] = @BLACK
          move_results.color = @BLACK
          @CURRENT_STONE = @WHITE

        else
          @virtual_board[_x][_y] = @WHITE
          move_results.color = @WHITE
          @CURRENT_STONE = @BLACK

      # return move results
      return move_results



  return Board