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

        # If @col === null then @col = @row
        @col ?= @row

        # Ensure param(s) is/are integer(s)
        if !isInteger(@row) then throw new Error("First param of Goban (row) must be an integer")
        if !isInteger(@col) then throw new Error("Second param of Goban (col) must be an integer")

        # Ensure param(s) is/are positive only
        if @row <= 0 then throw new Error("First param of Goban (row) must be at least 1")
        if @col <= 0 then throw new Error("Second param of Goban (col) must be at least 1")

        # Set up config
        setupConfig.call(@)

        # Track changes to Goban
        @history = {}
        @play_history = []

        @board = new Board(@row, @col, EMPTY)
        @board_state = {}


        # Create awesome queue
        worker = (_work, callback) ->
            _f = _work['f'] # Function to exec
            _this = _work['_this'] # Context
            _args = _work['_args'] or [] # An array
            _args.push(callback)

            _f.apply(_this, _args)

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

    # Merge config with current
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

    # Transform external color to internal
    internalColor = (external_color) ->

        switch external_color
            when @_config['stone']['EMPTY'] then return EMPTY
            when @_config['stone']['BLACK'] then return BLACK
            when @_config['stone']['WHITE'] then return WHITE
            else throw new Error("Invalid external color")

    # Transform internal color to external
    externalColor = (internal_color) ->

        switch internal_color
            when EMPTY then return @_config['stone']['EMPTY']
            when BLACK then return @_config['stone']['BLACK']
            when WHITE then return @_config['stone']['WHITE']
            else throw new Error("Invalid internal color")

    # Get stone color of (first, second)
    # Returns: stone color defined in config.
    get: (first, second) ->

        [row, col] = normalizeCoord.call(@, first, second)

        if not (0 <= col < @col) or not (0 <= row < @row)
            throw new Error('Goban.get() parameter(s) is/are out of bounds.')

        color = @board.get(row, col)

        # Convert to external color
        try
            return externalColor.call(@, color)
        catch error
            throw new Error("Goban.get(x, y) is broken!")

    # Set stone color of position (first, second) as defined in config
    _set = (_color=undefined, _first=undefined, _second=undefined, _callback=undefined, queue_callback) ->

        if _callback is undefined
            _callback = ->

        # Closure variables
        state = {}
        state['affected'] = undefined
        state['attempt'] = undefined
        state['callback'] = _callback
        state['color'] = _color
        state['first'] = _first
        state['second'] = _second
        state['queue_callback'] = queue_callback

        # Callback function for _callback
        _callback_f = (state, callback) =>
            __callback = state['callback']
            state['callback'] = _.compose(queue_callback, _callback)

            return callback(null, state)

        # Callback function for _color
        _color_f = (state, callback) =>

            _color = state['color']
            err = undefined

            if(_color is undefined)
                err = new Error("No color give for Goban.set()")

            callback(err, state)

        # Callback function for first/second
        _first_second_f = (state, callback) =>

            _first = state['first']
            _second = state['second']

            err = undefined

            if(_first is undefined or _second is undefined)
                err = new Error("Invalid coordinate for Goban.set()")

            return callback(err, state)

            # Construct data of attempted stone placement
        _stone_place_f = (state, callback) =>


            _color = state['color']

            attempt = {}
            attempt['color'] = _color
            attempt['coord'] = [state['first'], state['second']]

            state['attempt'] = attempt

            err = undefined
            color = undefined

            # Convert to internal color

            try
                state['internal_color'] = internalColor.call(@, _color)
            catch error
                err = new Error("Invalid color for Goban.set(). Given: #{_color}")

            return callback(err, state)

        # Normalize coord and validate
        _norm_coord_validate_f = (state, callback) =>


            state['row'] = state['col'] = undefined
            err = undefined

            try
                [row, col] = normalizeCoord.call(@, state['first'], state['second'])
                state['row'] = row
                state['col'] = col
            catch error
                callback(error, state)

            if not (0 <= col < @col) or not (0 <= row < @row)
                err = new Error('Goban.set() coord parameter(s) is/are out of bounds.')


            return callback(err, state)

            # Get old color
        _get_old_color_f = (state, callback) =>


            state['_old_color'] = @board.get(state['row'], state['col'])

            # console.log state['_old_color']

            state['ex_old_color'] = externalColor.call(@, state['_old_color'])

            return callback(undefined, state)

        # Change position's color
        _change_pos_f = (state, callback) =>


            @board.set(state['internal_color'], state['row'], state['col'])

            affected = {}
            affected[state['ex_old_color']] = {}
            affected[state['ex_old_color']][state['color']] = []
            affected[state['ex_old_color']][state['color']].push([state['first'], state['second']])

            state['affected'] = affected

            return callback(undefined, state)

        meta_function = _.bind((state, callback) =>
                # console.log callback
                # console.log state
                return callback(undefined, state)

            , @
            , state)

        meta_function2 = (callback___)->
            return callback___(undefined, state)


        waterfall_cb = (err, state)->
            return state['callback'](err, state['attempt'], state['affected'])

        async.waterfall([meta_function,
            _callback_f,
            _color_f,
            _first_second_f,
            _stone_place_f,
            _norm_coord_validate_f,
            _get_old_color_f,
            _change_pos_f], waterfall_cb)

        return

    set: (_color, first, second, callback) ->

        work_package =
            f: _set,
            _this: @
            _args: [_color, first, second, callback]


        @queue.push(work_package)
        return @

    _place = (_color=undefined, first=undefined, second=undefined, callback=undefined, queue_callback) ->

        # TODO

        return

    place: (_color, first, second, callback) ->

        work_package =
            f: _place,
            _this: @
            _args: [_color, first, second, callback]

        @queue.push(work_package)
        return @

  return Goban
