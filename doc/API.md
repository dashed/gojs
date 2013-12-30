API
===

API doc for Goban.

**Goban** represents the the board used for the game of [Go](https://en.wikipedia.org/wiki/Go_(game).

For gameplay, Goban has configurable rules ranging from presets to custom options that can be passed in.
In addition, Goban allows custom setup of stone (e.g. handicap).

## Constructor

```javascript
new Goban();
new Goban(length [, width]);
```

### Constructor Parameters

**Note:** If no arguments are provided, the constructor creates a Goban representation of a 19 x 19 board.

#### length

An integer value representing the **length** of the Goban board representation. If **width** is not provided, it is assumed to be the same as **length**.

#### width

An optional integer parameter.

Integer value representing the **width** of the Goban. May not have to be the same as **length**.

* * * *

## Methods

Some of the arguments used by the methods are the same and listed here for reference.

#### move

Move is an object contining the type(color) and the position.

```javascript
move = {
  type:(black|white|nothing),
  coord:[first, second]
}
```

#### callback function

callback (err, move, affected_coords)

This function acts on the result of the Goban method. Callback should deal with
the error message

Parameter:
Err will get an error message that can be thrown or interpreted and caught.
move is the move object above.
affected_coords will be an object in the form of { 'stoneBefore,stoneAfter':[[x1,y1]...], ... }.
This will contain all changes made with the method requested.

* * * *

## Chainable Methods
These methods can be chained e.g.

```javascript
Goban(19).config().move().move().pass()
```

They will return back a valid Goban object.

### Goban.config(state)

Config takes a state object in the form {option: parameter, ... } and applies it to the current object.
Inavlid options are ignored.

Parameter:
state is a non-null object.

Refer to ../coffee/main.coffee for the default values and possiton options to pass.

### Goban.set(stone, x, y, callback)

Sets the (x, y) of the Goban board to stone. The callback method will handle the result of success
or failure. No errors are thrown by this function but passed into callback. Unlike Goban.place,
this does not check if the move is valid, so a piece can be placed anywhere that is valid, overriding
the current stone there.

Parameter:
stone is a stone object, above
x is a valid coordinate on the board
y is a valid coordinate on the board
callback is a function, above

### Goban.place(x, y, callback)

Places a stone the current player at (x, y) and checks if that move is valid.
The callback method will handle the result of success, or failure.
No errors are thrown by this function but passed into callback. Invalid moves create error messages unlike Goban.set.
Unlike the four arg version, this places the stone and updates the turn counter.

### Goban.place(stone, x, y, callback)

Places a stone at (x, y) and checks if that move is valid. The callback method will handle the result of success,
or failure. No errors are thrown by this function but passed into callback. Invalid moves create error messages
unlike Goban.set. Unlike the three arg version, the stone is placed, regardless of turn and the turn counter is
NOT updated.

### Goban.pass()

Changes the turn state.

### Goban.goBack(n, callback)

Goes back n moves in history if possible. The callback method will handle the result of success,
or failure. No errors are thrown by this function but passed into callback.

### Goban.goForward(n, callback)

Goes forward  moves in history if possible. The callback method will handle the result of success,
or failure. No errors are thrown by this function but passed into callback.

### Goban.goToMove(n, callback)

Jumps to move number n if possible. The callback method will handle the result of success,
or failure. No errors are thrown by this function but passed into callback.

## Unchainable Methods

These methods will not return back a Goban method so they cannot be method chained.
However, they can be the last method in a chain.

### Goban.validMove(x, y)

Checks if the position is free, has no stone.

## Properties

**Goban.VERSION**

(string) The semantic version number. See http://semver.org/
