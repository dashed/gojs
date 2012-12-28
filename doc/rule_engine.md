Logical steps for rule engine:

Input: 

* current_board_state
* ko_point 
* move_coord

ko_point marks previous ko_point (one ko repetition)


Capture of enemy
=============

See: http://en.wikipedia.org/wiki/Rules_of_Go#Capture

Every time a stone is placed on an empty spot on the board look at adjacent points

Definition: A point on the board where a horizontal line meets a vertical line is called an intersection. Two intersections are said to be adjacent if they are distinct and connected by a horizontal or vertical line with no other intersections between them.
see: http://en.wikipedia.org/wiki/Rules_of_Go#Board

if any of adjacent points is an enemy, perform flood fill algorithm (see: http://en.wikipedia.org/wiki/Flood_fill) to get stones that make a chain and the liberty count.

If liberty count is 0, remove the enemy chains.