requirejs = require('requirejs')

requirejs(['config', 'main'], (config, goban)->

    lol = new goban()

    console.log lol.size_width

    )