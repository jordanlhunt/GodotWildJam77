# Game Design Document

## GodotWildJam77

The game will be a clone of Tetris following the example from [GDScirptDude](https://www.youtube.com/playlist?list=PLFTE4-k_Qh3tfkbsapJdRBmU0Y8gze_dl)

## Controls

* Spacebar - Drop the shape instantly
* Down arrow / S key - Slowly drop the shape
* Left arrow / A Key - Move left
* Right arrow / D Key - Move Right
* Up arrow / W Key - Rotate clockwise
* Shift + Up arrow / W Key - rotate counter-clockwise
* Page up - increase level on each press
* New game button
* Pause button
* Music On/Off button
* About button - pop's up a window to the show the above information about the games controls
* Credits - A button to properly accredit GDScriptDude's tutorial

## Scene Elements

10 X 20 row grid of squares to contain the game pieces

Statistics:
* High score
* Level
* Score
* Lines

Next shape.

Game Over banner.

New Game button.

Pause button.

Music On/Off button.

About button.

## Shapes

These will be textures arranged in a grid that have a grid map, color and a probability of occurrence.

## Scoring

Single line 100 points
Double line 200 points
Triple line 400 points
Quadruple line 800 points

## Saving/Loading

When the game is loaded try to load a high score file. When the game ends, save any high score to a high score file

## Sounds 

Play a background music loop if enabled

Play a bleep when shape is placed

Play a bleep when a shape is rotated

Play a jingle when clearing lines

## Animations

Have a visual effect when lines are cleared

