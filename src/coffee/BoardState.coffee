define (require) ->
  
  #murmurhash3 = require('murmurhash3')
  _ = require('underscore')

  class BoardState

    ###
    board state:
        move_color (who made the move in the board state)
            @BLACK or @WHITE
        stones_added:
            {WHITE:[collection of coords], BLACK:[collection of coords]}

        stones_removed:
            {WHITE:[collection of coords], BLACK:[collection of coords]}        
    ###
    
    constructor: (@board_state, @move_color) ->

      return @

    getBoardState: ()->
      return  @board_state

    getWhoMoved: () ->
      return @move_color


    runlength: (c_input, t_input, c_index) ->
      t = ""
      t += t_input + "$" # inflate string by discardable marker
      i = 0
      i = c_index + 1
      while i < t.length
        return (i - c_index)  unless c_input is t[i]
        i++
      return -1 # error

    # based on: http://pp19dd.com/2011/10/query-string-limits-encoding-hundreds-of-checkboxes-with-rle/#demo
    # modified to 3 character encoding
    rle_encode: (t) ->

      n = ""
      i = 0
      while i < t.length

        # get current character
        c = t[i]
        
        # get running length of this character
        l = @runlength(c, t, i)
        if l is -1
          break

        # variable-length repetitions
        if l > 2
          switch c
            when "0" then n += "A"
            when "1" then n += "B"
            when "2" then n += "C"
          n += l

          # skip running length characters
          i += l
          continue

        else if l is 2

          switch c
            when "0" then n += "d"
            when "1" then n += "e"
            when "2" then n += "f"

          i += l
          continue

        # single encodings
        else if l is 1
          switch c
            when "0" then n += "a"
            when "1" then n += "b"
            when "2" then n += "c"

        i++

      n = n.replace(/ab/gi, "g")
      n = n.replace(/ba/gi, "G")
      
      n = n.replace(/bc/gi, "h")
      n = n.replace(/cb/gi, "H")

      n = n.replace(/ca/gi, "i")
      n = n.replace(/ac/gi, "I")

      # shorten any sequences of characters longer than 2
      n_final = ""
      i = 0
      while i < n.length

        # get current character
        c = n[i]
        
        # get running length of this character
        l = @runlength(c, n, i)
        if l is -1
          break

        if l > 2
          n_final += c
          n_final += l
          i += l
          continue
        n_final += c
        i += 1

      #console.log n_final.length/t.length
      return n_final

    getHash: () ->

      # hash depends on the board state and the current color who created it
      virtual_board_string = _.flatten(@board_state).join("")

      final_rle = @rle_encode(virtual_board_string) + @move_color.toString()

      console.log final_rle
      #console.log final_rle.length + " " + virtual_board_string.length

      #return murmurhash3.murmurhash3_32_gc(virtual_board_string, 1)

      # use run length encoding instead
      # no need to worry about collisions
      return final_rle
  return BoardState