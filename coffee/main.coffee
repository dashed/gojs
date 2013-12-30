define ["./var/isInteger", "lodash", "async", "board", "coordinate"], (isInteger, _, async, Board, coordinate_trans) ->

  class Goban

    @VERSION: '0.1.0'

    # Stone color constants
    EMPTY = 0
    BLACK = 1
    WHITE = 2

    constructor: (@length=19, @width) ->

        ###
        vars:
        - length (cols)
        - width (rows)
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
        if !isInteger(@length) then throw new Error("First param of Goban (length) must be an integer")
        if !isInteger(@width) then throw new Error("Second param of Goban (width) must be an integer")

        # Ensure param(s) is/are not zero
        if @length <= 0 then throw new Error("First param of Goban (length) must be at least 1")
        if @width <= 0 then throw new Error("Second param of Goban (width) must be at least 1")


        # set up config
        setupConfig.call(@)

        # Track changes to Goban
        @history = {}
        @play_history = []

        @board = new Board(@length, @width, EMPTY)
        @board_state = {}


        # create awesome queue
        worker = (_work, callback) ->
            _f = _work['f'] # function to exec
            _this = _work['_this'] # context
            _args = _work['_args'] or [] # an array
            _args.push(callback)

            _f.apply(_this,_args)

        @queue = async.queue(worker, 1)

        return

    # Set up config with default values
    setupConfig = () ->
        _config = {}

        # User defined stone values
        # Note: This isn't used internally.
        #       It's used for user fetching value of stone color at a position.
        _config['stone'] =
            'EMPTY': 'empty'
            'BLACK': 'black'
            'WHITE': 'white'

        ###
        values: japanese, western, matrix, cartesian
        See: http://senseis.xmp.net/?Coordinates

        matrix: from top-left to bottom-right
        cartesian: from bottom-left to top-right

        ###
        _config['coordinate_system'] = 'cartesian_one'

        _config['coordinate_system_transformations'] = coordinate_trans

        @_config = _config
        return

    # merge config with current
    config: (opts)->

        if(!opts)
            return @_config

        if(!_.isPlainObject(opts))
            throw new Error('Attempt to load Goban config that is not a plain object.')

        @_config = _.assign({}, @_config, opts)

        return @

    getConfig: ->
        return @_config


    normalizeCoord = (first, second) ->

        coordinate = @config['coordinate_system_transformations']
        coord = coordinate[@config['coordinate_system']]

        if(_.isFunction(coord))

            data = {}
            data['row_bound'] = @width
            data['col_bound'] = @length

            func = _.bind(coord, data, first, second)
            [row, col] = func()

            if(!isInteger(row) or !isInteger(col))
                throw new Error("Transformation via coordinate system '#{@config['coordinate_system']}' failed.")

            return [row, col]
        else
            throw new Error('Invalid configuration property: "coordinate_system".')

    # transform external color to internal
    internalColor = (external_color) ->

        switch external_color
            when @_config['stone']['EMPTY'] then return EMPTY
            when @_config['stone']['BLACK'] then return BLACK
            when @_config['stone']['WHITE'] then return WHITE
            else throw new Error("Invalid external color")

    # transform internal color to external
    externalColor = (internal_color) ->

        switch internal_color
            when EMPTY then return @_config['stone']['EMPTY']
            when BLACK then return @_config['stone']['BLACK']
            when WHITE then return @_config['stone']['WHITE']
            else throw new Error("Invalid internal color")

    # get stone color of (first, second)
    # Returns: stone color defined in config.
    get: (first, second) ->

        [row, col] = normalizeCoord.call(@, first, second)

        if not (0 <= col <= (@length - 1)) or not (0 <= row <= (@width - 1))
            throw new Error('Goban.get() parameter(s) is/are out of bounds.')

        color = @board.get(row, col)

        # convert to external color
        try
            return external_color.call(@, color)
        catch error
            throw new Error("Goban.get(x,y) is broken!")



    # set stone color of (first, second) defined in config
    _set = (_color, first, second, callback, queue_callback) ->

        # validate color
        color = undefined

        # convert to internal color
        try
            color = internal_color.call(@, _color)
        catch error
            throw new Error("Invalid color for Goban.set(x,y)")


        # construct attempt data
        attempt = {}
        attempt['color'] = _color
        attempt['coord'] = [first, second]

        # normalize coord and validate
        [row, col] = normalizeCoord.call(@, first, second)

        err = undefined

        if not (0 <= col < @length) or not (0 <= row < @width)
            err = new Error('Goban.set() coord parameter(s) is/are out of bounds.')

            _.defer(callback, err, attempt, null)
            return queue_callback()

        # get old color
        _old_color = @board.get(row, col)
        ex_old_color = internal_color.call(@, _old_color)

        # change position's color
        @board.set(color, row, col)

        affected = {}
        affected[ex_old_color] = {}
        affected[ex_old_color][_color] = [first, second]

        _.defer(callback, err, attempt, affected)

        return queue_callback()

    set: (_color, first, second, callback) ->

        work_package =
            f: _set,
            _this: @
            _args: [_color, first, second, callback]

        @queue.push(work_package)
        return @

    place: (color, x, y, callback) ->

        return @


  return Goban
