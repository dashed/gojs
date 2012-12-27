requirejs.config
  baseUrl: "scripts"
  enforceDefine: true
  urlArgs: "bust=" + (new Date()).getTime()
  paths:
    "raphael": "libs/raphael/raphael.amd"
    "eve": "libs/raphael/eve"
    "raphael.core": "libs/raphael/raphael.core"
    "raphael.svg": "libs/raphael/raphael.svg"
    "raphael.vml": "libs/raphael/raphael.vml"
    "raphael.scale": "libs/raphael/raphael.scale"
    "domReady": "helper/domReady"
    "jquery": "http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min"
    "underscore": "libs/underscore-min"
    "Chain": "Chain"
    "Board": "Board"

  shim:
    raphael:
      exports: "Raphael"

    'raphael.scale':
      exports: "RaphaelScale"

    jquery:
      exports: "$"

    underscore:
      exports: "_"







define ["raphael.scale","raphael", "jquery", "underscore", "Board", "domReady!" ], (RaphaelScale,Raphael, $, _, Board) ->
  
  #This function is called once the DOM is ready.
  #It will be safe to query the DOM and manipulate
  #DOM nodes in this function.
  
  class _GoBoard

    constructor: (@container, @container_size, @board_size) ->

      @RAPH_BOARD_STATE = {} # track raphael ids


      if typeof @container != "string" or typeof(@container_size) != "number"
        return

      if typeof @board_size != "number" or @board_size > 19
        @board_size = 19


      @canvas = $("#"+ @container.toString())

      @draw_board()

    draw_board: () ->

      canvas = @canvas
      canvas.css('overflow', 'hidden')
      canvas.css('display', 'block')
      canvas.height(@)

      canvas = @canvas

      # fundamental variables
      n = @board_size # n X n board
      cell_radius = 25
      circle_radius = 0.50 * cell_radius

      text_size = 15 #pixels
      text_movement = cell_radius / 2 + text_size / 2 + 5
      text_buffer = text_size + cell_radius / 2 + 15

      canvas_length = cell_radius * (n - 1) + text_buffer * 2

      # Create canvas
      paper = Raphael(canvas[0], canvas_length, canvas_length)

      ###length = @container_size
      paper.changeSize(length,length, true, false)
      canvas.css('position', 'static')
      canvas.css('border', '1px solid black')
      canvas.height(length)
      canvas.width(length)###

      #paper.setViewBox(0,0,canvas_length,canvas_length)
      #paper.setSize($("#canvas").width(),$("#canvas").width())

      # measurement
      #paper.rect(0,0, canvas_length,canvas_length);

      
      # coord of top left of canvas
      y = text_buffer * 1 # top-left x
      x = y # top-left y
      
      # construct the board
      board_outline = paper.rect(x, y, cell_radius * (n - 1), cell_radius * (n - 1)).attr("stroke-width", 2)
      paper.rect(x, y, cell_radius * (n - 1), cell_radius * (n - 1)).attr "stroke-width", 1
      
      # text labels
      _.each _.range(n), (letter, index) ->
        letter = String.fromCharCode(65 + index)
        paper.text(x + cell_radius * (index), y + cell_radius * (n - 1) + text_movement, letter).attr "font-size", text_size
        paper.text(x + cell_radius * (index), y - text_movement, letter).attr "font-size", text_size

      _.each _.range(1, n + 1), (letter, index) ->
        paper.text(x - text_movement, y + cell_radius * (n - 1 - index), letter).attr "font-size", text_size
        paper.text(x + cell_radius * (n - 1) + text_movement, y + cell_radius * (n - 1 - index), letter).attr "font-size", text_size

      
      # construct lines
      i = 0

      while i < n - 2
        line_vert = paper.path("M" + (x + cell_radius * (i + 1)) + "," + (y + cell_radius * (n - 1)) + "V" + (y))
        line_horiz = paper.path("M" + x + "," + (y + cell_radius * (i + 1)) + "H" + (x + cell_radius * (n - 1)))
        i++
      
      # Star point markers (handicap markers)
      # See: http://senseis.xmp.net/?Hoshi
      do () ->
        generate_star = (_x, _y) ->
          handicap = paper.circle(x + cell_radius * _x, y + cell_radius * _y, 0.20 * circle_radius)
          handicap.attr "fill", "#000"

        if n is 19
          generate_star 3, 3
          generate_star 9, 3
          generate_star 15, 3
          generate_star 3, 9
          generate_star 9, 9
          generate_star 15, 9
          generate_star 3, 15
          generate_star 9, 15
          generate_star 15, 15
        else if n is 13
          generate_star 3, 3
          generate_star 9, 3
          generate_star 6, 6
          generate_star 3, 9
          generate_star 9, 9
        else if n is 9
          generate_star 2, 2
          generate_star 6, 2
          generate_star 4, 4
          generate_star 2, 6
          generate_star 6, 6
      

      # Populate with stones

      # tracks move made
      track_stone_pointer = null
      track_stone = (i, j) ->
        _x = x + cell_radius * i
        _y = y + cell_radius * j
        track_stone_pointer.remove()  if track_stone_pointer?
        track_stone_pointer = paper.circle(_x, _y, circle_radius / 2)
        track_stone_pointer.attr "stroke", "red"
        track_stone_pointer.attr "stroke-width", "2"

      white_stone = (i, j) ->
        _x = x + cell_radius * i
        _y = y + cell_radius * j
        
        stone_bg = paper.circle(_x, _y, circle_radius)
        stone_bg.attr "fill", "#fff"
        stone_bg.attr "stroke-width", "0"

        stone_fg = paper.circle(_x, _y, circle_radius)
        stone_fg.attr "fill", "r(0.75,0.75)#fff-#A0A0A0"
        stone_fg.attr "fill-opacity", 1
        stone_fg.attr "stroke-opacity", 0.3
        stone_fg.attr "stroke-width", "1.1"

        track_stone(i,j)

        group = []
        group.push stone_bg.id
        group.push stone_fg.id
        return group

        

      black_stone = (i, j) ->
        _x = x + cell_radius * i
        _y = y + cell_radius * j

        stone_bg = paper.circle(_x, _y, circle_radius)
        stone_bg.attr "fill", "#fff"
        stone_bg.attr "stroke-width", "0"

        stone_fg = paper.circle(_x, _y, circle_radius)
        stone_fg.attr "fill-opacity", 0.9
        stone_fg.attr "fill", "r(0.75,0.75)#A0A0A0-#000"
        stone_fg.attr "stroke-opacity", 0.3
        stone_fg.attr "stroke-width", "1.2"

        track_stone(i,j)

        group = []
        group.push stone_bg.id
        group.push stone_fg.id
        return group
      
      # Put stones on board if user has clicked
      group = paper.set()
      _.each _.range(n), (i, index) ->
        _.each _.range(n), (j, index) ->
          clicker = paper.rect(x - cell_radius / 2 + cell_radius * i, y - cell_radius / 2 + cell_radius * j, cell_radius, cell_radius)
          clicker.attr "fill", "#fff"
          clicker.attr "stroke-width", "0"
          clicker.attr "fill-opacity", 0
          clicker.data "coord", [i, j]
          group.push clicker

      get_this = this
      remove_stone = (coord) ->
        console.log coord
        _.each get_this.RAPH_BOARD_STATE[coord], (id) ->
          paper.getById(id).remove()

      
      # Replicate board in memory
      # this is a singleton instance
      virtual_board = new Board(n)

      
      get_this = this
      group.mouseover((e) ->
        coord = @data("coord")

      ).click (e) ->

        coord = @data("coord")

        move_results = virtual_board.move(coord)

        # remove_stones
        _.each move_results.dead, (dead_stone) ->
          remove_stone(dead_stone) 
         

        #console.log move_results.color

        switch move_results.color
          when virtual_board.BLACK
            raph_layer_ids = black_stone(move_results.x, move_results.y)

            get_this.RAPH_BOARD_STATE[coord] = raph_layer_ids
            
          when virtual_board.WHITE
            raph_layer_ids = white_stone(move_results.x, move_results.y)

            get_this.RAPH_BOARD_STATE[coord] = raph_layer_ids
            
          else
            # do nothing

        # move detect element to front to be clicked again
        this.toFront()
        return

  
      ###
      # Fill board with all stones 
     
      _.each _.range(0, n, 2), (i, index) ->
        _.each _.range(0, n, 2), (j, index) ->
          white_stone i, j


      _.each _.range(1, n, 2), (i, index) ->
        _.each _.range(1, n, 2), (j, index) ->
          white_stone i, j


      _.each _.range(1, n, 2), (i, index) ->
        _.each _.range(0, n, 2), (j, index) ->
          black_stone i, j


      _.each _.range(0, n, 2), (i, index) ->
        _.each _.range(1, n, 2), (j, index) ->
          black_stone i, j


      ###

      paper.safari()
      paper.renderfix()




      # Replaced by http://www.shapevent.com/scaleraphael/
      ###
      length = @container_size
      canvas.height(length)
      canvas.width(length)

      viewbox_length = canvas_length*canvas_length/canvas.width()
      paper.setViewBox(0, 0, viewbox_length*2, viewbox_length*2, true)
      paper.setSize(canvas_length*2,canvas_length*2)
      ###
      
      length = this.container_size;
      canvas.height(length);
      canvas.width(length);
      viewbox_length = canvas_length * canvas_length / canvas.width();
      paper.setViewBox(0, 0, canvas_length, canvas_length, false);
      paper.setSize(length, length);

      return _GoBoard


