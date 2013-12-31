# Test set up from http://stackoverflow.com/a/15464313/412627 and https://github.com/clubajax/mocha-bootstrap

Object.defineProperty global, "name_of_leaking_property",
  set: (value) ->
    throw new Error("SHIT!")


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

    describe "with correct external color", ()->

      it "should return correctly when set", (done)->

        test_board.config({'coordinate_system': 'matrix'})

        config = test_board.config()

        colors = []
        colors.push(config['stone']['EMPTY'])
        colors.push(config['stone']['BLACK'])
        colors.push(config['stone']['WHITE'])

        expect(config['coordinate_system']).to.equal('matrix')

        _row = 2
        _col = 3



        _.each(colors, (_color, indx)->


          callback = (err, attempt, affected)->
            expect(err).to.equal(undefined)

            expect(test_board.get(_row, _col)).to.equal(_color)

            if indx is 2
              return done()

          test_board.set(_color, _row, _col, callback)
          )


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

    it "should return itself", ->

      expect(test_board.set()).to.equal(test_board)

    it "should throw error on incomplete params", (done)->

      callback = (err, attempt, affected)->
        expect(err).to.be.instanceOf(Error)
        expect(attempt).to.equal(undefined)
        expect(affected).to.equal(undefined)
        return done()

      test_board.set(undefined, undefined, undefined, callback)

    it "should throw error on incomplete params, but given valid color", (done)->

      config = test_board.config()
      empty = config['stone']['EMPTY']
      black = config['stone']['BLACK']
      white = config['stone']['WHITE']

      expect(black).to.not.equal(white)

      _callback = (cb)->
        callback = (err, attempt, affected)->

          expect(err).to.be.instanceOf(Error)
          expect(attempt).to.equal(undefined)
          expect(affected).to.equal(undefined)

          return cb && cb()
        return callback


      test_board.set(black, undefined, undefined, _callback())
      test_board.set(empty, undefined, undefined, _callback())
      test_board.set(white, undefined, undefined, _callback(done))

    it "should throw error on incomplete params, but given valid color and one coord", (done)->

      config = test_board.config()
      empty = config['stone']['EMPTY']
      black = config['stone']['BLACK']
      white = config['stone']['WHITE']

      expect(black).to.not.equal(white)

      _callback = (cb)->
        callback = (err, attempt, affected)->

          expect(err).to.be.instanceOf(Error)
          expect(attempt).to.equal(undefined)
          expect(affected).to.equal(undefined)

          return cb && cb()
        return callback

      test_board.set(black, 1, undefined, _callback())
      test_board.set(white, 1, undefined, _callback())
      test_board.set(empty, 1, undefined, _callback())
      test_board.set(black, undefined, 1, _callback())
      test_board.set(empty, undefined, 1, _callback())
      test_board.set(white, undefined, 1, _callback(done))

    it "should throw error on invalid coord", (done)->
      config = test_board.config()
      empty = config['stone']['EMPTY']
      black = config['stone']['BLACK']
      white = config['stone']['WHITE']


      _callback = (color, first, second, cb)->
        callback = (err, attempt, affected)->

          expect(err).to.be.instanceOf(Error)
          expect(_.isPlainObject(attempt)).to.be.true
          expect(affected).to.equal(undefined)

          expect(attempt).to.have.deep.property('color', color)
          expect(attempt).to.have.deep.property('coord[0]', first)
          expect(attempt).to.have.deep.property('coord[1]', second)

          return cb && cb()
        return callback

      test_board.set(black, 200, 300, _callback(black, 200, 300))
      test_board.set(white, 200, 300, _callback(white, 200, 300))
      test_board.set(empty, 200, 300, _callback(empty, 200, 300, done))

    it "should throw error on invalid color", (done)->

      invalid_color = 'invalid'

      callback = (err, attempt, affected)->
        expect(err).to.be.instanceOf(Error)
        expect(_.isPlainObject(attempt)).to.be.true
        expect(affected).to.equal(undefined)
        expect(attempt).to.have.deep.property('color', invalid_color)
        expect(attempt).to.have.deep.property('coord[0]', 1)
        expect(attempt).to.have.deep.property('coord[1]', 2)
        return done()

      test_board.set(invalid_color, 1, 2, callback)

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

          expect(attempt).to.have.deep.property('coord[0]', second)
          expect(attempt).to.have.deep.property('coord[1]', second)

          return cb && cb()
        return callback


      test_board.set(black, 2, 3, _callback(black, 2, 3))
                .set(white, 3, 2, _callback(white, 3, 2, done))
