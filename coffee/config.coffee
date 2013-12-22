requirejs.config
    enforceDefine: false
    skipDataMain: true

    # Doesn't work for node.js
    # urlArgs: 'bust=' + (new Date()).getTime()

    paths:
        'lodash': 'libs/lodash.compat'
