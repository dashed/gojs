requirejs = require('requirejs')

requirejs(['config', 'main'], (config, goban)->

    lol = new goban(10)

    console.log lol

    )