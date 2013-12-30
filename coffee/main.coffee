define ["./var/isInteger", "lodash", "async", "board", "coordinate"], (isInteger, _, async, Board, coordinate_trans) ->

  class Goban

    @VERSION: '0.1.0'

    # Stone color constants
    EMPTY = 0
    BLACK = 1
    WHITE = 2

    constructor: (@row=19, @col) ->

        ###
        vars:
        - row
        - col (rows)
        - history
        - play_history
        - board_state
        - config
        ###

        ###
        1. no args:
            @row = @col = 19

        2. one arg (i.e. @row):
            @col := @row

        3. two arg: trivial
        ###

        # if @col === null then @col = @row
        @col ?= @row

        # Ensure param(s) is/are integer(s)
        if !isInteger(@row) then throw new Error("First param of Goban (row) must be an integer")
        if !isInteger(@col) then throw new Error("Second param of Goban (col) must be an integer")

        # Ensure param(s) is/are not zero
        if @row <= 0 then throw new Error("First param of Goban (row) must be at least 1")
        if @col <= 0 then throw new Error("Second param of Goban (col) must be at least 1")


        # set up config
        setupConfig.call(@)

        # Track changes to Goban
        @history = {}
        @play_history = []

        @board = new Board(@row, @col, EMPTY)
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
    config: (opts = undefined)->

        if(opts is undefined)
            return @_config

        if(!_.isPlainObject(opts))
            throw new Error('Attempt to load Goban config that is not a plain object.')

        @_config = _.assign({}, @_config, opts)

        return @


    normalizeCoord = (first, second) ->

        coordinates = @_config['coordinate_system_transformations']
        coord_trans_func = coordinates[@_config['coordinate_system']]

        if(_.isFunction(coord_trans_func))

            data = {}
            data['row_bound'] = @row
            data['col_bound'] = @col

            func = _.bind(coord_trans_func, data, first, second)
            [row, col] = func()

            if(!isInteger(row) or !isInteger(col))
                throw new Error("Transformation via coordinate system '#{@_config['coordinate_system']}' failed.")

            return [row, col]
        else
            throw new Error('Invalid configuration property: "coordinate_system". Given #{@_config[\'coordinate_system\']}')

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

        if not (0 <= col < @col) or not (0 <= row < @row)
            throw new Error('Goban.get() parameter(s) is/are out of bounds.')

        color = @board.get(row, col)

        # convert to external color
        try
            return externalColor.call(@, color)
        catch error
            throw new Error("Goban.get(x,y) is broken!")



    # set stone color of (first, second) defined in config
    _set = (_color, first, second, callback, queue_callback) ->

        # construct attempt data
        attempt = {}
        attempt['color'] = _color
        attempt['coord'] = [first, second]

        err = undefined

        # validate color
        color = undefined

        # convert to internal color
        try
            color = internalColor.call(@, _color)
        catch error
            err = new Error("Invalid color for Goban.set(x,y). Given: #{_color}")

            _.defer(callback, err, attempt, null)
            return queue_callback()


        # normalize coord and validate
        row = col = undefined

        try
            [row, col] = normalizeCoord.call(@, first, second)
        catch error
            _.defer(callback, error, attempt, null)
            return queue_callback()


        if not (0 <= col < @col) or not (0 <= row < @row)
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
