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

      

      ###
      setTimeout (->
        require ["app"], (_GoBoard)->
          get_this.lol = new _GoBoard(container, container_size, board_size)
      ), 0
      ###
      get_this = this
      require ["app"], (_GoBoard)->
        get_this.go_board = new _GoBoard(container, container_size, board_size)
      return @go_board
      

  if global.GoBoard
    throw new Error("GoBoard has already been defined")
  else
    global.GoBoard = _GoBoard
  return
  # see: https://github.com/shichuan/javascript-patterns/blob/master/general-patterns/access-to-global-object.html
  #)(if typeof window is "undefined" then this else window)
)(this or (1
eval_
)("this"))
