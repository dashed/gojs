chai = require('chai')
requirejs = require('requirejs')

# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect

# Source: http://stackoverflow.com/a/15464313/412627
describe 'Testing "Other"', (done) ->

  # Test global var(s)
  goban = undefined

  # Set up before each test
  beforeEach (done) ->
    
    requirejs.config baseUrl: './src'

    requirejs ["config", "main"], (config, _goban) ->

      # Attach to scoped var
      goban = _goban

      # Tests will run after this is called
      done() 


  ################## Tests ##################

  describe "#1 Other Suite:", ->
    it "Other.test", ->
      
      expect(goban.VERSION).to.be.a('string');

  describe "#2 Boo Suite:", ->
    it "Boo.test", ->
      foo = '5'
      expect(foo).to.be.a('string');

