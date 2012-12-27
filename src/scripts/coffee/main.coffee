do () ->
  requirejs.config
    baseUrl: "scripts"
    urlArgs: "bust=" + (new Date()).getTime()
    
    shim:
      "app":
        exports: "_GoBoard"


  class _GoBoard

    constructor: (@container, @container_size, @board_size) ->

      size = @size 
      container = @container
      board_size = @board_size
      require ["app"], (_GoBoard)->
        lol = new _GoBoard(container, container_size, board_size)
        return
      return
  
  window.GoBoard = _GoBoard
  
