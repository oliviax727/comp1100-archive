module Shapes where

type Point = (Double, Double)

data Shape
  = Rectangle Point
              Double
              Double
  -- ^ A Rectangle has a centre, a width, and a height
  | Circle Point
           Double
  -- ^ A Circle has a centre and a radius
  deriving (Show,Eq)

midpoint :: Point -> Point -> Point
midpoint (x1, y1) (x2, y2) = ((x1 + x2) / 2, (y1 + y2) / 2)

distance :: Point -> Point -> Double
distance (x1, y1) (x2, y2) = sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)

-- | rectangle:
-- Given two opposing vertices, construct a Rectangle of type Shape.
--
-- Examples:
--
-- >>> rectangle (0,0) (2,2)
-- Rectangle (1.0,1.0) 2.0 2.0
--
-- >>> rectangle (0,0) (3,3)
-- Rectangle (1.5,1.5) 3.0 3.0
--
-- >>> rectangle (-4,0) (3,3)
-- Rectangle (-0.5,1.5) 7.0 3.0
rectangle :: Point -> Point -> Shape
rectangle (x1, y1) (x2, y2) = Rectangle (midpoint (x1, y1) (x2, y2)) (distance (x1, y2) (x2, y2)) (distance (x2, y1) (x2, y2))

-- | circle:
-- Given the centre point of a circle, and a point on its circumference,
-- construct the corresponding shape.
-- Recall that, given a centre point (x0,y0) and a point on the circumference
-- (x1,y1), then the square of the radius r of the circle is the sum of the
-- squares of the differences (x1 - x0) and (y1 - y0), i.e.
-- square r = square (x1 - x0) + square (y1 - y0), where square x = x * x.
--
-- Examples:
--
-- >>> circle (1,1) (2,1)
-- Circle (1.0,1.0) 1.0
--
-- >>> circle (1,1) (4,5)
-- Circle (1.0,1.0) 5.0
circle :: Point -> Point -> Shape
circle a b = Circle a (distance a b)
