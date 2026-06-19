module SumOdd where

-- | Given a list of Integer values, return the sum of all the odd values.
--
-- Examples:
-- >>> sumOdd []
-- 0
-- >>> sumOdd [2, 4]
-- 0
-- >>> sumOdd [5]
-- 5
-- >>> sumOdd [4, 5, 7]
-- 12
-- >>> sumOdd [0, -5, 5, 11]
-- 11
sumOdd :: [Integer] -> Integer
sumOdd [] = 0
sumOdd [x] = if odd x then x else 0
sumOdd (x:xs) = if odd x then x + sumOdd xs else sumOdd xs

