# Test set up from http://stackoverflow.com/a/15464313/412627 and https://github.com/clubajax/mocha-bootstrap

chai = require('chai')
requirejs = require('requirejs')

# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect


describe 'goban', (done) ->

  ###
  Notes:
    beforeEach(...) runs executing necessary requirejs code to fetch exported _goban var
    and attaching it to the global test var goban.

    This allows all describe(...) code to have access to _goban.
  ###

  # Test global var(s)
  Goban = undefined
  _ = undefined
  test_board = undefined
  row = col = undefined

  # 'setup' before each test
  beforeEach((done) ->

    requirejs.config
      baseUrl: './src'
      nodeRequire: require

    requirejs ["config", "goban", "lodash"], (config, _goban, lodash) ->

      # Attach to global var
      Goban = _goban
      _ = lodash

      row = 5
      col = 19

      test_board = Goban(row, col)

      # Tests will run after this is called
      done()
    )

  ################## Tests ##################

  describe "when Goban.get(...) is used", ->

    it "should throw error on invalid coords", ->

      config = test_board.config()
      empty = config['stone']['EMPTY']
      expect(config['coordinate_system']).to.equal('cartesian_one')

      (-> test_board.get(row, col)).should.throw(Error)

    it "should throw error on valid coords", ->

      config = test_board.config()
      empty = config['stone']['EMPTY']
      expect(config['coordinate_system']).to.equal('cartesian_one')

      (-> test_board.get(col, row)).should.not.throw(Error)

    describe "with correct external color", ->

      it "should return empty value", ->

        config = test_board.config()
        empty = config['stone']['EMPTY']
        expect(config['coordinate_system']).to.equal('cartesian_one')

        func = () ->
          return test_board.get(col, row)

        while(row-- > 1)
          while(col-- > 1)
            expect(func).to.not.throw(Error)

            color = func()
            expect(color).to.equal(empty)

    describe "with incorrect external color", ->
      it "should throw error", ->

        config = test_board.config()
        empty = config['stone']['EMPTY']
        expect(config['coordinate_system']).to.equal('cartesian_one')

        invalid = 'invalid'

        _row = 2
        _col = 3

        test_board.board.set(invalid, _row, _col)
        expect(test_board.board.get(_row, _col)).to.equal(invalid)

        # cartesian_one inverse
        x = _col + 1
        y = row - _row

        (-> test_board.get(x, y)).should.throw(Error)

  describe "when Goban.set(...) is used", ->

    it "should set with valid coord withour error", (done)->

          config = test_board.config()
          black = config['stone']['BLACK']
          white = config['stone']['WHITE']

          expect(black).to.not.equal(white)

          _callback = (color, first, second, cb)->
            callback = (err, attempt, affected)->

              expect(err).to.equal(undefined)

              expect(_.isPlainObject(attempt)).to.be.true
              expect(_.isPlainObject(affected)).to.be.true

              expect(attempt).to.have.deep.property('color', color)

              expect(attempt).to.have.deep.property('coord[0]', first)
              expect(attempt).to.have.deep.property('coord[1]', second)

              return cb && cb()
            return callback


          test_board.set(black, 2, 3, _callback(black, 2, 3))
                    .set(white, 3, 2, _callback(white, 3, 2, done))
