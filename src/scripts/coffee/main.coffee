((global) ->

  class _GoBoard

    constructor: (@container, @container_size, @board_size) ->

      requirejs.config
        baseUrl: "scripts"
        urlArgs: "bust=" + (new Date()).getTime()
        paths:
          "domReady": "helper/domReady"
        shim:
          "app":
            exports: "_GoBoard"

      size = @size 
      container = @container
      board_size = @board_size

      require ["app", "domReady!"], (_GoBoard)->
        lol = new _GoBoard(container, container_size, board_size)
        return
      return
  if global.GoBoard
    throw new Error("GoBoard has already been defined")
  else
    global.GoBoard = _GoBoard
  return
)(if typeof window is "undefined" then this else window)
