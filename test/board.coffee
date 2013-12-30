# Test set up from http://stackoverflow.com/a/15464313/412627 and https://github.com/clubajax/mocha-bootstrap

chai = require('chai')
requirejs = require('requirejs')

# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect


describe 'goban board', (done) ->

  ###
  Notes:
    beforeEach(...) runs executing necessary requirejs code to fetch exported _goban var
    and attaching it to the global test var goban.

    This allows all describe(...) code to have access to _goban.
  ###

  # Test global var(s)
  Board = undefined
  _ = undefined

  # 'setup' before each test
  beforeEach((done) ->

    requirejs.config
      baseUrl: './src'
      nodeRequire: require

    requirejs ["config", "lodash", "board"], (config, lodash, _board) ->

      # Attach to global var
      Board = _board
      _ = lodash

      # Tests will run after this is called
      done()
    )

  ################## Tests ##################

  describe "when emulating 19x19 goban", ->

    it "should have properly defined row and col", ->
      board = new Board(19)

      expect(board.row).to.equal(19)
      expect(board.col).to.equal(19)

  describe "when emulating 5x19 goban", ->

    it "should have properly defined row and col", ->
      board = new Board(5, 19)

      expect(board.row).to.equal(5)
      expect(board.col).to.equal(19)

    it "should have empty array on load", ->

      board = new Board(5, 19)

      arr = board.getBoard()

      expect(arr).to.be.an.instanceof(Array)
      expect(arr.length).to.equal(0)

    describe "with default value set via constructor", ->

      it "should have all default value", ->

        val = 3
        board = new Board(5, 19, val)

        expect(_.size(board.getBoard())).to.equal(5*19)

        _.each(board.getBoard(), (elem)->

          expect(elem).to.equal(val)
          )

        row = 5
        col = 19

        while(row-- > 0)
          while(col-- > 0)
            _val = board.get(row, col)
            expect(_val).to.equal(val)


      it "should have functioning Board.set()", ->

        val = 3
        board = new Board(5, 19, val)


        board.set(1, 2, 3)

        expect(board.get(2, 3)).to.equal(1)
        expect(board.get(3, 2)).to.equal(val)

        board.set(4, 3, 2)

        expect(board.get(3, 2)).to.equal(4)
        expect(board.get(2, 3)).to.equal(1)

        row = 5
        col = 19

        while(row-- > 0)
          while(col-- > 0)
            _val = board.get(row, col)

            if (row isnt 2 and col isnt 3) or (row isnt 3 and col isnt 2)
              expect(_val).to.equal(val)

    describe "with default value set via Board.setDefault()", ->

      it "should have all default value", ->

        val = 3

        board = new Board(5, 19)
        board.setDefault(val)

        expect(_.size(board.getBoard())).to.equal(5*19)

        _.each(board.getBoard(), (elem)->

          expect(elem).to.equal(val)
          )

        row = 5
        col = 19

        while(row-- > 0)
          while(col-- > 0)
            _val = board.get(row, col)
            expect(_val).to.equal(val)

      it "should have functioning Board.set()", ->

        val = 3
        board = new Board(5, 19)
        board.setDefault(val)

        board.set(1, 2, 3)

        expect(board.get(2, 3)).to.equal(1)
        expect(board.get(3, 2)).to.equal(val)

        board.set(4, 3, 2)

        expect(board.get(3, 2)).to.equal(4)
        expect(board.get(2, 3)).to.equal(1)

        row = 5
        col = 19

        while(row-- > 0)
          while(col-- > 0)
            _val = board.get(row, col)

            if (row isnt 2 and col isnt 3) or (row isnt 3 and col isnt 2)
              expect(_val).to.equal(val)
