module Warmup where

-- | Takes three arguments, and returns the biggest.
-- >>> bigThree (-2) 9 4
-- 9
bigThree :: (Ord a) => a -> a -> a -> a
bigThree x y z
    | x > y && x > z = x
    | y > x && y > z = y
    | otherwise  = z

-- | Take as input a tuple of three elements, 
-- and returns the middle element.
middle :: (a, b, c) -> b
middle (_, x, _) = x

-- | Takes in a character, and checks if the character
-- is a vowel. A vowel is one of the following letters: `a,e,i,o,u`.
isVowel :: Char -> Bool
isVowel c = case c of
    'a' -> True
    'e' -> True
    'i' -> True
    'o' -> True
    'u' -> True
    _ -> False


-- | Takes two booleans, and returns true if one and only
-- one of the inputs was `True`. Try to define it in a single line without
-- guards.
-- >>> xor True True
-- False
-- >>> xor False True
-- True
-- >>> xor True False
-- True
-- >>> xor False False
-- False
xor :: Bool -> Bool -> Bool
xor a b = (a || b) && not (a && b)

-- | Returns true if all the inputs are different.
-- >>> threeDiff 3 3 4
-- False
-- >>> threeDiff 'e' 'q' 'e'
-- False
-- >>> threeDiff 5 3 4
-- True
threeDiff :: (Eq a) => a -> a -> a -> Bool
threeDiff x y z = not (x == y || x == z || y == z)

-- | Warmup (requires math)
-- Takes in three arguments, `a,b,c` 
-- and returns the discriminate D of the quadratic equation
-- ax^2 + bx + c = 0, defined as D = b^2 - 4ac
-- >>> discriminate 4 4 1
-- 0.0
discriminate :: Double -> Double -> Double -> Double
discriminate a b c = (b ** 2) - (4 * a * c)


-- rootsQuad : Returns any real roots of a quadratic polynomial
-- You'll have to work out a suitable type signature,
-- so you can return two roots, one root, or no roots (depending
-- on how many exist)
rootsQuad :: Double -> Double -> Double -> [Double]
rootsQuad a b c
    | discriminate a b c == 0 = [quadFormula True a b c]
    | discriminate a b c > 0 = [quadFormula True a b c, quadFormula False a b c]
    | otherwise = []
        where
            quadFormula :: Bool -> Double -> Double -> Double -> Double
            quadFormula True a b c = (- b + sqrt (discriminate a b c))/(2 * a)
            quadFormula False a b c = (- b - sqrt (discriminate a b c))/(2 * a)

