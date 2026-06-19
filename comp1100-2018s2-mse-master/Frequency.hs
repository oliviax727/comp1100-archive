module Frequency where

-- | frequency:
-- Given an Integer number and a list of Integer values,
-- return the number of occurrences of the number in the list.
--
-- Examples:
-- >>> frequency 3 []
-- 0
--
-- >>> frequency 2 [2, 4]
-- 1
--
-- >>> frequency 5 [5]
-- 1
--
-- >>> frequency 3 [4, 5, 7]
-- 0
--
-- >>> frequency 5 [0, 5, 5, 11]
-- 2
frequency :: Integer -> [Integer] -> Int
frequency _ [] = 0
frequency a [b] = if a == b then 1 else 0
frequency a (b : bs) = if a == b then 1 + frequency a bs else frequency a bs
