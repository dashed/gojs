// Initializes the Go board and test it
// Moves executed here may not be fair in a GO game
// Updated 12-21-2013

// This might change depending on which unit testing tool we will use
// -Unsignedzero

"use strict";
var sideLength = 9,
    boardSize = sideLength*sideLength,
    goBoard, goban_engine,
    result;

// Any initialize code for the engine here

var expect = chai.expect;
describe("A board test", function(){

  describe("Placement options", function(){
    except(goban_engine.placePiece(0,0)).to.equal(0);
  });

});


