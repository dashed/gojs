define ["main", "lodash"], (Goban, _) ->
    ###
    Goban(...) instead of new Goban(...)
    But either is possible.
    ###
    factory = (length, width) ->
        return new Goban(length, width)

    # Emulate properties
    _.each(_.keys(Goban), (key)->
        factory[key] = Goban[key]
        return
        )

    return factory
