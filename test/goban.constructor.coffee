# Test set up from http://stackoverflow.com/a/15464313/412627 and https://github.com/clubajax/mocha-bootstrap

chai = require('chai')
requirejs = require('requirejs')

# Chai
assert = chai.assert
should = chai.should()
expect = chai.expect


describe 'goban constructor', (done) ->

  ###
  Notes:
    beforeEach(...) runs executing necessary requirejs code to fetch exported _goban var
    and attaching it to the global test var goban.

    This allows all describe(...) code to have access to _goban.
  ###

  # Test global var(s)
  Goban = undefined

  # 'setup' before each test
  beforeEach((done) ->

    requirejs.config
      baseUrl: './src'
      nodeRequire: require

    requirejs ["config", "goban"], (config, _goban) ->

      # Attach to global var
      Goban = _goban

      # Tests will run after this is called
      done()
    )

  ################## Tests ##################

  describe "when has no arguments", ->

    it "should create 19x19 board", ->

      no_arg = Goban()

      no_arg.width.should.equal(no_arg.length)

      no_arg.width.should.equal(19)
      no_arg.length.should.equal(19)


  invalid_input = ['invalid', 4.5, false, true, 0, 0.0]
  valid_input = [4, null, undefined]

  describe "when has valid params", ->

    it "should not throw error on one valid param", ->

      for valid in valid_input
        (-> Goban(valid)).should.not.throw(Error);

    it "should not throw error on two valid params", ->

      for valid in valid_input
        for valid2 in valid_input
          (-> Goban(valid, valid2)).should.not.throw(Error);


  describe "when has invalid params", ->

    it "should throw error on one invalid param", ->

      # invalid first param
      for invalid in invalid_input
        (-> Goban(invalid)).should.throw(Error);

      # invalid second param with valid first param
      for invalid in invalid_input
        for valid in valid_input
          (-> Goban(valid, invalid)).should.throw(Error);

      for valid in valid_input
        (-> Goban(valid, valid)).should.not.throw(Error);

    it "should throw error on two invalid params", ->

      for invalid in invalid_input
        for invalid2 in invalid_input
          (-> Goban(invalid, invalid2)).should.throw(Error);

