#define ["underscore", "jquery"], (_, $) ->
define (require) ->

  $ = require('jquery')
  _ = require('underscore')
  History = require('History')
  BoardState = require('BoardState')

  class Board

    # class variables
    @EMPTY: 0
    @BLACK: 1
    @WHITE: 2

    isNumber: (n) ->
      return !isNaN(parseFloat(n)) && isFinite(n)

    constructor: (@size, @CURRENT_STONE) ->

      @EMPTY = 0
      @BLACK = 1
      @WHITE = 2
      #CURRENT_STONE defines whose turn it is
      #@CURRENT_STONE = @BLACK

      # repetition rule constants
      @KR = 0 # one stone ko rule (non-superko)
      @PSK = 1 # positional superko
      @SSK = 2 # situational superko
      #@NSSK = 3 # natural superko

      @REPETITION_RULE = @SSK

      if !@isNumber(@size)
        @size = 0



      # create virtual board      
      get_this = this
      @virtual_board = new Array(@size)
      _.each _.range(@size), (i) ->
        get_this.virtual_board[i] = new Array(get_this.size)
        _.each _.range(get_this.size), (j) ->
          get_this.virtual_board[i][j] = get_this.EMPTY


      # initialize History
      @history = new History(@virtual_board)

      return

    set_starting_board_state: (@CURRENT_STONE) ->
      # use current board_state as move 0
      # this is used after placement of stones
      if moo? is true and (@CURRENT_STONE is @BLACK or @CURRENT_STONE is @WHITE)
        @history = new History(@virtual_board)
        return true
      return false


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

        virtual_board_clone = @set_color(virtual_board_clone, popped_coord, fill_color)

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

    check_ko_rule: () ->
      # Ko rule: One may not capture just one stone, if that stone was played on the previous move, and that move also captured just one stone.

      # need at least 2 board states for this rule
      num_board_states = @history.getNumBoardStates()
      if _.size(dead_stones) is 1 and num_board_states >= 2

        current_board_state = @history.goBack(0)
        previous_board_state = @history.goBack(1)

        board_state_difference = @history.difference(previous_board_state,current_board_state)

        # get stone being captured
        key = _.keys(dead_stones)
        stone_being_captured = dead_stones[key[0]]
        stone_being_captured_color = @virtual_board[stone_being_captured[0]][stone_being_captured[1]]

        # check if stone being captured was played on the previous move
        stones_added = []
        if stone_being_captured_color is @BLACK
          stones_added = board_state_difference.stones_added.BLACK
        else if stone_being_captured_color is @WHITE
          stones_added = board_state_difference.stones_added.WHITE

        # check if stone being captured also captured just one stone
        truth_test = _.find stones_added, (coord) ->
          coord[0] is stone_being_captured[0] and coord[1] is stone_being_captured[1]

        if truth_test
          if (_.size(board_state_difference.stones_removed.BLACK) + _.size(board_state_difference.stones_removed.WHITE)) is 1
            # ko rule violated
            console.log "ko rule violated"
            return false
          else
            return true

      # default return
      return true

    check_psk: (virtual_board_hypothetical) ->
      # Positional superko:  The hypothetical board position of the attempted move shouldn't be the same as any of the previous board states

      # get hash of hypothetical board state
      hypothetical_board_state = new BoardState(virtual_board_hypothetical, @CURRENT_STONE)
      hypothetical_board_state_hash = hypothetical_board_state.getHash()
      
      if @isNumber(@history.getBoardState(hypothetical_board_state_hash)?.getHash())
        # PSK rule violated
        return false

      # default return
      return true

    # situational superko: A player may not play a stone so as to create a board position which existed previously in the game, 
    # and in which it was the opponent's turn to move next. 
    # 
    # A player may not recreate a board position he/she has created
    check_ssk: (virtual_board_hypothetical) ->

      # get hash of hypothetical board state
      hypothetical_board_state = new BoardState(virtual_board_hypothetical, @CURRENT_STONE)
      hypothetical_board_state_hash = hypothetical_board_state.getHash()
      
      # see if hypothetical board state already exists
      board_state_test = @history.getBoardState(hypothetical_board_state_hash)
      board_state_test_hash = board_state_test?.getHash()

      if @isNumber(board_state_test_hash) 

        # check if it was the opponent's turn to move next
        board_state_test_hash_index = _.lastIndexOf(@history.history_hash_order, board_state_test_hash)
        board_state_test_next = @history.getBoardStateFromIndex(board_state_test_hash_index+1)
        if board_state_test_next?.getWhoMoved() is @get_opposite_color(@CURRENT_STONE)
          # SSK rule violated
          return false
        else
          return true

      # default return
      return true


    process_pass: () ->

      process_results =
        legal: true

      return process_results

    # process a placement of stone
    process_move: (_coord) ->

      # check if the move is legal

      # process_results metadata
      process_results = 
        legal: true
        dead: []
        board_state: @virtual_board

      # check if _coord is occupied
      if @get_color(@virtual_board, _coord) != @EMPTY
        process_results.legal = false
        return process_results


      # hypothetical board state
      # place the stone and see what happens
      virtual_board_clone = $.extend(true, [], @virtual_board)


      ###
      start board play logic
      ###


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

            # update hypothetical board state
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

      ###
      end board play logic
      ###

      # if move is still legal, check superko
      if process_results.legal == true

        # check if move is legal under ko & superko rule
        # see: http://en.wikipedia.org/wiki/Rules_of_Go#Ko_and_Superko

        if @REPETITION_RULE is @KR
          if @check_ko_rule() == false
            process_results.legal = false

        # Positional superko:  The hypothetical board position of the attempted move shouldn't be the same as any of the previous board states
        if @REPETITION_RULE is @PSK

          if @check_psk(virtual_board_hypothetical) == false
            process_results.legal = false

          if process_results.legal == false
            console.log "PSK violated at " + _coord

        # situational superko: A player may not play a stone so as to create a board position which existed previously in the game, 
        # and in which it was the opponent's turn to move next. 
        # 
        # A player may not recreate a board position he/she has created
        if @REPETITION_RULE is @SSK

          if @check_ssk(virtual_board_hypothetical) == false
            process_results.legal = false


          if process_results.legal == false
            console.log "SSK violated at " + _coord


        if @REPETITION_RULE is @NSSK
          1+1
          # passing must be implemented



      # add dead stones to process_results (if move is still legal)
      if process_results.legal is true
        _.each dead_stones, (dead_stone) ->
          process_results.dead.push(dead_stone)


      process_results.board_state = virtual_board_hypothetical

      return process_results


    # for board setup purposes (not actual moves made by a player)
    place: (_coord, _color) ->

      place_results = 
        color: @EMPTY
        x: _coord[0]
        y: _coord[1]



      if @get_color(@virtual_board, _coord) != @EMPTY
        return place_results
      else if _color is @BLACK or _color is @WHITE
        @virtual_board = @set_color(@virtual_board, _coord, _color)
        place_results.color = _color

      return place_results

    # A move is either a pass play or a board play.
    # defined in http://home.snafu.de/jasiek/superko.html

    # pass play
    pass: () ->
      pass_results = 
        # color that is doing the passing
        color: @EMPTY
        legal: false

      process_results = @process_pass()

      return pass_results

    # board play
    move: (_coord) ->

      move_results = 
        # color making the move
        color: @EMPTY
        x: _coord[0]
        y: _coord[1]
        dead: []


      # check if move is legal
      process_results = @process_move(_coord)
      move_results.dead = $.extend(true, [], process_results.dead)

    
      # put stone on board
      if process_results.legal is true

        # update board state
        @virtual_board = process_results.board_state

        # add to history
        @history.add(@virtual_board, @CURRENT_STONE)

        # put stone on board
        move_results.color = @CURRENT_STONE

        # switch to opponent's turn
        @CURRENT_STONE = @get_opposite_color(@CURRENT_STONE)



      # update board state
      # TODO: track placement and removal of stones
      # TODO: dedicated history class?



      return move_results




  return Board