requirejs = require('requirejs')

requirejs(['config', 'goban', 'lodash'], (config, Goban, _)->


    # _.each(_.keys(goban), (key, val)->
    #     console.log goban[key]
    #     )


    # lol = Goban(1)

    lol = Goban()

    console.log lol.config
    # console.log Object.keys(new goban())
    # console.log Object.keys(goban())
    # console.log lol.width()
    # console.log lol.length()

    # lol

    )
