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
    "domReady": "helper/domReady"
    "jquery": "http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min"
    "underscore": "libs/underscore-min"
    "Chain": "Chain",
    "Board": "Board"

  shim:
    raphael:
      exports: "Raphael"

    jquery:
      exports: "$"

    underscore:
      exports: "_"




define ["raphael", "jquery", "underscore", "Chain", "Board", "domReady!", ], (Raphael, $, _, Chain, Board) ->
  
  #This function is called once the DOM is ready.
  #It will be safe to query the DOM and manipulate
  #DOM nodes in this function.
  $("#canvas").html "l"
  range = (start, end, step) ->
    range = []
    typeofStart = typeof start
    typeofEnd = typeof end
    throw TypeError("Step cannot be zero.")  if step is 0
    if typeofStart is "undefined" or typeofEnd is "undefined"
      throw TypeError("Must pass start and end arguments.")
    else throw TypeError("Start and end arguments must be of same type.")  unless typeofStart is typeofEnd
    typeof step is "undefined" and (step = 1)
    step = -step  if end < start
    if typeofStart is "number"
      while (if step > 0 then end >= start else end <= start)
        range.push start
        start += step
    else if typeofStart is "string"
      throw TypeError("Only strings with one character are supported.")  if start.length isnt 1 or end.length isnt 1
      start = start.charCodeAt(0)
      end = end.charCodeAt(0)
      while (if step > 0 then end >= start else end <= start)
        range.push String.fromCharCode(start)
        start += step
    else
      throw TypeError("Only string and number types are supported")
    range

  
  # measurement
  #paper.rect(0,0, raph_x,raph_x);
  cell_radius = 25
  n = 19 # n X n board
  text_size = 15 #pixels
  text_buffer = text_size + cell_radius / 2 + 10
  text_movement = cell_radius / 2 + text_size / 2 + 5
  raph_x = cell_radius * (n - 1) + text_buffer * 2
  paper = Raphael(25, 25, raph_x, raph_x)
  circle_radius = 0.50 * cell_radius
  
  # marks top-left point 
  y = text_buffer * 1 # top-left x
  x = y # top-left y
  
  # construct the board
  board_outline = paper.rect(x, y, cell_radius * (n - 1), cell_radius * (n - 1)).attr("stroke-width", 1)
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
  (->
    generate_star = (_x, _y) ->
      handicap = paper.circle(x + cell_radius * _x, y + cell_radius * _y, 0.15 * circle_radius)
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
  )()
  
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

  black_stone = (i, j) ->
    _x = x + cell_radius * i
    _y = y + cell_radius * j
    stone_bg = paper.circle(_x, _y, circle_radius)
    stone_bg.attr "fill", "#fff"
    stone_bg.attr "stroke-width", "0"

    stone_fg = paper.circle(_x, _y, circle_radius)
    stone_fg.attr "fill-opacity", 0.9
    stone_fg.attr "fill", "r(0.75,0.75)#A0A0A0-#000"
    stone_fg.attr "stroke-width", "1.2"

    track_stone(i,j)

  


  
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


  
  # Replicate board in memory
  virtual_board = new Board.get(n)

  
  #console.log(get_neighbours(coord[0], coord[1]));
  group.mouseover((e) ->
    coord = @data("coord")
  ).click (e) ->
    coord = @data("coord")

    move_results = virtual_board.move(coord)

    #console.log move_results.color

    switch move_results.color
      when virtual_board.BLACK
        raph_layer_ids = black_stone(move_results.x, move_results.y)
        
      when virtual_board.WHITE
        raph_layer_ids = white_stone(move_results.x, move_results.y)
        
      else
        # do nothing

    # move detect element to front to be clicked again
    this.toFront()
    return

  

  #
  # 
  # _.each(range(0, n-1,2), function(i, index) {
  #   _.each(range(0, n-1,2), function(j, index) {
  #
  #     white_stone(i, j);
  #     
  #   });
  # });
  #
  # _.each(range(1, n-1,2), function(i, index) {
  #   _.each(range(1, n-1,2), function(j, index) {
  #
  #     white_stone(i, j);
  # 
  #   });
  # });
  #
  #
  # _.each(range(1, n-1,2), function(i, index) {
  #   _.each(range(0, n-1,2), function(j, index) {
  #
  #     black_stone(i,j);
  #   });
  # });
  # _.each(range(0, n-1,2), function(i, index) {
  #   _.each(range(1, n-1,2), function(j, index) {
  #
  #     black_stone(i,j);
  #   });
  # });
  #
  paper.safari()
  paper.renderfix()

