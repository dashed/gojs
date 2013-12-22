chai = require('chai')
# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect

# Source: http://stackoverflow.com/a/15464313/412627
describe 'Testing "Other"', (done) ->

  beforeEach (done) ->
    
    requirejs = require('requirejs')

    requirejs ["config", "main"], (config, goban) ->

      # Tests will run after this is called
      done() 


  describe "#1 Other Suite:", ->
    it "Other.test", ->
      foo = 'lol'
      expect(foo).to.be.a('string');

  describe "#2 Boo Suite:", ->
    it "Boo.test", ->
      foo = 5
      expect(foo).to.be.a('string');

