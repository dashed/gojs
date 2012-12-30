define (require) ->

  $ = require('jquery')
  _ = require('underscore')
  BoardState = require('BoardState')

  class History

    constructor: (@starting_board_state) ->

      @EMPTY = 0
      @BLACK = 1
      @WHITE = 2

      # setup empty hashtable
      @history = {}

      # for backtracking
      @history_hash_order = []

      # add the starting board state
      @add(@starting_board_state, @EMPTY)

    getHashIndex: (n)->
      hash_index_size = @getNumBoardStates()
      if n >= 0 and n <= hash_index_size-1
        return @history_hash_order[n]
      return undefined

    getBoardState: (hash) ->
      return @history[hash]

    add: (raw_board_state, move_color) ->

      board_state = new BoardState(raw_board_state, move_color)
      hash = board_state.getHash()

      # add to history
      @history[hash] = board_state
      @history_hash_order.push(hash)

      return @

    getNumBoardStates: ()->
      return _.size(@history_hash_order)

    goBack: (n) ->
      # return board_state n moves ago
      if n >= 0
        hash_index_size = @getNumBoardStates()
        target_hash_index = @getHashIndex(hash_index_size-1-n)
        return @getBoardState(target_hash_index)
      return ([][1])


    difference: (_old_board_state, _new_board_state)->

      # metadata
      board_state_difference = {}
      board_state_difference.stones_removed = {}
      board_state_difference.stones_removed.WHITE = []
      board_state_difference.stones_removed.BLACK = []
      board_state_difference.stones_added = {}
      board_state_difference.stones_added.WHITE = []
      board_state_difference.stones_added.BLACK = []

      # get board_states
      old_board_state = _old_board_state.getBoardState()
      new_board_state = _new_board_state.getBoardState()

      # note: whenever you switch from one board_state to another, you always remove stones before adding!

      board_size = _.size(old_board_state)


      EMPTY = @EMPTY
      BLACK = @BLACK
      WHITE = @WHITE

      _.each _.range(board_size), (i) ->
        _.each _.range(board_size), (j) ->

          # addition of stones
          if old_board_state[i][j] is EMPTY
            if new_board_state[i][j] is BLACK
              board_state_difference.stones_added.BLACK.push([i,j])
            else if new_board_state[i][j] is WHITE
              board_state_difference.stones_added.WHITE.push([i,j])
          
          if old_board_state[i][j] is BLACK
            if new_board_state[i][j] is WHITE
              board_state_difference.stones_added.WHITE.push([i,j])
              board_state_difference.stones_removed.BLACK.push([i,j])
            else if new_board_state[i][j] is EMPTY
              board_state_difference.stones_removed.BLACK.push([i,j])

          if old_board_state[i][j] is WHITE
            if new_board_state[i][j] is BLACK
              board_state_difference.stones_added.BLACK.push([i,j])
              board_state_difference.stones_removed.WHITE.push([i,j])
            else if new_board_state[i][j] is EMPTY
              board_state_difference.stones_removed.WHITE.push([i,j])
      
      return board_state_difference

  return History

