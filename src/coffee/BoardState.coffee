define (require) ->
  
  murmurhash3 = require('murmurhash3')

  class BoardState

    ###
    board state:
        move_color (who made the move in the board state)
            @BLACK or @WHITE
        stones_added:
            {WHITE:[collection of coords], BLACK:[collection of coords]}

        stones_removed:
            {WHITE:[collection of coords], BLACK:[collection of coords]}        
    ###
    
    constructor: (@board_state, @move_color) ->

      return @

    getBoardState: ()->
      return  @board_state

    getWhoMoved: () ->
      return @move_color

    getHash: () ->

      virtual_board_string = @board_state.toString()
      return murmurhash3.murmurhash3_32_gc(virtual_board_string, 1)
  return BoardState