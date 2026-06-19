--- Copyright 2021 The Australian National University, All rights reserved

module View where

import CodeWorld
import Data.Text (pack)
import Model

-- | Render all the parts of a Model to a CodeWorld picture.
modelToPicture :: Model -> Picture
modelToPicture (Model ss t c)
  = translated 0 8 toolText
  & translated 0 7 colourText
  & colourShapesToPicture ss
  & coordinatePlane
  where
    colourText = stringToText (show c)
    toolText = stringToText (toolToLabel t)
    stringToText = lettering . pack

-- Provides a description for each tool
toolToLabel :: Tool -> String
toolToLabel t = case t of
  LineTool _ -> "Line... click-drag-release"
  PolygonTool _ -> "Polygon... click 3 or more times then spacebar"
  RectangleTool _ -> "Rectangle... click-drag-release between opposite corners"
  CircleTool _ -> "Circle... click-drag-release from opposite points on the circumfrence"
  ParallelogramTool _ _ -> "Parallelogram... click three points, each adjacent to the next"
  SquareTool _ -> "Square... click-drag-release between midpoints of opposite sides"
  SelectTool _ _ -> "Select... click-drag-release, translate all shapes in range (WASD) or delete (Q)"

-- Performs all view operations on a list of ColourShapes
colourShapesToPicture :: [ColourShape] -> Picture
colourShapesToPicture [] = coordinatePlane -- Throwing error will stop it from running
colourShapesToPicture [s] = colourShapeToPicture s
colourShapesToPicture (s:sl) = colourShapeToPicture s & colourShapesToPicture sl

-- Colours a picture given a shape
colourShapeToPicture :: ColourShape -> Picture
colourShapeToPicture (c, s) = coloured (colourNameToColour c) (shapeToPicture s)

-- Converts a ColourName type into it's corresponding CodeWorld Color type
colourNameToColour :: ColourName -> Color
colourNameToColour c = case c of
  Black -> black
  Purple -> purple
  Blue -> blue
  Green -> green
  Yellow -> yellow
  Orange -> orange
  Red -> red
  Gray -> translucent gray

-- Distance of two points
distance :: Point -> Point -> Double
distance (x1, y1) (x2, y2) = sqrt ((y1 - y2) ** 2 +(x1 - x2) ** 2)

-- Midpoint of two points
mid :: Double -> Double -> Double
mid x1 x2 = (x1 + x2) / 2

-- Performs a vector addition
vecAdd :: Point -> Point -> Bool -> Point
vecAdd (x1, y1) (x2, y2) isNeg
  | isNeg = (x1 - x2, y1 - y2)
  | otherwise = (x1 + x2, y1 + y2)

-- Performs a vector addition on multiple vectors
vecsAdd :: Point -> [Point] -> Bool -> [Point]
vecsAdd p [] _ = []
vecsAdd p [x] b = [vecAdd p x b]
vecsAdd p (x:xs) b = vecAdd p x b : vecsAdd p xs b

-- Gets the set of points for a square
squarePoints :: Point -> Point -> [Point]
squarePoints (x1, y1) (x2, y2) = [(x1 - dx, y1 - dy), (x1 + dx, y1 + dy), (x2 + dx, y2 + dy), (x2 - dx, y2 - dy)]
  where
    dx =  d * cos (atan (- 1 / grad))
    dy = d * sin (atan (- 1 / grad))
    grad = (y1 - y2) / (x1 - x2)
    d = distance (x1, y1) (x2, y2) / 2

-- Converts shape to picture
shapeToPicture :: Shape -> Picture
shapeToPicture s = case s of
  Line x y -> polyline [x, y]
  Square (x1, y1) (x2, y2) -> solidPolygon (squarePoints (x1, y1) (x2, y2))
  Rectangle (x1, y1) (x2, y2) -> solidPolygon [(x1, y1), (x1, y2), (x2, y2), (x2, y1)]
  Circle (x1, y1) (x2, y2) -> translated (mid x1 x2) (mid y1 y2) (solidCircle (distance (x1, y1) (x2, y2) / 2))
  Parallelogram x y z -> solidPolygon [x, y, z, vecAdd (vecAdd x z False) y True]
  Polygon x -> solidPolygon x

-- TODO
areaShapes :: [Shape] -> Tool -> Double
areaShapes = undefined

-- Converts Tool to ColourShape
toolToShape :: ColourName -> Point -> Tool -> ColourShape
toolToShape c p t = case t of
  LineTool (Just arg) -> (c, Line arg p)
  SquareTool (Just arg) -> (c, Square arg p)
  RectangleTool (Just arg) -> (c, Rectangle arg p)
  CircleTool (Just arg) -> (c, Circle arg p)
  ParallelogramTool (Just arg1) (Just arg2) -> (c, Parallelogram arg1 arg2 p)
  PolygonTool arg -> (c, Polygon arg)
  SelectTool (Just arg) _ -> (Gray, Rectangle arg p)
  _ -> (c, Line p p)

-- Flips coordinates of single point/set of points True = Flip via X-axis
fX :: Bool -> Point -> Point
fX True (x, y) = (x, -y)
fX False (x, y) = (-x, y)

fXset :: Bool -> [Point] -> [Point]
fXset _ [] = []
fXset b [x] = [fX b x]
fXset b (x:xs) = fX b x : fXset b xs

-- Flips coordinates of Shape
flipColX :: Bool -> ColourShape -> ColourShape
flipColX b (c, t) = case t of
  Line p1 p2 -> (c, Line (fX b p1) (fX b p2))
  Square p1 p2 -> (c, Square (fX b p1) (fX b p2))
  Circle p1 p2 -> (c, Circle (fX b p1) (fX b p2))
  Rectangle p1 p2 -> (c, Rectangle (fX b p1) (fX b p2))
  Parallelogram p1 p2 p3 -> (c, Parallelogram (fX b p1) (fX b p2) (fX b p3))
  Polygon s -> (c, Polygon (fXset b s))

-- Flips coordinates by x-axis
flipX :: [ColourShape] -> [ColourShape]
flipX [] = []
flipX [x] = [flipColX True x]
flipX (x:xs) = flipColX True x : flipX xs

-- Flips coordinates by y-axis
flipY :: [ColourShape] -> [ColourShape]
flipY [] = []
flipY [x] = [flipColX False x]
flipY (x:xs) = flipColX False x : flipY xs

-- Rotates the diameter in a circle by 90 deg
squareInCircle :: Point -> Point -> [Point]
squareInCircle (x1, y1) (x2, y2) = [(mx - dx, my - dy), (mx + dx, my + dy)]
  where
    dx =  (d / 2) * cos (atan (- 1 / grad))
    dy = (d / 2) * sin (atan (- 1 / grad))
    grad = (y1 - y2) / (x1 - x2)
    d = distance (x1, y1) (x2, y2) / 2
    mx = mid x1 x2
    my = mid y1 y2