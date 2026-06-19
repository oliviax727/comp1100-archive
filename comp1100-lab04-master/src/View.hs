--- Copyright 2020 The Australian National University, All rights reserved
module View where

import CodeWorld

-- this function can be assigned different pictures
myPicture :: Picture
myPicture = coordinatePlane & translated 1 1 (solidPolygon [(3,6), (7,0), (6,0), (4,3), (5, 3), (3,0), (2,0), (4,3), (2,6)]) -- & polyline [(2,6), (4,3), (2,0)]

myRectangle :: Picture
myRectangle = solidRectangle 3.5 3.5

myObj :: Colour -> Double -> Double -> Picture -> Picture
myObj c x y p = colored c (translated x y p)

coloredSquares :: Color -> Color -> Color -> Color -> Picture
coloredSquares a b c d = myObj a (-2) (-2) myRectangle & myObj b 2 (-2) myRectangle & myObj c (-2) 2 myRectangle & myObj d 2 2 myRectangle

rotatedColouredSquares :: Double -> Color -> Color -> Color -> Color -> Picture
rotatedColouredSquares r a b c d = rotated r (coloredSquares a b c d)