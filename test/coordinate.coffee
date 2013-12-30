# Test set up from http://stackoverflow.com/a/15464313/412627 and https://github.com/clubajax/mocha-bootstrap

chai = require('chai')
requirejs = require('requirejs')

# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect


describe 'goban coordinate system', (done) ->

  ###
  Notes:
    beforeEach(...) runs executing necessary requirejs code to fetch exported _goban var
    and attaching it to the global test var goban.

    This allows all describe(...) code to have access to _goban.
  ###

  # Test global var(s)
  coordinate = undefined
  _ = undefined

  # 'setup' before each test
  beforeEach((done) ->

    requirejs.config
      baseUrl: './src'
      nodeRequire: require

    requirejs ["config", "lodash", "coordinate"], (config, lodash, _coordinate) ->

      # Attach to global var
      coordinate = _coordinate
      _ = lodash

      # Tests will run after this is called
      done()
    )

  ################## Tests ##################

  describe "when loaded", ->

    it "should have transformations", ->

      expect(coordinate).to.have.property('japanese')
      expect(coordinate).to.have.property('western')
      expect(coordinate).to.have.property('matrix')
      expect(coordinate).to.have.property('cartesian_zero')
      expect(coordinate).to.have.property('cartesian_one')

  describe "when has cartesian_one", ->

    it "should produce correct values for 19x19 board", ->

      cart_one = coordinate['cartesian_one']

      x = y = 20

      stub = {}
      stub['row_bound'] = x
      stub['col_bound'] = y

      while(x-- > 1)
        while(y-- > 1)
          func = _.bind(cart_one, stub, x, y)
          [row, col] = func()

          expect(col).to.equal(x-1)
          expect(row).to.equal(stub['row_bound'] - y)

  describe "when has cartesian_zero", ->

    it "should produce correct values for 19x19 board", ->

      cart_zero = coordinate['cartesian_zero']

      x = y = 19

      stub = {}
      stub['row_bound'] = x
      stub['col_bound'] = y

      while(x-- > 0)
        while(y-- > 0)
          func = _.bind(cart_zero, stub, x, y)
          [row, col] = func()

          expect(col).to.equal(x)
          expect(row).to.equal(stub['row_bound'] - y - 1)


  describe "when has matrix", ->

    it "should produce correct values for 19x19 board", ->

      matrix = coordinate['matrix']

      row = col = 20

      stub = {}
      stub['row_bound'] = row
      stub['col_bound'] = col

      while(row-- > 0)
        while(col-- > 0)
          func = _.bind(matrix, stub, row, col)
          [row, col] = func()

          expect(col).to.equal(col)
          expect(row).to.equal(row)

