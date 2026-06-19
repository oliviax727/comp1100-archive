module Mensuration where

    data Shape
        = Circle Double
        | Square Double
        | Rectangle Double Double
        deriving Show

    -- Outputs area of given object
    -- | Area
    -- >>> area (Circle 10)
    -- 314.1592653589793
    --
    -- >>> area (Rectangle 3 5)
    -- 15.0
    --
    area :: Shape -> Double
    area s = case s of
        Circle x -> (x ** 2) * pi
        Square x -> x ** 2
        Rectangle x y -> x * y

    -- Calculates area of a triangle
    areaTri :: Double -> Double -> Double -> Double
    areaTri a b c = sqrt (s a b c 0 * s a b c a  * s a b c b * s a b c c)
        where
            s a b c d = ((a + b + c) / 2) - d

    -- Calculates area of a triangle with safety guards
    -- | AreaTriSafe
    -- >>> areaTriSafe 3 4 5
    -- Just 6.0
    --
    -- >>> areaTriSafe (-1) 3 4
    -- Nothing
    --
    -- >>> areaTriSafe 3 3 10
    -- Nothing
    --
    areaTriSafe :: Double -> Double -> Double -> Maybe Double
    areaTriSafe a b c = if
        a > 0 && b > 0 && c > 0 &&
        a + c > b && a + b > c && b + c > a
        then Just (areaTri a b c) else Nothing
            
