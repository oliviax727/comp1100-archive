{-

Module  :  AngleConversion
Author  :  COMP1100/COMP1130 Team, Your name here

TODO: Write some comment here about the module.

-}

module AngleConversion where

-- Type synonym let you create a new name for an existing type
-- In this case, Degrees and Radians serve as better names
-- to denote angles rather than Double
type Degrees = Double
type Radians = Double

-- convert degrees to radians
degreesToRadians :: Degrees -> Radians
degreesToRadians degrees = degrees * (pi / 180)

-- convert radians to degrees
radiansToDegrees :: Radians -> Degrees
radiansToDegrees radians = radians * (180 / pi)

-- References
-- [1] https://www.rapidtables.com/convert/number/how-radians-to-degrees.html
-- [2] https://wiki.haskell.org/Type_synonym