define ["underscore"], (_) ->

  class Chain
    constructor: (@stones, @liberties) ->
      # rawr

    get_liberties: ()->
      return @liberties

    in_atari: ()->
      return _.size(@liberties) is 1

    get_stones: ()->
      return @stones

