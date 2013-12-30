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

  it "should return itself", ->

    expect(noarg.config({})).to.equal(noarg)

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


  describe "when loaded with some data", ->

    it "should take only plain object", ->

      (-> noarg.config([1,2,3])).should.throw(Error)

      (-> noarg.config({})).should.not.throw(Error)
      (-> noarg.config({ 'x': 0, 'y': 0 })).should.not.throw(Error)


  describe "when loaded with custom coord transformation function", ->

    it "should throw error on none coord trans func", ->
      custom = {}
      custom['coordinate_system_transformations'] ={}
      custom['coordinate_system'] = 'custom'

      # some none function
      custom['coordinate_system_transformations']['custom'] = {}

      noarg.config(custom)

      (-> noarg.get(1,2)).should.throw(Error)


    it "should throw error on coord trans func that returns invalid internal coords", (done)->

      config = noarg.config()
      black = config['stone']['BLACK']

      custom = {}
      custom['coordinate_system_transformations'] ={}
      custom['coordinate_system'] = 'custom'

      # some none function
      custom['coordinate_system_transformations']['custom'] = () -> return ['invalid']

      noarg.config(custom)

      (-> noarg.get(1,2)).should.throw(Error)
      noarg.set(black,1,2, (err, attempt, affected)->
        expect(err).to.be.instanceOf(Error)

        expect(affected).to.equal(undefined)

        expect(_.isPlainObject(attempt)).to.be.true

        expect(attempt).to.have.deep.property('color', black)

        expect(attempt).to.have.deep.property('coord[0]', 1)
        expect(attempt).to.have.deep.property('coord[1]', 2)

        return done()
        )
