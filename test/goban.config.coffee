# Test set up from http://stackoverflow.com/a/15464313/412627 and https://github.com/clubajax/mocha-bootstrap

chai = require('chai')
requirejs = require('requirejs')

# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect


describe 'goban config', (done) ->

  ###
  Notes:
    beforeEach(...) runs executing necessary requirejs code to fetch exported _goban var
    and attaching it to the global test var goban.

    This allows all describe(...) code to have access to _goban.
  ###

  # Test global var(s)
  Goban = undefined
  noarg = undefined

  # 'setup' before each test
  beforeEach((done) ->

    requirejs.config
      baseUrl: './src'
      nodeRequire: require

    requirejs ["config", "goban"], (config, _goban) ->

      # Attach to global var
      Goban = _goban

      noarg = Goban()

      # Tests will run after this is called
      done()
    )

  ################## Tests ##################

  describe "when default", ->

    it "should be an object", ->

      config = noarg.config()

      expect(config).to.be.an('object')

    it "should have stone colors", ->

      config = noarg.config()

      expect(config).to.have.deep.property('stone.EMPTY', 'empty')
      expect(config).to.have.deep.property('stone.BLACK', 'black')
      expect(config).to.have.deep.property('stone.WHITE', 'white')

    it "should have default coordinate_system", ->
      config = noarg.config()
      expect(config).to.have.deep.property('coordinate_system', 'cartesian_one')

    it "should have coordinate_transformations", ->
      config = noarg.config()

      expect(config).to.have.property('coordinate_system_transformations')


  describe "when loaded with custom config", ->

    it "should take only plain object", ->

      (-> noarg.config([1,2,3])).should.throw(Error)

      (-> noarg.config({})).should.not.throw(Error)
      (-> noarg.config({ 'x': 0, 'y': 0 })).should.not.throw(Error)

    it "should return itself", ->

      expect(noarg.config({})).to.equal(noarg)
