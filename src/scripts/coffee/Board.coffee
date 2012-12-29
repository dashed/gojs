#define ["underscore", "jquery"], (_, $) ->
define (require) ->

  $ = require('jquery')
  _ = require('underscore')


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

    get_chain: (board_state, _coord) ->

      # get chain in a specific board_state

      # http://en.wikipedia.org/wiki/Rules_of_Go#Connected_stones_and_points
      # A chain is a set of one or more stones (necessarily of the same color) that are 
      # all connected to each other and that are not connected to any other stones. 

      # chain metadata (default on an empty coord)
      chain_info =
        liberties: {}
        chain_members: {}

      # current_color
      current_color = @get_color(board_state, _coord)

      # this coord doesn't fit criteria of a chain (which must be at least one stone)
      if current_color is @EMPTY
        return chain_info

      # use flood fill algorithm to find chain members and liberties
      # from http://lodev.org/cgtutor/floodfill.html#4-Way_Method_With_Stack

      # Deepcopy current board to flood fill
      virtual_board_clone = $.extend(true, [], board_state)

      # fill_color
      fill_color = @get_opposite_color(current_color)

      stack = []

      stack.push(_coord)

      # _coord itself is a chain
      chain_info.chain_members[_coord] = _coord

      # max 0-based index size
      virtual_board_size = @size - 1

      while _.size(stack) > 0
        popped_coord = stack.pop()
        x = popped_coord[0]
        y = popped_coord[1]

        @set_color(virtual_board_clone, popped_coord, fill_color)

        # get adjacent points
        adjacent_points = @get_adjacent_points(popped_coord)

        get_this = this
        _.each adjacent_points, (adjacent_point) ->

          # check if adjacent_point is part of the chain
          if get_this.get_color(virtual_board_clone, adjacent_point) is current_color
            stack.push(adjacent_point)
            chain_info.chain_members[adjacent_point] = adjacent_point

          # check if adjacent_point is empty
          if get_this.get_color(virtual_board_clone, adjacent_point) is get_this.EMPTY
            chain_info.liberties[adjacent_point] = adjacent_point


      return chain_info

    process_move: (_coord) ->

      # check if the move is legal

      # legal move metadata
      process_results = 
        legal: true
        dead: []
        board_state: @virtual_board

      # check if _coord is occupied
      if @get_color(@virtual_board, _coord) != @EMPTY
        process_results.legal = false
        return process_results

      # check if move is legal under ko rule
      # see: http://en.wikipedia.org/wiki/Rules_of_Go#Ko_and_Superko
      if _coord[0] is @KO_POINT[0] and _coord[1] is @KO_POINT[1]
        process_results.legal = false
        return process_results        


      # hypothetical board state
      # place the stone and see what happens
      virtual_board_clone = $.extend(true, [], @virtual_board)
      virtual_board_hypothetical= @set_color(virtual_board_clone, _coord, @CURRENT_STONE)

      # capture rule
      dead_stones = {}

      # get adjacent points
      adjacent_points = @get_adjacent_points(_coord)

      # check if adjacent points are occupied by enemy
      # if it is, check its chain and liberty count

      enemy_color = @get_opposite_color(@CURRENT_STONE)

      get_this = this
      _.each adjacent_points, (adjacent_point) ->

        # capture rule
        # Removing from the board any stones of the opponent's color that have no liberties.
        # see: http://en.wikipedia.org/wiki/Rules_of_Go#Capture
        if get_this.get_color(get_this.virtual_board, adjacent_point) is enemy_color
          chain_meta = get_this.get_chain(virtual_board_hypothetical, adjacent_point)
          
          # remove any dead enemy chains
          if _.size(chain_meta.liberties) is 0

            _.each chain_meta.chain_members, (member) ->
              # chain is dead
              dead_stones[member] = member

            # update
            # hypothetical board state
            # remove dead stones
            _.each dead_stones, (dead_stone) ->
              virtual_board_hypothetical = get_this.set_color(virtual_board_hypothetical, dead_stone, get_this.EMPTY)


      # self-capture rule
      # see: http://en.wikipedia.org/wiki/Rules_of_Go#Self-capture
      # (After playing his stone and capturing any opposing stones) a player removes from the board any stones of his own color that have no liberties.
      # disallow suicide
      chain_meta = @get_chain(virtual_board_hypothetical, _coord)
      if _.size(chain_meta.liberties) is 0
        virtual_board_hypothetical = @set_color(virtual_board_clone, _coord, @EMPTY)
        process_results.legal = false

      # add dead stones to process_results
      _.each dead_stones, (dead_stone) ->
        process_results.dead.push(dead_stone)

      # ko rule (positional superko)
      # 


      process_results.board_state = virtual_board_hypothetical

      return process_results

    move: (_coord) ->

      move_results = 
        color: @EMPTY
        x: _coord[0]
        y: _coord[1]
        dead: []

      # check if move is legal
      process_results = @process_move(_coord)
      move_results.dead = $.extend(true, [], process_results.dead)
      @virtual_board = process_results.board_state

      # put stone on board
      if process_results.legal is true

        # put stone on board
        move_results.color = @CURRENT_STONE
        @CURRENT_STONE = @get_opposite_color(@CURRENT_STONE)



      # update board state
      # TODO: track placement and removal of stones
      # TODO: dedicated history class?



      return move_results




  return Board