chai = require('chai')
requirejs = require('requirejs')

# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect

# Source: http://stackoverflow.com/a/15464313/412627
describe 'goban', (done) ->

  ###
  Notes:
    beforeEach(...) runs executing necessary requirejs code to fetch exported _goban var 
    and attaching it to the global test var goban.

    This allows all describe(...) code to have access to _goban.
  ###

  # Test global var(s)
  goban = undefined

  # 'setup' before each test
  beforeEach((done) ->
    
    requirejs.config 
      baseUrl: './src' 
      nodeRequire: require

    requirejs ["config", "main"], (config, _goban) ->

      # Attach to global var
      goban = _goban

      # Tests will run after this is called
      done() 
    )

  ################## Tests ##################

  describe "version", ->

    it "should be string", ->
      
      expect(goban.VERSION).to.be.a('string');

    it "should be a valid semver", ->

      # copied from https://github.com/isaacs/node-semver/blob/master/semver.js

      NUMERICIDENTIFIER = '0|[1-9]\\d*'

      MAINVERSION = '^(' + NUMERICIDENTIFIER + ')\\.' +
                    '(' + NUMERICIDENTIFIER + ')\\.' +
                    '(' + NUMERICIDENTIFIER + ')$';

      m = goban.VERSION.trim().match(MAINVERSION)

      expect(m).to.be.instanceof(Array)
      expect(m).not.be.null


