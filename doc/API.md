API
===

API doc for Goban.

**Goban** represents the the board used for the game of [Go](https://en.wikipedia.org/wiki/Go_(game)). 

For gameplay, goban has configurable rules ranging from presets to custom.
In addition, goban allows custom setup of stone (e.g. handicap).

## Constructor

```javascript
new Goban();
new Goban(length [, width]);
```

### Constructor Parameters

**Note:** If no arguments are provided, the constructor creates a goban representation of a 19 x 19 board.

#### length

Integer value representing the **length** of the goban. If **width** is not provided, it is assumed to be the same as **length**.

#### width

An optional parameter.

Integer value representing the **width** of the goban. May not have to be the same as **length**.

## Methods

### Goban.config()

### Goban.set(stone, x, y, callback)

### Goban.place(stone, x, y, callback)

### Goban.move(stone, x, y, callback)

### Goban.validMove(x, y)

### Goban.pass()

### Goban.goBack(n)

### Goban.goForward(n)

### Goban.goToMove(n)

## Properties

**Goban.VERSION**

(string) The semantic version number. See http://semver.org/