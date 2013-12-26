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
    
    requirejs.config baseUrl: './src'

    requirejs ["config", "main"], (config, _goban) ->

      # Attach to global var
      goban = _goban

      # Tests will run after this is called
      done() 
    )

  ################## Tests ##################

  describe "constructor", ->
    it "Other.test", ->
      
      expect(goban.VERSION).to.be.a('string');

  describe "#2 Boo Suite:", ->
    it "Boo.test", ->
      foo = '5'
      expect(foo).to.be.a('string');

