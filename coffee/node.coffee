requirejs = require('requirejs')

requirejs(['config', 'goban', 'lodash'], (config, goban, _)->


    # _.each(_.keys(goban), (key, val)->
    #     console.log goban[key]
    #     )


    # console.log
    console.log Object.keys(new goban())
    console.log Object.keys(goban())
    # console.log lol.width()
    # console.log lol.length()

    # lol

    )
