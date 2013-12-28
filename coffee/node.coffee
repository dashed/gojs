requirejs = require('requirejs')

requirejs(['config', 'main'], (config, goban)->


    lol = goban(10)
    new goban()

    console.log lol
    # console.log Object.keys(lol)
    # console.log Object.keys(goban)
    # console.log lol.width()
    # console.log lol.length()

    # lol

    )