define (require) ->
  
  #This function is called once the DOM is ready.
  #It will be safe to query the DOM and manipulate
  #DOM nodes in this function.

  class _GoBoard

    VERSION: '0.1'


    constructor: (@container, @container_size, @board_size) ->

      # validate params

      isNumber = (n) ->
        return !isNaN(parseFloat(n)) && isFinite(n)

      _ = require('underscore')

      if !_.isString(@container) or !isNumber(@container_size) or !isNumber(@board_size)
        return

      $ = require('jquery')
      @canvas = $('#'+ @container.toString())

      # check if canvas exists
      if @canvas.length is 0
        return

      if @container_size <= 0
        return

      if @board_size > 19
        @board_size = 19

      if @board_size <= 1
        return

      # Render go board

      @RAPH_BOARD_STATE = {} # track raphael ids

      Raphael = require('raphael')

      canvas = @canvas.html('')

      spanner = $('<span style="display: block; text-align: center;">').appendTo(canvas)

      $('<button value="|<">|<</button>').click((e)->
        console.log "click!"
      ).appendTo(spanner)

      $('<button value="<"><</button>').click((e)->
        console.log "click!"
      ).appendTo(spanner)

      $('<button value=">">></button>').click((e)->
        console.log "click!"
      ).appendTo(spanner)

      $('<button value=">|">>|</button>').click((e)->
        console.log "click!"
      ).appendTo(spanner)

      $('<div>Black to move</div>').appendTo(spanner)

      #canvas.css('overflow', 'hidden')
      canvas.css('border', '1px solid black')

      if !$.support.inlineBlockNeedsLayout
        canvas.css('display', 'inline-block')

      # IE6/7
      # see: http://stackoverflow.com/questions/6478876/how-do-you-mix-jquery-and-ie-css-hacks
      else
        canvas.css('display', 'inline').css('zoom', '1')
      #canvas.css('display', 'block')
      

      # fundamental variables
      n = @board_size # n X n board
      cell_radius = 25
      circle_radius = 0.50 * cell_radius

      text_size = 15 #pixels
      text_buffer = text_size + cell_radius / 2 + 15
      text_movement = text_buffer/2 +5
      # cell_radius / 2 + text_size / 2 + 5
      

      canvas_length = cell_radius * (n - 1) + text_buffer * 2

      # Create canvas
      paper = Raphael(canvas[0], canvas_length, canvas_length)

      
      # coord of top left of canvas
      y = text_buffer * 1 # top-left x
      x = text_buffer # top-left y
      
      # construct the board
      board_outline = paper.rect(x, y, cell_radius * (n - 1), cell_radius * (n - 1)).attr('stroke-width', 2)
      paper.rect(x, y, cell_radius * (n - 1), cell_radius * (n - 1)).attr 'stroke-width', 1      

      # Star point markers (handicap markers)
      # See: http://senseis.xmp.net/?Hoshi
      do () ->
        generate_star = (_x, _y) ->
          handicap = paper.circle(x + cell_radius * _x, y + cell_radius * _y, 0.20 * circle_radius).attr 'fill', '#000'

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


      # draw lines and coordinate labels
      stone_click_detect = paper.set()
      #_.each _.range(n), (index) ->
      index = 0
      while index < n

        i = index

        # construct lines
        # ignore outlines
        if index < n - 1 
          
          line_vert = paper.path('M' + (x + cell_radius * (i + 1)) + ',' + (y + cell_radius * (n - 1)) + 'V' + (y))
          line_horiz = paper.path('M' + x + ',' + (y + cell_radius * (i + 1)) + 'H' + (x + cell_radius * (n - 1)))

        # Alphabet
        letter = String.fromCharCode(65 + index)
        paper.text(x + cell_radius * (index), y + cell_radius * (n - 1) + text_movement, letter).attr 'font-size', text_size
        paper.text(x + cell_radius * (index), y - text_movement, letter).attr 'font-size', text_size

        # Numbers
        paper.text(x - text_movement, y + cell_radius * (n - 1 - index), index+1).attr 'font-size', text_size
        paper.text(x + cell_radius * (n - 1) + text_movement, y + cell_radius * (n - 1 - index), index+1).attr 'font-size', text_size

        # Place click detectors

        #_.each _.range(n), (j) ->
        j = 0
        while j < n
          clicker = paper.rect(x - cell_radius / 2 + cell_radius * i, y - cell_radius / 2 + cell_radius * j, cell_radius, cell_radius)
          clicker.attr('fill', '#fff').attr('fill-opacity', 0).attr('opacity', 0).attr('stroke-width', 0).attr('stroke', '#fff').attr('stroke-opacity', 0)
          
          clicker.data('coord', [i, (@board_size-1)-j])
          stone_click_detect.push clicker
          j++

        index++

      # Put stones on board if user has clicked
      ###
      _.each _.range(n), (i, index) ->
        _.each _.range(n), (j, index) ->
          clicker = paper.rect(x - cell_radius / 2 + cell_radius * i, y - cell_radius / 2 + cell_radius * j, cell_radius, cell_radius)
          clicker.attr 'fill', '#fff'
          clicker.attr 'fill-opacity', 0
          clicker.attr 'opacity', 0
          clicker.attr 'stroke-width', 0
          clicker.attr 'stroke', '#fff'
          clicker.attr 'stroke-opacity', 0
          clicker.data 'coord', [i, j]
          stone_click_detect.push clicker
      ###

      

      # Populate with stones

      # tracks move made
      get_this = this
      track_stone_pointer = null
      track_stone = (i, j) ->
        _x = x + cell_radius * i
        #_y = y + cell_radius * j
        _y = y + cell_radius * ((get_this.board_size-1)-j)
        track_stone_pointer.remove()  if track_stone_pointer?
        track_stone_pointer = paper.circle(_x, _y, circle_radius / 2)
        track_stone_pointer.attr 'stroke', 'red'
        track_stone_pointer.attr 'stroke-width', '2'

      get_this = this
      white_stone = (i, j) ->
        _x = x + cell_radius * i
        # _y = y + cell_radius * j
        _y = y + cell_radius * ((get_this.board_size-1)-j)
        
        stone_bg = paper.circle(_x, _y, circle_radius)
        stone_bg.attr 'fill', '#fff'
        stone_bg.attr 'stroke-width', '0'

        stone_fg = paper.circle(_x, _y, circle_radius)
        stone_fg.attr 'fill', 'r(0.75,0.75)#fff-#A0A0A0'
        stone_fg.attr 'fill-opacity', 1
        stone_fg.attr 'stroke-opacity', 0.3
        stone_fg.attr 'stroke-width', '1.1'

        track_stone(i,j)

        ###
        # triangle
        circle_radius_t = circle_radius*0.85
        a = (circle_radius_t*3)/Math.sqrt(3)
        height = Math.sqrt(3)*a/2
        #C = _x, circle_radius
        #B = _x + a/2, _y - (height - circle_radius)
        #A = _x - a/2, _y - (height - circle_radius)
        A = [_x - a/2, _y+(height - circle_radius_t)]
        B = [_x + a/2, _y+(height - circle_radius_t)]
        C = [_x, _y-circle_radius_t]
        
        # AC
        lol = paper.path('M'+A[0]+' '+A[1]+'L'+C[0]+' '+C[1]).toFront()
        
        # CB

        paper.path('M'+C[0]+' '+C[1]+'L'+B[0]+' '+B[1]).toFront()

        # BA
        paper.path('M'+B[0]+' '+B[1]+'L'+A[0]+' '+A[1]).toFront()

        ###
        group = []
        group.push stone_bg.id
        group.push stone_fg.id
        return group

        
      get_this = this
      black_stone = (i, j) ->
        _x = x + cell_radius * i
        #_y = y + cell_radius * j
        _y = y + cell_radius * ((get_this.board_size-1)-j)



        stone_bg = paper.circle(_x, _y, circle_radius)
        stone_bg.attr 'fill', '#fff'
        stone_bg.attr 'stroke-width', '0'

        stone_fg = paper.circle(_x, _y, circle_radius)
        stone_fg.attr 'fill-opacity', 0.9
        stone_fg.attr 'fill', 'r(0.75,0.75)#A0A0A0-#000'
        stone_fg.attr 'stroke-opacity', 0.3
        stone_fg.attr 'stroke-width', '1.2'

        track_stone(i,j)

        group = []
        group.push stone_bg.id
        group.push stone_fg.id
        return group
      


      get_this = this
      remove_stone = (coord) ->
        _.each get_this.RAPH_BOARD_STATE[coord], (id) ->
          paper.getById(id).remove()
        return


      # A move is either a pass play or a board play.


      # pass play
      pass = () ->
        pass_results = virtual_board.pass()
        return

      # make a move (record in history)
      # board play
      move = (coord) ->

        move_results = virtual_board.move(coord)

        # remove dead stones
        _.each move_results.dead, (dead_stone) ->
          remove_stone(dead_stone) 
         
        # place the stone
        switch move_results.color
          when virtual_board.BLACK

            get_this.RAPH_BOARD_STATE[coord] = black_stone(move_results.x, move_results.y)
            
          when virtual_board.WHITE

            get_this.RAPH_BOARD_STATE[coord] = white_stone(move_results.x, move_results.y)
            
          else
            # do nothing

        return

  

      # place stone (for board setup)
      place = (coord, color) ->

        # see if we can place the colored stone        

        place_results = virtual_board.place(coord, color)

        switch place_results.color
          when virtual_board.BLACK

            get_this.RAPH_BOARD_STATE[coord] = black_stone(place_results.x, place_results.y)
            
          when virtual_board.WHITE

            get_this.RAPH_BOARD_STATE[coord] = white_stone(place_results.x, place_results.y)
            
          else
            # do nothing
        return

      

      # Replicate board in memory
      Board = require('Board')
      # black plays first
      virtual_board = new Board(@board_size, Board.BLACK)
      @virtual_board = virtual_board

      # Click event
      get_this = this
      stone_click_detect.click (e) ->

        move(@data('coord'))
        # move detect element to front to be clicked again
        this.toFront()
        return

      get_this = this
      eternal_life_test = ->

        b = Board.BLACK
        w = Board.WHITE

        lol = []
        lol.push([0,w,w,b,0,0,0,0])
        lol.push([b,b,w,b,0,0,0,0])
        lol.push([0,b,w,b,0,0,0,0])
        lol.push([w,b,w,b,0,0,0,0])
        lol.push([0,w,w,b,0,0,0,0])
        lol.push([b,w,b,0,0,0,0,0])
        lol.push([w,b,0,b,0,0,0,0])
        lol.push([0,b,0,0,0,0,0,0])
        lol.reverse()
        

        if get_this.board_size is lol.length
          size = get_this.board_size
          _.each _.range(size), (j) ->
            _.each _.range(size), (i) ->
              
              coord = [i,j]
              place(coord, lol[j][i])

          virtual_board.set_starting_board_state(Board.WHITE)
        
          move([0,5])
          move([0,3])
          move([0,4])
          move([0,2])



      tripleko_test = ->
        # tripleko (SSK test)
        # http://gif-explode.com/?explode=http://www.britgo.org/files/gifs/tripleko.gif
        b = virtual_board.BLACK
        w = virtual_board.WHITE

        
        lol = []
        lol.push([0,0,0,0,0,0,0,0])
        lol.push([b,b,b,b,b,b,b,0])
        lol.push([w,w,w,w,w,w,b,0])
        lol.push([0,w,b,w,b,w,b,0])
        lol.push([w,b,0,b,0,b,w,0])
        lol.push([b,b,b,b,b,b,w,0])
        lol.push([w,w,w,w,w,w,w,0])
        lol.push([0,0,0,0,0,0,0,0])
        lol.reverse()
        
        if get_this.board_size is lol.length
          size = get_this.board_size
          _.each _.range(size), (j) ->
            _.each _.range(size), (i) ->
              
              coord = [i,j]
              place(coord, lol[j][i])
        
          virtual_board.set_starting_board_state(Board.WHITE)

          move([2,3])
          move([0,4])
          move([4,3])
          move([2,4])
          move([0,3])
          move([4,4])
          move([2,3])
          pass()
          pass()
          pass()
          pass()
        # end triple ko test

      #eternal_life_test()
      tripleko_test()
      

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
      canvas.width(length);
      #viewbox_length = canvas_length * canvas_length / canvas.width();
      paper.setViewBox(0, 0, canvas_length, canvas_length, false);
      paper.setSize(length, length);

      # Fill board with all stones 
      ###
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

      

  return _GoBoard


