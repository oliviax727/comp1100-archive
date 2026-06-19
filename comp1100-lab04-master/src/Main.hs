--- Copyright 2020 The Australian National University, All rights reserved
module Main where

import CodeWorld
import View

main :: IO ()
main = drawingOf myPicture --(rotatedColouredSquares (pi/4) blue yellow orange green)    --coordinatePlane