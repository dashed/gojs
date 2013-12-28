define ["./var/isInteger", "lodash"], (isInteger, _) ->

  class Goban

    @VERSION: '0.0.1'

    # Stone color constants
    EMPTY = 0
    BLACK = 1
    WHITE = 2


    constructor: (@length=19, @width) ->

        ###
        vars:
        - length
        - width
        - history
        - play_history
        - board_state
        - config
        ###

        ###
        1. no args:
            @length = @width = 19

        2. one arg (i.e. @length):
            @width = @length

        3. two arg: trivial
        ###

        # if @width === null then @width = @length
        @width ?= @length

        # Ensure param(s) is/are integer(s)
        if !isInteger(@length) then throw new Error("Second param of Goban (length) must be an integer")
        if !isInteger(@width) then throw new Error("First param of Goban (width) must be an integer")

        # Ensure param(s) is/are not zero
        if @length <= 0 then throw new Error("Second param of Goban (length) must be at least 1")
        if @width <= 0 then throw new Error("First param of Goban (width) must be at least 1")


        # set up config
        setupConfig()

        # Track changes to Goban
        @history = {}
        @play_history = []

        @board = []
        @board_state = {}

        # set up board
        n = @length * @width
        while n-- > 0
            @board.push(EMPTY)

        return

    # Set up config with default values
    setupConfig = () ->
        @config = {}

        # User defined stone values
        # Note: This isn't used internally.
        #       It's used for user fetching value of stone color at a position.
        @config['stone'] =
            'EMPTY': 'empty'
            'BLACK': 'black'
            'WHITE': 'white'
        return

    # merge config with current
    setConfig: (opts) ->
        @config = _.merge(@config, opts)
        return @

    getConfig: () ->
        return @config

    ###
    (x,y) is assumed to be relative to bottom-left corner.
    x and y are 0-based index.
    ###
    normalizeCoord = (x , y) ->
        # flip y and map to Math.abs(y-[@length-1])
        _y = y - (@length - 1)
        if(_y < 0) then _y *= -1
        return [x, _y]

    # get stone color of (x, y)
    # Returns: stone color defined in config.
    get: (x, y) ->
        ###
        length => cols
        width => rows
        ###
        [_x, _y] = normalizeCoord(x, y)

        color = @board[@length * _y + _x]

        switch color
            when EMPTY then return @config['stone']['EMPTY']
            when BLACK then return @config['stone']['BLACK']
            when WHITE then return @config['stone']['WHITE']
            else throw new Error("Goban.get(x,y) is broken!")

    # set stone color of (x, y) defined in config
    set: (color, x, y, callback) ->
        
        [_x, _y] = normalizeCoord(x, y)

        _color = undefined

        if (color is not @config['stone']['EMPTY'] and
        color is not @config['stone']['BLACK'] and
        color is not @config['stone']['WHITE'])
            throw new Error("Invalid color for Goban.set(x,y)")
        else
            _color = @config['stone']['EMPTY']

        # switch color
        #     when @config['stone']['EMPTY']
        #         _color = @config['stone']['EMPTY']
        #     when @config['stone']['BLACK']
        #         _color = @config['stone']['BLACK']
        #     when @config['stone']['WHITE']
        #         _color = @config['stone']['WHITE']
        #     else throw new Error("Invalid color for Goban.set(x,y)")

        callback()

        return @

    place: (color, x, y, callback) ->

        return @


  return Goban
